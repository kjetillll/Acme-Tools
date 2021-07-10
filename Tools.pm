#!/usr/bin/perl
package Acme::Tools;

our $VERSION = '0.28';

use 5.008;     #Perl 5.8 released July 2002 (perldoc perlhist)
use strict;
use warnings;
use Carp;      #TODO? rid of deps, make own carp+croak here

require Exporter;
our @ISA = qw(Exporter);
our %EXPORT_TAGS = ( all => [ qw() ] );
our @EXPORT_OK = ( @{ $EXPORT_TAGS{all} } );
our @EXPORT = qw(
  min
  max
  mins
  maxs
  sum
  avg
  geomavg
  harmonicavg
  stddev
  rstddev
  median
  percentile
  $Resolve_iterations
  $Resolve_last_estimate
  $Resolve_time
  resolve
  resolve_equation
  conv
  rank
  rankstr
  egrep
  eqarr
  sorted
  sortedstr
  sortby
  subarrays
  hpush
  hpop
  pushsort
  pushsortstr
  binsearch
  binsearchstr
  random
  random_gauss
  random_exp
  random_poisson
  big
  bigi
  bigf
  bigr
  bigscale
  nvl
  repl
  replace
  decode
  decode_num
  between
  btw
  curb
  bound
  log10
  log2
  logn
  distinct
  in
  in_num
  uniq
  union
  union_all
  minus
  minus_all
  intersect
  intersect_all
  not_intersect
  mix
  zip
  sim
  sim_perm
  levdist
  jsim
  jwsim
  subarr
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
  ipnum_ok
  iprange_ok
  in_iprange
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
  basename
  dirname
  wipe
  username
  range
  globr
  permutations
  perm
  permute
  permute_continue
  trigram
  sliding
  chunks
  chars
  huffman
  huffman_pack
  huffman_unpack
  
  cart
  reduce
  int2roman
  roman2int
  num2code
  code2num
  dec2bin
  dec2hex
  dec2oct
  bin2dec
  bin2hex
  bin2oct
  hex2dec
  hex2bin
  hex2oct
  oct2dec
  oct2bin
  oct2hex
  base
  gcd
  lcm
  primes
  pivot
  tablestring
  tablestring_box
  upper
  lower
  trim
  rpad
  lpad
  cpad
  dserialize
  serialize
  srlz
  cnttbl
  nicenum
  bytes_readable
  sec_readable
  distance
  tms
  s2t
  easter
  time_fp
  timems
  sleep_fp
  sleeps
  sleepms
  sleepus
  sleepns
  eta
  sys
  recursed
  md5sum
  pwgen
  which
  read_conf
  openstr
  printed
  ldist
  $Re_isnum
  isnum
  part
  parth
  parta
  a2h
  h2a
  refa
  refh
  refs
  refaa
  refah
  refha
  refhh
  pushr
  popr
  shiftr
  unshiftr
  splicer
  keysr
  valuesr
  eachr
  joinr
  pile
  aoh2sql
  aoh2xls
  csv
  uncsv
  base64
  unbase64
  opts
  ed
  changed
  $Edcursor
  graph_scc
  brainfu
  brainfu2perl
  brainfu2perl_optimized
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
  $PI

  $Dbh
  dlogin
  dlogout
  drow
  drows
  drowc
  drowsc
  dcols
  dpk
  dsel
  ddo
  dins
  dupd
  ddel
  dcommit
  drollback
  install_tools
  install_acme_command_tools
);

#our $PI = log(640320**3+744)/sqrt(163); #nerdycool, 30 digit accuracy ... https://mathworld.wolfram.com/PiApproximations.html
our $PI = '3.141592653589793238462643383279502884197169399375105820974944592307816406286';

=head1 NAME

Acme::Tools - Lots of more or less useful subs lumped together and exported into your namespace

=head1 SYNOPSIS

 use Acme::Tools;

 print sum(1,2,3);                   # 6
 print avg(2,3,4,6);                 # 3.75
 print median(2,3,4,6);              # 3.5
 print percentile(25, 101..199);     # 125

 my @list = minus(\@listA, \@listB); # set operation
 my @list = union(\@listA, \@listB); # set operation

 print length(gzip("abc" x 1000));   # far less than 3000

 writefile("/dir/filename",$string); # convenient
 my $s=readfile("/dir/filename");    # also convenient

 print "yes!" if between($PI,3,4);

 print percentile(0.05, @numbers);

 my @even = range(1000,2000,2);      # even numbers between 1000 and 2000
 my @odd  = range(1001,2001,2);

 my $dice = random(1,6);
 my $color = random(['red','green','blue','yellow','orange']);

 pushr $arrayref[$num], @stuff;      # push @{ $arrayref[$num] }, @stuff ... popr, shiftr, unshiftr

 print 2**200;       # 1.60693804425899e+60
 print big(2)**200;  # 1606938044258990275541962092341162602522202993782792835301376

 ...and much more.

=encoding utf8

=head1 ABSTRACT

About 120 more or less useful perl subroutines lumped together and exported into your namespace.

=head1 DESCRIPTION

Subs created and collected since the mid-90s.

=head1 INSTALLATION

 sudo cpan Acme::Tools
 sudo cpanm Acme::Tools   # after: sudo apt-get install cpanminus make   # for Ubuntu 12.04

Or to get the very newest:

 git clone https://github.com/kjetillll/Acme-Tools.git
 cd Acme-Tools
 perl Makefile.PL
 make test
 sudo make install

Reported to work on Mac:

 sudo curl -L http://xrl.us/installperlosx | bash
 sudo brew install cpanminus
 sudo cpan Acme::Tools

=head1 EXPORT

Almost every sub, about 100 of them.

Beware of namespace pollution. But what did you expect from an Acme module?

=head1 NUMBERS

=head2 num2code

See L</code2num>

=head2 code2num

C<num2code()> convert numbers (integers) from the normal decimal system to some arbitrary other number system.
That can be binary (2), oct (8), hex (16) or others.

Example:

 print num2code(255,2,"0123456789ABCDEF");  # prints FF
 print num2code( 14,2,"0123456789ABCDEF");  # prints 0E

...because 255 are converted to hex FF (base C<< length("0123456789ABCDEF") >> ) which is 2 digits of 0-9 or A-F.
...and 14 are converted to 0E, with leading 0 because of the second argument 2.

Example:

 print num2code(1234,16,"01")

Prints the 16 binary digits 0000010011010010 which is 1234 converted to binary zeros and ones.

To convert back:

 print code2num("0000010011010010","01");  #prints 1234

C<num2code()> can be used to compress numeric IDs to something shorter:

 $chars="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_";
 print num2code("241274432",5,$chars);     # prints EOOv0
 print code2num("EOOv0",$chars);           # prints 241274432

=cut

#Math::BaseCnv

sub num2code {
  return num2code($_[0],0,$_[1]) if @_==2;
  my($num,$digits,$validchars,$start)=@_;
  my $l=length($validchars);
  my $key;
  $digits||=9e9;
  no warnings;
  croak if $num<$start;
  $num-=$start;
  for(1..$digits){
    $key=substr($validchars,$num%$l,1).$key;
    $num=int($num/$l);
    last if $digits==9e9 and !$num;
  }
  croak if $num>0;
  return $key;
}

sub code2num {
  my($code,$validchars,$start)=@_; $start=0 if!defined$start;
  my $l=length($validchars);
  my $num=0;
  $num=$num*$l+index($validchars,$_) for split//,$code;
  return $num+$start;
}

=head2 base

Numbers in any number system of base between 2 and 36. Using capital letters A-Z for base higher than 10.

 base(2,15)                 # 1111  2 --> binary
 base(8,4096)               # 10000 8 --> octal
 base(10,4096)              # 4096 of course
 base(16,254)               # FE   16 --> hex
 base(16,254.3)             # FE   16 --> hex, can not handle decimal numbers (yet...todo)
 base(36,123456)            # FE   16 --> hex, can not handle decimal numbers (yet...todo)
 base(36,1234567891011)     # FR5HUHC3  base36 using all 0-9 and A-Z as digits, 10+26=36
 base(37,1)                 # die with message 'base not 2-36'
 base($x,0)                 # 0
 base(16, 14,15,16,17)      # list of four elements: E F 10 11

=head2 dec2bin dec2hex dec2oct bin2dec bin2hex bin2oct hex2dec hex2bin hex2oct oct2dec oct2bin oct2hex

 print dec2bin(101);          # 1100101
 print dec2hex(101);          # 65
 print dec2oct(101);          # 145
 print bin2dec(1010011110);   # 670
 print bin2hex(1010011110);   # 29e
 print bin2oct(1010011110);   # 1236
 print hex2dec(101);          # 257
 print hex2bin(101);          # 100000001
 print hex2oct(101);          # 401
 print oct2dec(101);          # 65
 print oct2bin(101);          # 1000001
 print oct2hex(101);          # 41

=cut

sub _base{my($b,$n)=@_;$n?_base($b,int$n/$b).chr(48+$n%$b+7*($n%$b>9)):''} #codegolf
sub base {
  my($b,$n)=@_;
  @_>2        ? (map base($b,$_),@_[1..$#_])
 :$b<2||$b>36 ? croak"base not 2-36"
 :$n>0        ?     _base($b,$n)
 :$n<0        ? "-"._base($b,-$n)
 :!defined $n ? undef
 :$n==0       ? 0
 :              croak
}

sub dec2bin { sprintf"%b",shift           }
sub dec2hex { sprintf"%x",shift           }
sub dec2oct { sprintf"%o",shift           }
sub bin2dec {             oct("0b".shift) }
sub bin2hex { sprintf"%x",oct("0b".shift) }
sub bin2oct { sprintf"%o",oct("0b".shift) }
sub hex2dec {             hex(shift)      }
sub hex2bin { sprintf"%b",hex(shift)      }
sub hex2oct { sprintf"%o",hex(shift)      }
sub oct2dec {             oct(shift)      }
sub oct2bin { sprintf"%b",oct(shift)      }
sub oct2hex { sprintf"%x",oct(shift)      }


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
and the common ('overlapping') factors for both 12 and 8 is then 2 * 2 and the result becomes 4.

B<Example two>:

  print gcd(90, 135, 315);               # prints 45
  print gcd(2*3*3*5, 3*3*3*5, 3*3*5*7);  # prints 45 ( = 3*3*5 which is common to all three args)

Implementation:

 sub gcd { my($a,$b,@r)=@_; @r ? gcd($a,gcd($b,@r)) : $b==0 ? $a : gcd($b, $a % $b) }

One way of putting it: Keep replacing the larger of the two numbers with the difference between them until you got two equal numbers. Then thats the answer.

L<http://en.wikipedia.org/wiki/Greatest_common_divisor>

L<http://en.wikipedia.org/wiki/Euclidean_algorithm>

=cut

sub gcd { my($a,$b,@r)=@_; @r ? gcd($a,gcd($b,@r)) : $b==0 ? $a : gcd($b, $a % $b) }
#hm sub gcd { my($a,$b)=@_; ($a,$b)=($b,$a%$b) while $b; $a }

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

=head2 primes

B<Input:>

* positive number returns primes up to and perhaps including that number

* negative number returns that many of the first primes

B<Output:> a list of the first primes

Uses a sieve algorithm doing bitwise or's.

 primes(1000);  # 2, 3, 5, 7, 11, ..., 997
 primes(997);   # 2, 3, 5, 7, 11, ..., 997
 primes(-168);  # 2, 3, 5, 7, 11, ..., 997      (168 primes)
 primes(-2);    # 2, 3
 primes(-1);    # 2
 primes(0);     # empty list
 primes(1);     # empty list
 primes(2);     # 2
 primes(3);     # 2, 3
 primes(1e6);   # returns a list of the first 78498 primes

=cut

sub primes {
  my $n = shift;
  return (2,3) if $n==-2;
  return (2)   if $n==-1 or $n==2;
  return ()    if $n==0  or $n==1;
  return (primes(do{my$N=-$n;$N*=1.1while$N/log($N)<-1.2*$n;$N}))[0..-$n-1] if $n<0;
  my( $q,$factor,$repeat,$bits ) =( sqrt($n), 1, 1, 0 x $n );
  while ( $factor <= $q ) {
    $factor += 2;
    $factor += 2 while $factor < $n and substr($bits,$factor,1);
    $repeat .= 0 x (2*$factor-length$repeat);
    my $times = -($factor**2-length$bits)/2/$factor + 1;
    $bits |= 0 x $factor**2  .  ($times>0?$repeat x $times:'');
  }
  @{[2,map$_*2+1,grep!substr($bits,1+$_*2,1),1..$n/2-.5]};
}


=head2 resolve

Resolves an equation by Newtons method.

B<Input:> 1-6 arguments. At least one argument.

First argument: must be a coderef to a subroutine (a function)

Second argument: if present, the target, f(x)=target. Default 0.

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

 print resolve(sub{ $_**2 - 4*$_ - 21 });                     # -3 with $_ as your x
 print resolve(sub{ my $x=shift; $x**2 - 4*$x - 21 });        # -3 more elaborate call
 print resolve(sub{ my $x=shift; $x**2 - 4*$x - 21 },0,3);    # 7  with start position 3
 print "Iterations: $Acme::Tools::Resolve_iterations\n";      # 3 or larger, about 10-15 is normal

The variable C< $Acme::Tools::Resolve_iterations > (which is exported) will be set
to the last number of iterations C<resolve> used. Also if C<resolve> dies (carps).

The variable C< $Acme::Tools::Resolve_last_estimate > (which is exported) will be
set to the last estimate. This number will often be close to the solution and can
be used even if C<resolve> dies (carps).

B<BigFloat-example:>

If either second, third or fourth argument is an instance of L<Math::BigFloat>, so will the result be:

 use Acme::Tools;
 my $equation = sub{ $_ - 1 - 1/$_ };
 my $gr1 = resolve( $equation, 0,      1  ); #
 my $gr2 = resolve( $equation, 0, bigf(1) ); # 1/2 + sqrt(5)/2
 bigscale(50);
 my $gr3 = resolve( $equation, 0, bigf(1) ); # 1/2 + sqrt(5)/2

 print 1/2 + sqrt(5)/2, "\n";
 print "Golden ratio 1: $gr1\n";
 print "Golden ratio 2: $gr2\n";
 print "Golden ratio 3: $gr3\n";

Output:

 1.61803398874989
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
our $Resolve_time;

#sub resolve(\[&$]@) {
#sub resolve(&@) { <=0.17
#todo: perl -MAcme::Tools -le'print resolve(sub{$_[0]**2-9431**2});print$Acme::Tools::Resolve_iterations'
#todo: perl -MAcme::Tools -le'sub d{5.3*1.0094**$_[0]-10.2*1.0072**$_[0]} print resolve(\&d)' #err, pop norway vs sweden
#todo: perl -MAcme::Tools -le' print resolve(sub{5.3*1.0094**$_[0]-10.2*1.0072**$_[0]})' #err, pop norway vs sweden
#    =>Div by zero: df(x) = 0 at n'th iteration, n=0, delta=0.0001, fx=CODE(0xc81d470) at -e line 1
#todo: ren solve?
sub resolve {
  my($f,$goal,$start,$delta,$iters,$sec)=@_;
  $goal=0      if!defined$goal;
  $start=0     if!defined$start;
  $delta=1e-4  if!defined$delta;
  $iters=100   if!defined$iters;
  $sec=0       if!defined$sec;
  $iters=13e13 if $iters==0;
  croak "Iterations ($iters) or seconds ($sec) can not be a negative number" if $iters<0 or $sec<0;
  $Resolve_iterations=undef;
  $Resolve_last_estimate=undef;
  croak "Should have at least 1 argument, a coderef" if !@_;
  croak "First argument should be a coderef" if ref($f) ne 'CODE';

  my @x=($start);
  my $time_start=$sec>0?time_fp():undef;
  my $ds=ref($start) eq 'Math::BigFloat' ? Math::BigFloat->div_scale() : undef;
  my $fx=sub{
    local$_=$_[0];
    my $fx=&$f($_);
    if($fx=~/x/ and $fx=~/^[ \(\)\.\d\+\-\*\/x\=\^]+$/){
      $fx=~s/(\d)x/$1*x/g;
      $fx=~s/\^/**/g;
      $fx=~s/^(.*)=(.*)$/($1)-($2)/;
      $fx=~s,x,\$_,g;
      $f=eval"sub{$fx}";
      $fx=&$f($_);
    }
    $fx
  };
  #warn "delta=$delta\n";
  my $n=0;
  while($n<=$iters-1){
    my $fd= &$fx($x[$n]+$delta*0.5) - &$fx($x[$n]-$delta*0.5);
    $fd   = &$fx($x[$n]+$delta*0.7) - &$fx($x[$n]-$delta*0.3) if $fd==0;# and warn"wigle 1\n";
    $fd   = &$fx($x[$n]+$delta*0.2) - &$fx($x[$n]-$delta*0.8) if $fd==0;# and warn"wigle 2\n";
    croak "Div by zero: df(x) = $x[$n] at n'th iteration, n=$n, delta=$delta, fx=$fx" if $fd==0;
    $x[$n+1]=$x[$n]-(&$fx($x[$n])-$goal)/($fd/$delta);
    $Resolve_last_estimate=$x[$n+1];
    #warn "n=$n  fd=$fd  x=$x[$n+1]\n";
    $Resolve_iterations=$n;
    last if $n>3 and $x[$n+1]==$x[$n] and $x[$n]==$x[$n-1];
    last if $n>4 and $x[$n]!=0 and abs(1-$x[$n+1]/$x[$n])<1e-13; #sub{3*$_+$_**4-12}
    last if $n>3 and ref($x[$n+1]) eq 'Math::BigFloat' and substr($x[$n+1],0,$ds) eq substr($x[$n],0,$ds); #hm
    croak "Could not resolve, perhaps too little time given ($sec), iteratons=$n"
      if $sec>0 and ($Resolve_time=time_fp()-$time_start)>$sec;
    #warn "$n: ".$x[$n+1]."\n";
    $n++;
  }
  croak "Could not resolve, perhaps too few iterations ($iters)" if @x>=$iters;
  return $x[-1];
}

=head2 resolve_equation

This prints 2:

 print resolve_equation "x + 13*(3-x) = 17 - x"

A string containing at least one x is converted into a perl function.
Then x is found by using L<resolve>. The string conversion is done by
replacing every x with $_ and if a C< = > char is present it converts
C< leftside = rightside > into C< (leftside) - (rightside) = 0 > which
is the default behaviour of L<resolve>.

=cut

sub resolve_equation { my $e=shift;resolve(sub{$e},@_)}

=head2 conv

Converts between:

=over 4

=item * units of measurement

=item * number systems

=item * currencies

=back

B<Examples:>

 print conv( 2000, "meters", "miles" );  #prints 1.24274238447467
 print conv( 2.1, 'km', 'm');            #prints 2100
 print conv( 70,"cm","in");              #prints 27.5590551181102
 print conv( 4,"USD","EUR");             #prints 3.20481552905431 (depending on todays rates)
 print conv( 4000,"b","kb");             #prints 3.90625 (1 kb = 1024 bytes)
 print conv( 4000,"b","Kb");             #prints 4       (1 Kb = 1000 bytes)
 print conv( 1000,"mb","kb");            #prints 1024000
 print conv( 101010,"bin","roman");      #prints XLII
 print conv( "DCCXLII","roman","oct");   #prints 1346

B<Units, types of measurement and currencies supported by C<conv> are:>

Note: units starting with the symbol _ means that all metric
prefixes from yocto 10^-24 to yotta 10^+24 is supported, so _m means
km, cm, mm, µm and so on. And _N means kN, MN GN and so on.

Note2: Many units have synonyms: m, meter, meters ...

 acceleration: g, g0, m/s2, mps2

 angle:        binary_degree, binary_radian, brad, deg, degree, degrees,
               gon, grad, grade, gradian, gradians, hexacontade, hour,
               new_degree, nygrad, point, quadrant, rad, radian, radians,
               sextant, turn

 area:         a, ar, are, ares, bunder, ca, centiare, cho, cm2,
               daa, decare, decares, deciare, dekar,
               djerib, m2, dunam, dönöm, earths, feddan, ft2, gongqing, ha
               ha, hectare, hectares, hektar, jerib, km2, m2, manzana,
               mi2, mm2, mu, qing, rai, sotka,
               sqcm, sqft, sqkm, sqm, sqmi, sqmm
               stremmata, um2, µm2

 bytes:        Eb, Gb, Kb, KiB, Mb, Pb, Tb, Yb, Zb, b, byte,
               kb, kilobyte,  mb, megabyte,
               gb, gigabyte,  tb, terabyte,
               pb, petabyte,  eb, exabyte,
               zb, zettabyte, yb, yottabyte

 charge:       As, C, _e, coulomb, e

 current:      A, _A, N/m2

 energy:       BTU, Btu, J, Nm, W/s, Wh, Wps, Ws, _J, _eV,
               cal, calorie, calories, eV, electronvolt, BeV,
               erg, ergs, foot-pound, foot-pounds, ftlb, joule, kWh, MWh, GWh, TWh
               kcal, kilocalorie, kilocalories,
               newtonmeter, newtonmeters, th, thermie

 force:        N, _N, dyn, dyne, dynes, lb, newton

 length:       NM, _m, _pc, astronomical unit, au, chain, ft, furlong,
               in, inch, inches, km, league, lightyear, ls, ly,
               m, meter, meters, mi, mil, mile, miles,
               nautical mile, nautical miles, nmi,
               parsec, pc, planck, yard, yard_imperical, yd, Å, ångstrøm, angstrom

 mass:         Da, _eV, _g, bag, carat, ct, dwt, eV, electronvolt, g,
               grain, grains, gram, grams, kilo, kilos, kt, lb, lb_av,
               lb_t, lb_troy, lbs, ounce, ounce_av, ounce_troy, oz, oz_av, oz_t,
               pennyweight, pound, pound_av, pound_metric, pound_troy, pounds,
               pwt, seer, sl, slug, solar_mass, st, stone, t, tonn, tonne, tonnes, u, wey

 mileage:      mpg, l/100km, l/km, l/10km, lp10km, l/mil, liter_pr_100km, liter_pr_km, lp100km

 money:        AED, ARS, AUD, BGN, BHD, BND, BRL, BWP, CAD, CHF, CLP, CNY,
               COP, CZK, DKK, EUR, GBP, HKD, HRK, HUF, IDR, ILS, INR, IRR,
               ISK, JPY, KRW, KWD, KZT, LKR, LTL, LVL, LYD, MUR, MXN, MYR,
               NOK, NPR, NZD, OMR, PHP, PKR, PLN, QAR, RON, RUB, SAR, SEK,
               SGD, THB, TRY, TTD, TWD, USD, VEF, ZAR,      BTC, LTC, mBTC, XBT
               Currency rates are automatically updated from the net
               at least every 24h since last update (on linux/cygwin).

 numbers:      dec, hex, bin, oct, roman, dozen, doz, dz, dusin, gross, gro,
               gr, great_gross, small_gross  (not supported: decimal numbers)

 power:        BTU, BTU/h, BTU/s, BTUph, GWhpy, J/s, Jps, MWhpy, TWhpy,
               W, Whpy, _W, ftlb/min, ftlb/s, hk, hp, kWh/yr, kWhpy

 pressure:     N/m2, Pa, _Pa, at, atm, bar, mbar, pascal, psi, torr

 radioactivity: Bq, becquerel, curie

 speed:        _m/s, km/h, km/t, kmh, kmph, kmt, m/s, mi/h, mph, mps,
               kn, knot, knots, kt, kts, mach, machs, c, fps, ft/s, ftps

 temperature:  C, F, K, celsius, fahrenheit, kelvin

 time:         _s, biennium, century, d, day, days, decade, dy, fortnight,
               h, hour, hours, hr, indiction, jubilee, ke, lustrum, m,
               millennium, min, minute, minutes, mo, moment, mon, month,
               olympiad, quarter, s, season, sec, second, seconds, shake,
               tp, triennium, w, week, weeks, y, y365, ySI, ycommon,
               year, years, ygregorian, yjulian, ysideral, ytropical

 volume:        l, L, _L, _l, cm3, m3, ft3, in3, liter, liters, litre, litres,
                gal, gallon, gallon_imp, gallon_uk, gallon_us, gallons,
                pint, pint_imp, pint_uk, pint_us, tsp, tablespoon, teaspoon,
                floz, floz_uk, therm, thm, fat, bbl, Mbbl, MMbbl, drum,
                container (or container20), container40, container40HC, container45HC

See: L<http://en.wikipedia.org/wiki/Units_of_measurement>

=cut

#TODO:  @arr2=conv(\@arr1,"from","to")         # should be way faster than:
#TODO:  @arr2=map conv($_,"from","to"),@arr1
#TODO:  conv(123456789,'b','h'); # h converts to something human-readable

our %conv=(
	 length=>{
		  m       => 1,
		  _m      => 1,
		  meter   => 1,
		  meters  => 1,
		  metre   => 1,
		  metres  => 1,
#		  km      => 1000,
		  mil     => 10000,                   #scandinavian #also: inch/1000!
		  in      => 0.0254,
		  inch    => 0.0254,
		  inches  => 0.0254,
		  ft      => 0.0254*12,               #0.3048 m
		  feet    => 0.0254*12,               #0.3048 m
		  yd      => 0.0254*12*3,             #0.9144 m
		  yard    => 0.0254*12*3,             #0.9144 m
		  yards   => 0.0254*12*3,             #0.9144 m
		  fathom  => 0.0254*12*3*2,           #1.8288 m
		  fathoms => 0.0254*12*3*2,           #1.8288 m
		  chain   => 0.0254*12*3*22,          #20.1168 m
		  chains  => 0.0254*12*3*22,          #20.1168 m
		  furlong => 0.0254*12*3*22*10,       #201.168 m
		  furlongs=> 0.0254*12*3*22*10,       #201.168 m
		  mi      => 0.0254*12*3*22*10*8,     #1609.344 m
		  mile    => 0.0254*12*3*22*10*8,     #1609.344 m
		  miles   => 0.0254*12*3*22*10*8,
		  league  => 0.0254*12*3*22*10*8*3,   #4828.032 m
		  leagues => 0.0254*12*3*22*10*8*3,   #4828.032 m
		  yard_imp           => 0.914398416,
		  yard_imperical     => 0.914398416,
                  NM                 => 1852,           #nautical mile
                  nmi                => 1852,           #nautical mile
                  'nautical mile'    => 1852,
                  'nautical miles'   => 1852,
		  micron             => 1e-6,
		  microns            => 1e-6,
		  micrometre         => 1e-6,
		  micrometres        => 1e-6,
		  micrometer         => 1e-6,
		  micrometers        => 1e-6,
		  'μm'               => 1e-6,
		  'μmeter'           => 1e-6,
		  'μmeters'          => 1e-6,
                  'Å'                => 1e-10,
                  'ångstrøm'         => 1e-10,
                  'angstrom'         => 1e-10,
		  fm                 => 1e-15,
		  fermi              => 1e-15, #in honour of Enrico Fermi
		  fermis             => 1e-15, #in honour of Enrico Fermi
		  femtometer         => 1e-15, #derived from "femten" (=fifteen in Norwegian and Danish)
		  femtometre         => 1e-15,
		  femtometers        => 1e-15, #derived from "femten" (=fifteen in Norwegian and Danish)
		  femtometres        => 1e-15,
		  attometer          => 1e-18, #derived from "atten/atton" (=eighteen)
		  attometre          => 1e-18,
		  attometers         => 1e-18, #derived from "atten/atton" (=eighteen)
		  attometres         => 1e-18,
		  ly                 => 299792458*3600*24*365.25,
		  lightyear          => 299792458*3600*24*365.25, # = 9460730472580800 by def
		  ls                 => 299792458,      #light-second
                  au                 => 149597870700,   # by def: meters earth to sun
                  astronomical_unit  => 149597870700,
                 'astronomical unit' => 149597870700,
                  pc                 => 149597870700*648000/$PI, #3.0857e16 = 3.26156 ly
                 _pc                 => 149597870700*648000/$PI,
                  parsec             => 149597870700*648000/$PI,
		  attoparsec         => 149597870700*648000/$PI/1e18,
		  apc                => 149597870700*648000/$PI/1e18,
		  planck             => 1.61619997e-35, #planck length
		  #Norwegian (old) lengths:
		  tomme         => 0.0254,
		  tommer        => 0.0254,
		  fot           => 0.0254*12,               #0.3048m
		  alen          => 0.0254*12*2,             #0.6096m
		  favn          => 0.0254*12*2*3,           #1.8288m
		  kvart         => 0.0254*12*2/4,           #0.1524m a quarter alen
		 #sjømil_pre1875=> 0.0254*12*2*3*3950,      #3950 favner
		 #sjømil        => 7420,                    #1 geografisk mil = 1⁄15 ekvatorgrad = 7420 meter
                  #--https://upload.wikimedia.org/wikipedia/commons/e/eb/English_length_units_graph.svg
                  twip          => 0.0254 / 6 / 12 / 20,
                  point         => 0.0254 / 6 / 12,
                  pica          => 0.0254 / 6,
                  line          => 0.0254 / 12,
		  thou          => 0.0254 / 1000,
                  barleycorn    => 0.0254 / 3,
                  poppyseed     => 0.0254 / 3 / 4,
                  finger        => 0.0254 / 6 / 12 * 63,
                  palm          => 0.0254 * 3,
                  digit         => 0.0254 * 3 / 4,
                  nail          => 0.0254 * 3 / 4 * 3,
                  rack          => 0.0254 * 1.75,
                  stick         => 0.0254 * 2,
                  hand          => 0.0254 * 2 * 2,
                  foot          => 0.0254 * 2 * 2 * 3,
                  shaftment     => 0.0254 * 3 * 2,
                  span          => 0.0254 * 3 * 3,
                  ell           => 0.0254 * 3 * 3 * 5,
                  pace          => 0.0254 * 3 * 2 * 5,
                  step          => 0.0254 * 3 * 2 * 5,
                  cubit         => 0.0254 * 3 * 2 * 3,
                  rod           => 0.0254 * 3 * 2 * 3 * 11,
                  link          => 0.0254 * 3 * 2 * 3 * 11 / 25,
		  yard          => 0.0254 * 2 * 2 * 3 * 3,
                  grade         => 0.0254 * 3 * 2 * 5 * 2,
                  rope          => 0.0254 * 3 * 2 * 5 * 2 * 4,
                  skein         => 0.0254 * 3 * 3 * 5 * 96,                   # 96 ell
                  fathom        => 0.0254 * 2 * 2 * 3 * 3 * 2,                # 2 yard
                  spindle       => 0.0254 * 3 * 3 * 5 * 96 * 120,             # 120 skein
                  gunter_chain  => 0.0254 * 2 * 2 * 3 * 3 * 2 * 11,           # 11 fathom
                  ramsden_chain => 0.0254 * 3 * 2 * 5 * 2 * 4 * 5,            # 5 rope
                  shackle       => 0.0254 * 2 * 2 * 3 * 3 * 2 * 15,           # 15 fathom
                  cable         => 0.0254 * 2 * 2 * 3 * 3 * 2 * 100,          # 100 fathom
                  furlong       => 0.0254 * 2 * 2 * 3 * 3 * 2 * 11 * 10,      # 10 gunter_chain, 220 yard
                  roman_mile    => 0.0254 * 3 * 2 * 5 * 2 * 4 * 5 * 50,       # 50 ramsden_chain
                  statute_mile  => 0.0254 * 2 * 2 * 3 * 3 * 2 * 11 * 10 * 8,  # 8 furlong
                  nautic_mile   => 0.0254 * 2 * 2 * 3 * 3 * 2 * 100 * 10,     # 10 cable
                  league        => 0.0254 * 2 * 2 * 3 * 3 * 2 * 100 * 10 * 5, # 5 nautic_mile
		  siriometer    => 149597870700*1e6,                          # 1 million astronomical units
		 },
	 mass  =>{ #https://en.wikipedia.org/wiki/Unit_conversion#Mass
		  g            => 1,
		  _g           => 1,
		  gram         => 1,
		  grams        => 1,
		  kilo         => 1000,
		  kilos        => 1000,
		  t            => 1000000,
		  tonn         => 1000000,
		  tonne        => 1000000,
		  tonnes       => 1000000,
		  seer         => 933.1,          # ~14400 grains (if 933.104304), India, Aden, Saudi-Arabia
		  maund        => 37320,          # avg of Indias different mauds, ~ 40 x seer
		  lb           => 453.59237,      # ~453g
		  lbs          => 453.59237,
		  lbm          => 453.59237,
		  lb_av        => 453.59237,
		  lb_t         => 373.2417216,
		  lb_troy      => 373.2417216,    # 5760 grains = 453.59237*144/175
		  pound        => 453.59237,      # 7000 grains
		  pounds       => 453.59237,
                  pound_av     => 453.59237,
                  pound_troy   => 373.2417216,    # ~373g
                  pound_metric => 500,            # 0.5kg
		  ounce        => 28,             # US food, 28g
		  ounce_av     => 453.59237/16,   # avoirdupois  lb/16 = 28.349523125g
		  ounce_troy   => 31.1034768,     # lb_troy / 12
		  oz           => 28,             # US food, 28g
		  oz_av        => 453.59237/16,   # avoirdupois  lb/16 = 28.349523125g
		  oz_t         => 31.1034768,     # lb_troy / 12,
		  grain        => 453.59237/7000, # 64.79891/1000, # 
		  grains       => 64.79891/1000,
                  pennyweight  => 31.1034768 / 20,
                  pwt          => 31.1034768 / 20,
                  dwt          => 31.1034768 / 20,
                  stone        => 453.59237*14,             # 6.35029318 kg
                  st           => 453.59237*14,             # 14 lb_av
		  wey          => 453.59237*14*18,          # 252 lb = 18 stone = 114.30527724 kg
                  carat        => 0.2,
                  ct           => 0.2,                      #carat (metric)
                  kt           => 64.79891/1000 * (3+1/6),  #carat/karat
                  u            => 1.66053892173e-30, #atomic mass carbon-12
                  Da           => 1.66053892173e-30, #atomic mass carbon-12
    		  slug         => 14600,
    		  sl           => 14600,
                  eV           => 1.78266172802679e-33,    #e=mc2 = 1.60217646e-19 J / (2.99792458e8 m/s)**2
                  _eV          => 1.78266172802679e-33,
		  electronvolt => 1.78266172802679e-33,
                 'solar mass'  => 1.99e33,
                  solar_mass   => 1.99e33,
                  bag          => 60*1000,           #60kg coffee
		  firkin       => 90 * 453.59237,    #90lb
		 },
	 area  =>{               # https://en.wikipedia.org/wiki/Unit_conversion#Area
                  m2      => 1,
                  dm2     => 0.1**2,
                  cm2     => 0.01**2,
                  mm2     => 0.001**2,
		 'µm2'    => 1e-6**2,
		  um2     => 1e-6**2,
                  sqm     => 1,
                  sqcm    => 0.01**2,
                  sqmm    => 0.001**2,
                  km2     => 1000**2,
                  sqkm    => 1000**2,
                  a       => 100,
                  ar      => 100,
                  are     => 100,
                  ares    => 100,
                  dekar   => 1000,
                  decare  => 1000,
                  decares => 1000,
                  daa     => 1000,
                 'mål'    => 1000,
                  ha      => 10000,
                  hektar  => 10000,
                  hectare => 10000,
                  hectares=> 10000,
                  in2     => 0.0254**2,
                  inch2   => 0.0254**2,
                  ft2     => (0.0254*12)**2,
                  sqft    => (0.0254*12)**2,
		  mi2     => 1609.344**2,
		  mile2   => 1609.344**2,
		  miles2  => 1609.344**2,
		  sqmi    => 1609.344**2,
                  yd2     => (0.0254*12*3)**2, #square yard
                  sqyd    => (0.0254*12*3)**2,
                  yard2   => (0.0254*12*3)**2,
                  sqyard  => (0.0254*12*3)**2,
                  rood      => 1210*(0.0254*12*3)**2,  # 1/4 acres
                  roods     => 1210*(0.0254*12*3)**2,  # 1/4 acres
		  ac        => 4840*(0.0254*12*3)**2,  # 4840 square yards = 1 chain x 1 furlong
		  acre      => 4840*(0.0254*12*3)**2,
		  acres     => 4840*(0.0254*12*3)**2,
                  homestead => 4840*(0.0254*12)**2 *160,      #160 acres US Surveyors or 1/4 sqmiles
                  township  => 4840*(0.0254*12)**2 *160*144,  #144 homesteads or 36 sqmiles
                  perches   => 4840*(0.0254*12)**2 /160,      #160 perches = 1 acre in sri lanka
		  sotka     => 100,       #russian are
                  jerib     => 10000,     #iran hectare
                  djerib    => 10000,     #turkish hectare
		  gongqing  => 10000,     #chinese hectare
                  manzana   => 10000,     #argentinian hectare
                  bunder    => 10000,     #dutch hectare
                  centiare  => 1,
                  deciare   => 10,
                  ca        => 1,
                  mu        => 10000/15,    #China
                  qing      => 10000/0.15,  #China
                  dunam     => 10000/10,    #Middle East
                 'dönüm'    => 10000/10,    #Middle East
                  stremmata => 10000/10,    #Greece
                  rai       => 10000/6.25,  #Thailand
                  cho       => 10000/1.008, #Japan
                  feddan    => 10000/2.381, #Egypt
                  earths    => 510072000e6, #510072000 km2, surface area of earth
                  barn      => 1e-28,       #physics
                  outhouse  => 1e-34,       #physics
                  shed      => 1e-52,       #physics
		  brass     => 100*(0.0254*12)**2, #100 square feet ~ 9.29 m2
		  square    => 100*(0.0254*12)**2, #100 square feet ~ 9.29 m2
		  morgen    => 0.856532 * 10000,   #0.856532 hectares
		  bornholm  => 588.36e6,           #area of danish island bornholm, 588km2
		  texas     => 695670e6,           #area of texas, 695 670 square km
        	 },
	 volume=>{
		  m3            => 1,                #1000 L
		  l             => 0.001,
		  L             => 0.001,
		  _L            => 0.001,
		  _l            => 0.001,
		  liter         => 0.001,
		  liters        => 0.001,
		  litre         => 0.001,
		  litres        => 0.001,
		  gal           => 231 * 0.0254**3, #3.785411784 L = 0.003785411784 m3, #231 cubic inches
		  gallon        => 231 * 0.0254**3,
		  gallons       => 231 * 0.0254**3,
		  gallon_us     => 231 * 0.0254**3, #231 cubic inches
		  gallon_wine   => 231 * 0.0254**3, #queen anne's gallon
		  gallon_ale    => 282 * 0.0254**3, #beer
		  gallon_corn   => 268.8*0.0254**3, #corn, or winchester gallon
		  gallon_uk     => 4.54609/1000,    #constant 4.54609 from definition
		  gallon_imp    => 4.54609/1000,    #imperial
		  gallon_us_dry => 4.40488377086/1000, # ~ 9.25**2*pi*2.54**3/1000 L
		  #hogshead, gill, pail, jigger, jackpot, The Science of Measurement - A Historical Survey (Klein)
		  cm3       => 0.01**3,               #0.001 L
                  in3       => 0.0254**3,             #0.016387064 L
                  ft3       => (0.0254*12)**3,
		  tablespoon=> 3.785411784/256,       #14.78676478125 mL
		  tsp       => 3.785411784/256/3,     #4.92892159375 mL
		  teaspoon  => 3.785411784/256/3,     #4.92892159375 mL
                  floz      => 3.785411784/128,       #fluid ounce US
                  floz_uk   => 4.54609/160,           #fluid ounce UK
                  pint      => 4.54609/8000,          #0.56826125 L
                  pint_uk   => 4.54609/8000,
                  pint_imp  => 4.54609/8000,
                  pint_us   => 3.785411784/8000,      #0.473176473
		  quart     => 4.54609/4000,             #2*pint
		  pottle    => 4.54609/2000,             #2*quart = gallon_uk/2
		 #therm     => 2.74,                #? 100000BTUs?   (!= thermie)
		 #thm       => 2.74,                #?               (!= th)
                  fat       => 42*231*2.54**3/1e6,
                  bbl       => 42*231*2.54**3/1e6,  #oil barrel ~159 liters https://en.wikipedia.org/wiki/Barrel_(unit)
		  Mbbl      => 42*231*2.54**3/1e3,  #mille (thousand) oil barrels, M er mille her, ikke mega!
		  MMbbl     => 42*231*2.54**3,      #mille mille (million) oil barrels
		  drum      => 0.208,               #208 L
		  container     => 33.1e3,  #container20
		  container20   => 33.1e3,
		  container40   => 67.5e3,
		  container40HC => 75.3e3,
		  container45HC => 86.1e3,
		  firkin        => 282*0.0254**3 * 8, #8 gallon_ale
		  #Norwegian:
                  meterfavn => 2 * 2 * 0.6,           #fire wood/ved 2.4 m3
                  storfavn  => 2 * 2 * 3,             #fire wood/ved 12 m3
		  #https://no.wikipedia.org/wiki/Pipe_(m%C3%A5l)
		 },
	 time  =>{
		  s           => 1,
		  _s          => 1,
		  sec         => 1,
		  second      => 1,
		  seconds     => 1,
		  m           => 60,
		  min         => 60,
		  minute      => 60,
		  minutes     => 60,
		  h           => 60*60,
		  hr          => 60*60,
		  hour        => 60*60,
		  hours       => 60*60,
		  d           => 60*60*24,
		  dy          => 60*60*24,
		  day         => 60*60*24,
		  days        => 60*60*24,
		  w           => 60*60*24*7,
		  week        => 60*60*24*7,
		  weeks       => 60*60*24*7,
		  mo	      => 60*60*24 * 365.2425/12,
		  mon	      => 60*60*24 * 365.2425/12,
		  month	      => 60*60*24 * 365.2425/12,
		  quarter     => 60*60*24 * 365.2425/12 * 3, #3 months
		  season      => 60*60*24 * 365.2425/12 * 3, #3 months
		  y           => 60*60*24 * 365.2425, # 365+97/400    #97 leap yers in 400 years
		  year        => 60*60*24 * 365.2425,
		  years       => 60*60*24 * 365.2425,
		  yjulian     => 60*60*24 * 365.25,   # 365+1/4
		  y365        => 60*60*24 * 365,      # finance/science
		  ycommon     => 60*60*24 * 365,      # finance/science
		  ygregorian  => 60*60*24 * 365.2425, # 365+97/400
		 #ygaussian   => 365+(6*3600+9*60+56)/(24*3600),  # 365+97/400
                  ytropical   => 60*60*24 * 365.24219,
                  ysideral    => 365.256363004,
		  ySI         => 60*60*24*365.25, #31556925.9747
                  decade      =>   10 * 60*60*24*365.2425,
                  biennium    =>    2 * 60*60*24*365.2425,
                  triennium   =>    3 * 60*60*24*365.2425,
                  olympiad    =>    4 * 60*60*24*365.2425,
                  lustrum     =>    5 * 60*60*24*365.2425,
                  indiction   =>   15 * 60*60*24*365.2425,
		  jubilee     =>   50 * 60*60*24*365.2425,
		  century     =>  100 * 60*60*24*365.2425,
		  millennium  => 1000 * 60*60*24*365.2425,
                  shake       => 1e-8,
                  moment      => 3600/40,  #1/40th of an hour, used by Medieval Western European computists
		  ke          => 864,      #1/100th of a day, trad Chinese, 14m24s
		  fortnight   => 14*24*3600,
                  tp          => 5.3910632e-44,  #planck time, time for ligth to travel 1 planck length
		  nanocentury =>  100 * 60*60*24*365.2425 / 1e9,   #3.156 ~ pi seconds, response time limit (usability)
		  warhol      => 15*60,                            #"fifteen minutes of fame"
		 },
          speed=>{
                 'm/s'      => 1,
                '_m/s'      => 1,
                  mps       => 1,
                  mph       => 1609.344/3600,
                 'mi/h'     => 1609.344/3600,
                  kmh       => 1/3.6,
                  kmph      => 1/3.6,
                 'km/h'     => 1/3.6,
                  kmt       => 1/3.6, # t=time(=hour) or temps (scandinavian and french and dutch)
                 'km/t'     => 1/3.6,
 		  kt        => 1852/3600,
 		  kts       => 1852/3600,
 		  kn        => 1852/3600,
 		  knot      => 1852/3600,
 		  knots     => 1852/3600,
 		  knop      => 1852/3600,    #scandinavian
		  c         => 299792458,    #speed of light, exact due to definition of meter
		  mach      => 340.3,        #speed of sound
		  machs     => 340.3,
                  fps       => 0.3048, #0.0254*12
                  ftps      => 0.3048,
                 'ft/s'     => 0.3048,
                 },
	  acceleration=>{
                 'm/s2'     => 1,
                 'mps2'     => 1,
                  g         => 9.80665,
                  g0        => 9.80665,
                  #0-100kmh or ca 0-60 mph x seconds...
                 },
         temperature=>{  #http://en.wikipedia.org/wiki/Temperature#Conversion
                  C=>1, F=>1, K=>1, celsius=>1, fahrenheit=>1, kelvin=>1
                 },
         radioactivity=>{
                  Bq          => 1,
		  becquerel   => 1,
		  curie       => 3.7e10,
                 },
         current=> {
                  A     => 1,
                  _A    => 1,
                 'N/m2' => 2e-7,
	         },
         charge=>{
                  e       => 1,
                  _e      => 1,
                  C       => 6.24150964712042e+18,
                  coulomb => 6.24150964712042e+18,
                  As      => 6.24150964712042e+18,
                 #Faraday unit of charge ???
                 },
         power=> {
                  W        => 1,
 		  _W       => 1,
                 'J/s'     => 1,
                  Jps      => 1,
                  hp       => 746,
                  hk       => 746,        #hestekrefter (norwegian, scandinavian)
		  PS       => 746/1.014,  #pferdestärken
		 'kWh/yr'  => 1000    * 3600/(24*365), #kWh annually
                  Whpy     =>           3600/(24*365), #kWh annually
                  kWhpy    => 1000    * 3600/(24*365), #kWh annually
                  MWhpy    => 1000**2 * 3600/(24*365), #kWh annually
                  GWhpy    => 1000**3 * 3600/(24*365), #kWh annually
                  TWhpy    => 1000**4 * 3600/(24*365), #kWh annually
		  BTU      => 1055.05585262/3600,                    #
		  BTUph    => 1055.05585262/3600,
		 'BTU/h'   => 1055.05585262/3600,
		 'BTU/s'   => 1055.05585262,
		 'ftlb/s'  => 746/550,
		 'ftlb/min'=> 746/550/60,
                 },
         energy=>{
                   joule        => 1,
                   J            => 1,
                   _J           => 1,
                   Ws           => 1,
                   Wps          => 1,
                  'W/s'         => 1,
                   Nm           => 1,
                   newtonmeter  => 1,
                   newtonmeters => 1,
                   Wh           => 3600,             #3600 J (joules)
                   kWh          => 3600000,          #3.6 million J
                   MWh          => 3600000000,       #3.6 billion J
                   GWh          => 3600000000000,    #3.6 trillion J
                   TWh          => 3600000000000000, #3600 trillion J
                   cal          => 4.1868,           # ~ 3600/860
		   calorie      => 4.1868,
		   calories     => 4.1868,
                   kcal         => 4.1868*1000,
		   kilocalorie  => 4.1868*1000,
		   kilocalories => 4.1868*1000,
		   BTU          => 4.1868 * 252, # = 1055.0736 or is 1055.05585262 right?
		   Btu          => 4.1868 * 252,
		   ftlb         => 746/550,      # ~ 1/0.7375621
		  'foot-pound'  => 746/550,
		  'foot-pounds' => 746/550,
		   erg          => 1e-7,
		   ergs         => 1e-7,
                   eV           => 1.60217656535e-19,
                   _eV          => 1.60217656535e-19,
                   BeV          => 1.60217656535e-10,
  		   electronvolt => 1.60217656535e-19,
		   hph          => 3600*746,
		   PSh          => 3600*746/1.014,
		   galatm_imp   => 460.63256925,
		   galatm_US    => 383.5568490138,
		   quad         => 1.05505585262e18,
		   Ry           => 2.179872e-18,
		   rydberg      => 2.179872e-18,
		   th           => 4.1868e6,
		   thm          => 4.1868e6,
		   therm        => 4.1868e6,
		   thermie      => 4.1868e6,
                   boe          => 6.12e9,         #barrel of oil equivalent
		   TCE          => 29.288e9,       #ton of coal equivalent
		   toe          => 41.868e9,       #tonne of oil equivalent
		   tTNT         => 4.184e9,        #ton of TNT equivalent
		   CMO          => 4.454e13*3.6e6, #cubic mile of oil = 4.454*10^13 kWh
		   CKO          => 4.454e13*3.6e6*1.609344**3, #cubic km   of oil
                 },
         force=> {
	          newton=> 1,
	          N     => 1,
	          _N    => 1,
                  dyn   => 1e-5,
                  dyne  => 1e-5,
                  dynes => 1e-5,
		  lb    => 4.448222,
                 },
         pressure=>{
                  Pa      => 1,
                  _Pa     => 1,
                  pascal  => 1,
                 'N/m2'   => 1,
                  bar     => 100000.0,
                  mbar    => 100.0,
                  at      =>  98066.5,   #technical atmosphere
		  atm     => 101325.0,     #standard atmosphere
		  torr    => 133.3224,
                  psi     => 6894.8,     #pounds per square inch
                 },
         bytes=> {
                  b     => 1,
                  kb    => 1024,         #2**10
                  mb    => 1024**2,      #2**20 = 1048576
		  gb    => 1024**3,      #2**30 = 1073741824
		  tb    => 1024**4,      #2**40 = 1099511627776
		  pb    => 1024**5,      #2**50 = 1.12589990684262e+15
		  eb    => 1024**6,      #2**60 =
		  zb    => 1024**7,      #2**70 =
		  yb    => 1024**8,      #2**80 =
                  KiB   => 1024,         #2**10
                  KiB   => 1024**2,      #2**20 = 1048576
		  KiB   => 1024**3,      #2**30 = 1073741824
		  KiB   => 1024**4,      #2**40 = 1099511627776
		  KiB   => 1024**5,      #2**50 = 1.12589990684262e+15
		  KiB   => 1024**6,      #2**60 =
		  KiB   => 1024**7,      #2**70 =
		  KiB   => 1024**8,      #2**80 =
                  Kb    => 1000,         #2**10
                  Mb    => 1000**2,      #2**20 = 1048576
		  Gb    => 1000**3,      #2**30 = 1073741824
		  Tb    => 1000**4,      #2**40 = 1099511627776
		  Pb    => 1000**5,      #2**50 = 1.12589990684262e+15
		  Eb    => 1000**6,      #2**60 =
		  Zb    => 1000**7,      #2**70 =
		  Yb    => 1000**8,      #2**80 =
                  byte      => 1,
                  kilobyte  => 1024,         #2**10
                  megabyte  => 1024**2,      #2**20 = 1048576
		  gigabyte  => 1024**3,      #2**30 = 1073741824
		  terabyte  => 1024**4,      #2**40 = 1099511627776
		  petabyte  => 1024**5,      #2**50 = 1.12589990684262e+15
		  exabyte   => 1024**6,      #2**60 =
		  zettabyte => 1024**7,      #2**70 =
		  yottabyte => 1024**8,      #2**80 =
                 },
         milage=>{                                #fuel consumption
                 'l/mil'          => 1,
                 'l/10km'         => 1,
                 'lp10km'         => 1,
                 'l/km'           => 10,
                 'l/100km'        => 1/10,
                  lp100km         => 1/10,
                  liter_pr_100km  => 1/10,
                  liter_pr_km     => 10,
                  mpg             => -23.5214584,      #negative signals inverse
         },
#         light=> {
#                   cd => 1,
#                   candela => 1,
#                 },
#         lumens
#         lux
         angle =>{
		  turn          => 1,
                  rad           => 1/(2*$PI), # 2 * pi
                  radian        => 1/(2*$PI), # 2 * pi
                  radians       => 1/(2*$PI), # 2 * pi
                  deg           => 1/360,                                # 4 * 90
                  degree        => 1/360,                                # 4 * 90
                  degrees       => 1/360,                                # 4 * 90
                  grad          => 1/400,
                  gradian       => 1/400,
                  gradians      => 1/400,
                  grade         => 1/400, #french revolutionary unit
                  gon           => 1/400,
                  new_degree    => 1/400,
                  nygrad        => 1/400, #scandinavian
		  quadrant      => 1/4,
 		  sextant       => 1/6,
		  hour          => 1/24,
		  point         => 1/32,  #used in navigation
		  hexacontade   => 1/60,
		  binary_degree => 1/256,
		  binary_radian => 1/256,
		  brad          => 1/256,
                 },
	 money =>{                      # rates at 18th feb 2018
           NOK => 1.000000000,          #norwegian kroner
           AED => 2.118503,             #united arab emirates dirham
           ARS => 0.393725,             #argentina peso
           AUD => 6.162408,             #australian dollar
           BCH => 12118.36327559,       #bitcoin cash
           BGN => 4.937892,             #bulgarian lev
           BHD => 20.692023,            #bahrain dinar
           BND => 5.931982,             #brunei dollar
           BRL => 2.407647,             #brazilian real
           BTC => 84864.0984477,        #bitcoin
           BWP => 0.825478,             #botswana pulaa
           CAD => 6.201377,             #canadian dollar
           CHF => 8.391971,             #switzerland franc
           CLP => 0.013110,             #chili peso
           CNY => 1.226451,             #china yuan/renminbi
           COP => 0.00274549,           #colombian peso
           CZK => 0.380706,             #czech koruna
           DKK => 1.295957,             #danish kroner
           ETC => 257.8101864767,       #ethereum-classic
           ETH => 7410.657012902,       #ethereum
           EUR => 9.657677,             #euro
           GBP => 10.913727,            #great britain pound, british pound
           '£' => 10.913727,            #great britain pound, british pound symbol
           HKD => 0.994705,             #hong kong dollar
           HRK => 1.301015,             #croatian kuna
           HUF => 0.030922,             #hungarian forint
           IDR => 0.00057358,           #indonesian rupia
           ILS => 2.191990,             #israel new shekel
           INR => 0.121070,             #indian rupee
           IRR => 0.00020984,           #iranian rial
           ISK => 0.077647,             #icelandic kroner
           JPY => 0.073271,             #japanish yen
           KRW => 0.00729673,           #south korean won
           KWD => 25.925147,            #kuwait dinar
           KZT => 0.024338,             #kazakhstanian tenge
           LKR => 0.050121,             #sri lanka rupee
           LTC => 1782.926421562,       #litecoin
           LYD => 5.866758,             #libyan dinar
           MUR => 0.239306,             #mauritius
           MXN => 0.418798,             #mexico peso
           MYR => 1.998096,             #malaysian ringgit
           NPR => 0.075316,             #nepal rupee
           NZD => 5.745187,             #new zealand dollar
           OMR => 20.234592,            #oman rial
           PHP => 0.148869,             #philippines peso
           PKR => 0.070338,             #pakistan rupee
           PLN => 2.319848,             #poland zloty
           QAR => 2.137418,             #qatar rial
           RON => 2.070137,             #romaina new nei
           RUB => 0.137791,             #russia rouble / rubel
           SAR => 2.074720,             #saudi arabia riyal
           SEK => 0.976704,             #swedish kroner
           SGD => 5.931982,             #singapore dollar
           THB => 0.248282,             #thailand baht
           TRY => 2.076265,             #turkish new lira
           TTD => 1.150931,             #trinidad/tobago dollar
           TWD => 0.267321,             #taiwan dollar
           USD => 7.780201,             #us dollar
          '$'  => 7.780201,             #us doller, symbol
           VEF => 0.778994,             #venezuelan bolivares fuertes
           XBT => 84864.0984477,        #synonym for BTC
           XRP => 8.96808208868,        #ripple
           ZAR => 0.667117,             #south africa rand
          },
          numbers =>{
	    dec=>1,hex=>1,bin=>1,oct=>1,roman=>1,      des=>1,#des: spelling error in v0.15-0.16
            dusin=>1,dozen=>1,doz=>1,dz=>1,gross=>144,gr=>144,gro=>144,great_gross=>12*144,small_gross=>10*12,
          }
	);
our $conv_prepare_time=0;
our $conv_prepare_money_time=0;
sub conv_prepare {
  my %b    =(da  =>1e+1, h    =>1e+2, k    =>1e+3, M     =>1e+6,          G   =>1e+9, T   =>1e+12, P    =>1e+15, E   =>1e+18, Z    =>1e+21, Y    =>1e+24, H    =>1e+27);
  my %big  =(deca=>1e+1, hecto=>1e+2, kilo =>1e+3, mega  =>1e+6,          giga=>1e+9, tera=>1e+12, peta =>1e+15, exa =>1e+18, zetta=>1e+21, yotta=>1e+24, hella=>1e+27);
  my %s    =(d   =>1e-1, c    =>1e-2, m    =>1e-3,'µ'    =>1e-6, u=>1e-6, n   =>1e-9, p   =>1e-12, f    =>1e-15, a   =>1e-18, z    =>1e-21, y    =>1e-24);
  my %small=(deci=>1e-1, centi=>1e-2, milli=>1e-3, micro =>1e-6,          nano=>1e-9, pico=>1e-12, femto=>1e-15, atto=>1e-18, zepto=>1e-21, yocto=>1e-24);
  # myria=> 10000              #obsolete
  # demi => 1/2, double => 2   #obsolete
  # lakh => 1e5, crore => 1e7  #south	asian
  my %x = (%s,%b);
  for my $ct (values%conv) {
    for(grep/^_/,keys%$ct) { # _m -> mm, cm, dm, km, ...
      my $c=$$ct{$_};
      delete$$ct{$_};
      my $unit=substr($_,1);
      $$ct{$_.$unit}=$x{$_}*$c for keys%x;
    }
    for(keys%$ct){ #kWh kwh KWH ...
      $$ct{lc$_}=$$ct{$_} if !defined($$ct{lc$_});
      $$ct{uc$_}=$$ct{$_} if !defined($$ct{uc$_});
    }
  }
  $conv_prepare_time=time();
}

our $Currency_rates_url = 'http://calthis.com/currency-rates';
our $Currency_rates_expire = 6*3600;
sub conv_prepare_money {
  eval {
    require LWP::Simple;
    my $td=$^O=~/^(?:linux|cygwin)$/?"/tmp":"/tmp"; #hm wrong!
    my $fn="$td/acme-tools-currency-rates.data";
    if( !-e$fn  or  time() - (stat($fn))[9] >= $Currency_rates_expire){
      LWP::Simple::getstore($Currency_rates_url,"$fn.$$.tmp"); # get ... see getrates.cmd
      die "nothing downloaded" if !-s"$fn.$$.tmp";
      rename "$fn.$$.tmp",$fn;
      chmod 0666,$fn;
    }
    my $d=readfile($fn);
    my %r=$d=~/^\s*([A-Z]{3}) +(\d+\.\d+)\b/gm;
    $r{lc($_)}=$r{$_} for keys%r;
    #warn serialize([minus([sort keys(%r)],[sort keys(%{$conv{money}})])],'minus'); #ARS,AED,COP,BWP,LVL,BHD,NPR,LKR,QAR,KWD,LYD,SAR,KZT,CLP,IRR,VEF,TTD,OMR,MUR,BND
    #warn serialize([minus([sort keys(%{$conv{money}})],[sort keys(%r)])],'minus'); #LTC,I44,BTC,BYR,TWI,NOK,XDR
    $conv{money}={%{$conv{money}},%r} if keys(%r)>20;
  };
  carp "conv: conv_prepare_money (currency conversion automatic daily updated rates) - $@\n" if $@;
  $conv{money}{"m$_"}=$conv{money}{$_}/1000 for qw/BTC XBT/;
  $conv_prepare_money_time=time();
  1; #not yet
}

sub conv {
  my($num,$from,$to)=@_;
  croak "conf requires 3 args" if @_!=3;
  conv_prepare() if !$conv_prepare_time;
  my $types=sub{ my $unit=shift; [sort grep$conv{$_}{$unit}, keys%conv] };
  my @types=map{ my $ru=$_; my $r;$r=&$types($_) and @$r and $$ru=$_ and last for ($$ru,uc($$ru),lc($$ru)); $r }(\$from,\$to);
  my @err=map "Unit ".[$from,$to]->[$_]." is unknown",grep!@{$types[$_]},0..1;
  my @type=intersect(@types);
  push @err, "from=$from and to=$to has more than one possible conversions: ".join(", ", @type) if @type>1;
  push @err, "from $from (".(join(",",@{$types[0]})||'?').") and "
              ."to $to ("  .(join(",",@{$types[1]})||'?').") has no known common dimension (unit type).\n" if @type<1;
  croak join"\n",map"conv: $_",@err if @err;
  my $type=$type[0];
  conv_prepare_money()        if $type eq 'money' and time() >= $conv_prepare_money_time + $Currency_rates_expire;
  return conv_temperature(@_) if $type eq 'temperature';
  return conv_numbers(@_)     if $type eq 'numbers';
  my $c=$conv{$type};
  my($cf,$ct)=@{$conv{$type}}{$from,$to};
  my $r= $cf>0 && $ct<0 ? -$ct/$num/$cf
       : $cf<0 && $ct>0 ? -$cf/$num/$ct
       :                   $cf*$num/$ct;
  #  print STDERR "$num $from => $to    from=$ff  to=$ft  r=$r\n";
  return $r;
}

sub conv_temperature { #http://en.wikipedia.org/wiki/Temperature#Conversion
  my($t,$from,$to)=(shift(),map uc(substr($_,0,1)),@_);
  $from=~s/K/C/ and $t-=273.15;
 #$from=~s/R/F/ and $t-=459.67; #rankine
  return $t if $from eq $to;
  {CK=>sub{$t+273.15},
   FC=>sub{($t-32)*5/9},
   CF=>sub{$t*9/5+32},
   FK=>sub{($t-32)*5/9+273.15},
  }->{$from.$to}->();
}

sub conv_numbers {
  my($n,$fr,$to)=@_;
  my $dec=$fr eq 'dec'                    ? $n
         :$fr eq 'hex'                    ? hex($n)
         :$fr eq 'oct'                    ? oct($n)
         :$fr eq 'bin'                    ? oct("0b$n")
         :$fr =~ /^(dusin|dozen|doz|dz)$/ ? $n*12
         :$fr =~ /^(gross|gr|gro)$/       ? $n*144
         :$fr eq 'great_gross'            ? $n*12*144
         :$fr eq 'small_gross'            ? $n*12*10
         :$fr eq 'skokk'                  ? $n*60           #norwegian unit
         :$fr eq 'roman'                  ? roman2int($n)
         :$fr eq 'des'                    ? $n
         :croak "Conv from $fr not supported yet";
  my $ret=$to eq 'dec'                    ? $dec
         :$to eq 'hex'                    ? sprintf("%x",$dec)
         :$to eq 'oct'                    ? sprintf("%o",$dec)
         :$to eq 'bin'                    ? sprintf("%b",$dec)
         :$to =~ /^(dusin|dozen|doz|dz)$/ ? $dec/12
         :$to =~ /^(gross|gr|gro)$/       ? $dec/144
         :$to eq 'great_gross'            ? $dec/(12*144)
         :$to eq 'small_gross'            ? $dec/(12*10)
         :$to eq 'skokk'                  ? $dec/60
         :$to eq 'roman'                  ? int2roman($dec)
         :$to eq 'des'                    ? $dec
         :croak "Conv to $to not suppoerted yet";
  $ret;
}
#http://en.wikipedia.org/wiki/Norwegian_units_of_measurement


=head2 bytes_readable

Converts a number of bytes to something human readable.

Input 1: a number

Input 2: optionally the number of decimals if >1000 B. Default is 2.

Output: a string containing:

the number with a B behind if the number is less than 1000

the number divided by 1024 with two decimals and "kB" behind if the number is less than 1024*1000

the number divided by 1048576 with two decimals and "MB" behind if the number is less than 1024*1024*1000

the number divided by 1073741824 with two decimals and "GB" behind if the number is less than 1024*1024*1024*1000

the number divided by 1099511627776 with two decimals and "TB" behind otherwise

Examples:

 print bytes_readable(999);                              # 999 B
 print bytes_readable(1000);                             # 1000 B
 print bytes_readable(1001);                             # 0.98 kB
 print bytes_readable(1024);                             # 1.00 kB
 print bytes_readable(1153433.6);                        # 1.10 MB
 print bytes_readable(1181116006.4);                     # 1.10 GB
 print bytes_readable(1209462790553.6);                  # 1.10 TB
 print bytes_readable(1088516511498.24*1000);            # 990.00 TB
 print bytes_readable(1088516511498.24*1000, 3);         # 990.000 TB
 print bytes_readable(1088516511498.24*1000, 1);         # 990.0 TB

=cut

sub bytes_readable {
  my $bytes=shift();
  my $d=shift()||2; #decimals
  return undef if !defined $bytes;
  return "$bytes B"                         if abs($bytes) <= 2** 0*1000; #bytes
  return sprintf("%.*f kB",$d,$bytes/2**10) if abs($bytes) <  2**10*1000; #kilobyte
  return sprintf("%.*f MB",$d,$bytes/2**20) if abs($bytes) <  2**20*1000; #megabyte
  return sprintf("%.*f GB",$d,$bytes/2**30) if abs($bytes) <  2**30*1000; #gigabyte
  return sprintf("%.*f TB",$d,$bytes/2**40) if abs($bytes) <  2**40*1000; #terrabyte
  return sprintf("%.*f PB",$d,$bytes/2**50); #petabyte, exabyte, zettabyte, yottabyte
}

=head2 sec_readable

Time written as C< 14h 37m > is often more humanly comprehensible than C< 52620 seconds >.

 print sec_readable( 0 );           # 0s
 print sec_readable( 0.0123 );      # 0.0123s
 print sec_readable(-0.0123 );      # -0.0123s
 print sec_readable( 1.23 );        # 1.23s
 print sec_readable( 1 );           # 1s
 print sec_readable( 9.87 );        # 9.87s
 print sec_readable( 10 );          # 10s
 print sec_readable( 10.1 );        # 10.1s
 print sec_readable( 59 );          # 59s
 print sec_readable( 59.123 );      # 59.1s
 print sec_readable( 60 );          # 1m 0s
 print sec_readable( 60.1 );        # 1m 0s
 print sec_readable( 121 );         # 2m 1s
 print sec_readable( 131 );         # 2m 11s
 print sec_readable( 1331 );        # 22m 11s
 print sec_readable(-1331 );        # -22m 11s
 print sec_readable( 13331 );       # 3h 42m
 print sec_readable( 133331 );      # 1d 13h
 print sec_readable( 1333331 );     # 15d 10h
 print sec_readable( 13333331 );    # 154d 7h
 print sec_readable( 133333331 );   # 4yr 82d
 print sec_readable( 1333333331 );  # 42yr 91d

=cut

sub sec_readable {
  my $s=shift();
  my($h,$d,$y)=(3600,24*3600,365.25*24*3600);
   !defined$s     ? undef
  :!length($s)    ? ''
  :$s<0           ? '-'.sec_readable(-$s)
  :$s<60 && int($s)==$s
                  ? $s."s"
  :$s<60          ? sprintf("%.*fs",int(3+-log($s)/log(10)),$s)
  :$s<3600        ? int($s/60)."m " .($s%60)        ."s"
  :$s<24*3600     ? int($s/$h)."h " .int(($s%$h)/60)."m"
  :$s<366*24*3600 ? int($s/$d)."d " .int(($s%$d)/$h)."h"
  :                 int($s/$y)."yr ".int(($s%$y)/$d)."d";
}

=head2 int2roman

Converts integers to roman numbers.

B<Examples:>

 print int2roman(1234);   # prints MCCXXXIV
 print int2roman(1971);   # prints MCMLXXI

(Adapted subroutine from Peter J. Acklam, jacklam(&)math.uio.no)

 I = 1
 V = 5
 X = 10
 L = 50
 C = 100     (centum)
 D = 500
 M = 1000    (mille)

See also L<Roman>.

See L<http://en.wikipedia.org/wiki/Roman_numbers> for more.

=head2 roman2int

 roman2int("MCMLXXI") == 1971

=cut

#alternative algorithm: http://www.rapidtables.com/convert/number/how-number-to-roman-numerals.htm
#see also t/17_roman.t sub int2roman_old
sub int2roman {
    my $n=shift;
    !defined$n  ? undef
  : !length($n) ? ""
  : $n<0        ? "-".int2roman(-$n)
  : int($n)!=$n ? croak"int2roman: $n is not an integer"
#  : $] >= 5.014 ?        #s///r modifier introduced in perl v5.14
#        ("I" x $n)
#        =~s,I{1000},M,gr #unnecessary, but speedup for n>1000
#        =~s,I{100},C,gr  #unnecessary, but speedup for n>100
#        =~s,I{10},X,gr   #unnecessary, but speedup for n>10
#        =~s,IIIII,V,gr
#        =~s,IIII,IV,gr
#        =~s,VV,X,gr
#        =~s,VIV,IX,gr
#        =~s,XXXXX,L,gr
#        =~s,XXXX,XL,gr
#        =~s,LL,C,gr
#        =~s,LXL,XC,gr
#        =~s,CCCCC,D,gr
#        =~s,CCCC,CD,gr
#        =~s,DD,M,gr
#        =~s,DCD,CM,gr
  : do {
      $n="I" x $n;
      $n=~s,I{1000},M,g; #unnecessary, but speedup for n>1000
      $n=~s,I{100},C,g;  #unnecessary, but speedup for n>100
      $n=~s,I{10},X,g;   #unnecessary, but speedup for n>10
      $n=~s,IIIII,V,g;
      $n=~s,IIII,IV,g;
      $n=~s,VV,X,g;
      $n=~s,VIV,IX,g;
      $n=~s,XXXXX,L,g;
      $n=~s,XXXX,XL,g;
      $n=~s,LL,C,g;
      $n=~s,LXL,XC,g;
      $n=~s,CCCCC,D,g;
      $n=~s,CCCC,CD,g;
      $n=~s,DD,M,g;
      $n=~s,DCD,CM,g;
      $n
     }
}
sub int2roman_golfed{my$r='I'x pop;for(qw(IVX XLC CDM)){my($I,$V,$X)=split//;$r=~s,$I$I$I$I($I?),$1?$V:"$I$V",ge;$r=~s,$V($I?)$V,$1$X,g}$r}

sub roman2int {
  my($r,$n,%c)=(shift,0,'',0,qw/I 1 V 5 X 10 L 50 C 100 D 500 M 1000/);
  $r=~s/^-//?-roman2int($r):
  $r=~s/(C?)([DM])|(X?)([LCDM])|(I?)([VXLCDM])|(I)|(.)/
        croak "roman2int: Invalid number $r" if $8;
        $n += $c{$2||$4||$6||$7} - $c{$1||$3||$5||''}; ''/eg && $n
}

#sub roman2int_slow {
#  my $r=shift;
#     $r=~s,^\-,,  ?    0-roman2int($r)
#   : $r=~s,^M,,i  ? 1000+roman2int($r)
#   : $r=~s,^CM,,i ?  900+roman2int($r)
#   : $r=~s,^D,,i  ?  500+roman2int($r)
#   : $r=~s,^CD,,i ?  400+roman2int($r)
#   : $r=~s,^C,,i  ?  100+roman2int($r)
#   : $r=~s,^XC,,i ?   90+roman2int($r)
#   : $r=~s,^L,,i  ?   50+roman2int($r)
#   : $r=~s,^XL,,i ?   40+roman2int($r)
#   : $r=~s,^X,,i  ?   10+roman2int($r)
#   : $r=~s,^IX,,i ?    9+roman2int($r)
#   : $r=~s,^V,,i  ?    5+roman2int($r)
#   : $r=~s,^IV,,i ?    4+roman2int($r)
#   : $r=~s,^I,,i  ?    1+roman2int($r)
#   : !length($r)  ?    0
#   : croak "Invalid roman number $r";
#}

=head2 distance

B<Input:> the four decimal numbers of two GPS positions: latutude1, longitude1, latitude2, longitude2

B<Output:> the air distance in meters between the two points

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

 my @oslo = ( 59.93937,  10.75135);    # oslo in norway
 my @rio  = (-22.97673, -43.19508);    # rio in brazil

 printf "%.1f km\n",   distance(@oslo,@rio)/1000;                  # 10431.7 km
 printf "%.1f km\n",   distance(@rio,@oslo)/1000;                  # 10431.7 km
 printf "%.1f nmi\n",  distance(@oslo,@rio)/1852.000;              # 5632.7 nmi   (nautical miles)
 printf "%.1f miles\n",distance(@oslo,@rio)/1609.344;              # 6481.9 miles
 printf "%.1f miles\n",conv(distance(@oslo,@rio),"meters","miles");# 6481.9 miles

See L<http://www.faqs.org/faqs/geography/infosystems-faq/>

and L<http://mathforum.org/library/drmath/view/51879.html>

and L<http://en.wikipedia.org/wiki/Earth_radius>

and L<Geo::Direction::Distance>, but Acme::Tools::distance() is about 8 times faster.

=cut

our $Distance_factor = $PI / 180;
sub acos { atan2( sqrt(1 - $_[0] * $_[0]), $_[0] ) }
sub distance_great_circle {
  my($lat1,$lon1,$lat2,$lon2)=map $Distance_factor*$_, @_;
  my($Re,$Rp)=( 6378137.0, 6356752.3 ); #earth equatorial and polar radius
  my $R=$Re-($Re-$Rp)*sin(abs($lat1+$lat2)/2); #approx
  return $R*acos(sin($lat1)*sin($lat2)+cos($lat1)*cos($lat2)*cos($lon2-$lon1))
}

sub distance {
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
#https://rosettacode.org/wiki/Haversine_formula#Perl


=head2 big

=head2 bigi

=head2 bigf

=head2 bigr

=head2 bigscale

big, bigi, bigf, bigr and bigscale are sometimes convenient shorthands for using
C<< Math::BigInt->new() >>, C<< Math::BigFloat->new() >> and C<< Math::BigRat->new() >>
(preferably with the GMP for faster calculations). Examples:

  my $num1 = big(3);      #returns a new Math::BigInt-object
  my $num2 = big('3.0');  #returns a new Math::BigFloat-object
  my $num3 = big(3.0);    #returns a new Math::BigInt-object
  my $num4 = big(3.1);    #returns a new Math::BigFloat-object
  my $num5 = big('2/7');  #returns a new Math::BigRat-object
  my($i1,$f1,$i2,$f2) = big(3,'3.0',3.0,3.1); #returns the four new numbers, as the above four lines
                                              #uses wantarray

  print 2**200;       # 1.60693804425899e+60
  print big(2)**200;  # 1606938044258990275541962092341162602522202993782792835301376
  print 2**big(200);  # 1606938044258990275541962092341162602522202993782792835301376
  print big(2**200);  # 1606938044258990000000000000000000000000000000000000000000000

  print 1/7;          # 0.142857142857143
  print 1/big(7);     # 0      because of integer arithmetics
  print 1/big(7.0);   # 0      because 7.0 is viewed as an integer, see bigf below
  print 1/big('7.0'); # 0.1428571428571428571428571428571428571429
  print 1/bigf(7);    # 0.1428571428571428571428571428571428571429
  print bigf(1/7);    # 0.142857142857143   probably not what you wanted

  print 1/bigf(7);    # 0.1428571428571428571428571428571428571429
  bigscale(80);       # for increased precesion (default is 40)
  print 1/bigf(7);    # 0.14285714285714285714285714285714285714285714285714285714285714285714285714285714

In C<big()> the characters C<< . >> and C<< / >> will make it return a
Math::BigFloat- and Math::BigRat-object accordingly. Or else a Math::BigInt-object is returned.

Instead of guessing, use C<bigi>, C<bigf> and C<bigr> to return what you want.

B<Note:> Acme::Tools does not depend on Math::BigInt and
Math::BigFloat and GMP, but these four big*-subs do (by C<require>).
To use big, bigi, bigf and bigr effectively you should
install Math::BigInt::GMP and Math::BigFloat::GMP like this:

  sudo cpanm Math::BigFloat Math::GMP Math::BingInt::GMP         # or
  sudo cpan  Math::BigFloat Math::GMP Math::BingInt::GMP         # or
  sudo yum install perl-Math-BigInt-GMP perl-Math-GMP            # on RedHat, RHEL or
  sudo apt-get install libmath-bigint-gmp-perl libmath-gmp-perl  # on Ubuntu or some other way

Unless GMP is installed for perl like this, the Math::Big*-modules
will fall back to using similar but slower built in modules. See: L<https://gmplib.org/>

=cut

sub bigi {
  eval q(use Math::BigInt try=>"GMP") if !$INC{'Math/BigInt.pm'};
  if (wantarray) { return (map Math::BigInt->new($_),@_)  }
  else           { return      Math::BigInt->new($_[0])   }
}
sub bigf {
  eval q(use Math::BigFloat try=>"GMP") if !$INC{'Math/BigFloat.pm'};
  if (wantarray) { return (map Math::BigFloat->new($_),@_)  }
  else           { return      Math::BigFloat->new($_[0])   }
}
sub bigr {
  eval q(use Math::BigRat try=>"GMP") if !$INC{'Math/BigRat.pm'};
  if (wantarray) { return (map Math::BigRat->new($_),@_)  }
  else           { return      Math::BigRat->new($_[0])   }
}
sub big {
  wantarray
  ? (map     /\./ ? bigf($_)    :        /\// ? bigr($_)    : bigi($_), @_)
  :   $_[0]=~/\./ ? bigf($_[0]) : $_[0]=~/\// ? bigr($_[0]) : bigi($_[0]);
}
sub bigscale {
  @_==1 or croak "bigscale requires one and only one argument";
  my $scale=shift();
  eval q(use Math::BigInt    try=>"GMP") if !$INC{'Math/BigInt.pm'};
  eval q(use Math::BigFloat  try=>"GMP") if !$INC{'Math/BigFloat.pm'};
  eval q(use Math::BigRat    try=>"GMP") if !$INC{'Math/BigRat.pm'};
  Math::BigInt->div_scale($scale);
  Math::BigFloat->div_scale($scale);
  Math::BigRat->div_scale($scale);
  return;
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

#=head2 fractional
#=cut

sub fractional { #http://mathcentral.uregina.ca/QQ/database/QQ.09.06/h/lil1.html
  carp "fractional: NOT FINISHED";
  my $n=shift;
  print "----fractional n=$n\n";
  my $nn=$n; my $dec;
  $nn=~s,\.(\d+)$,$dec=length($1);$1.,;
  my $l;
  my $max=0;
  my($te,$ne);
  for(1..length($nn)/2){
    if( $nn=~/^(\d*?)((.{$_})(\3)+)$/ ){
      print "_ = $_ ".length($2)."\n";
      if(length($2)>$max){
        $l=$_;
	$te="$1$3"-$1;
        $max=length($2);
      }
    }
  }
  return fractional($n) if !$l and !recursed() and $dec>6 and substr($n,-1) and substr($n,-1)--;
  print "l=$l max=$max\n";
  $ne="9" x $l;
  print log($n),"\n";
  my $st=sub{print "status: ".($te/$ne)."   n=$n   ".($n/$te*$ne)."\n"};
  while($n/$te*$ne<0.99){ &$st(); $ne*=10 }
  while($te/$n/$ne<0.99){ &$st(); $te*=10 }
  &$st();
  while(1){
    my $d=gcd($te,$ne); print "gcd=$d\n";
    last if $d==1;
    $te/=$d; $ne/=$d;
  }
  &$st();
  wantarray ? ($te,$ne) : "$te/$ne"; #gcd()
}

=head2 isnum

B<Input:> String to be tested on this regexp:

C<< /^ \s* [\-\+]? (?: \d*\.\d+ | \d+ ) (?:[eE][\-\+]?\d+)?\s*$/x >>

If no argument is given isnum checks C<< $_ >>.

B<Output:> True or false (1 or 0)

 use Acme::Tools;
 my @e=('   +32.12354E-21  ', 2.2, '9' x 99999, ' -123.12', '29,323.31', '29 323.31');
 print isnum()       ? 'num' : 'str' for @e;  #prints num for every element except the last two
 print $_=~$Re_isnum ? 'num' : 'str' for @e;  #same but slighhly faster

=cut

our $Re_isnum     =qr/^ \s* [\-\+]? (?: \d*\.\d+ | \d+ ) (?:[eE][\-\+]?\d+)?\s*$/x;
our $Re_isnum_wolz=qr/^ \s* [\-\+]? (?: ([1-9]\d*|0)?\.\d+ | [1-9]\d* | 0 ) (?:[eE][\-\+]?\d+)?\s*$/x; #without leading zero
sub isnum {(@_?$_[0]:$_)=~$Re_isnum}

=head2 between

Input: Three arguments.

Returns: Something I<true> if the first argument is numerically between the two next. Uses Perls C<< < >>, C<< >= >> and C<< <= >> operators.

=head2 btw

Like L<between> but instead of assuming numbers it checks all three input args
and does alphanumerical comparisons (with Perl operators C<lt>, C<ge> and C<le>) if any of the
three input args don't look like a number or look like a number but with
one or more leading zeros.

 btw(1,1,10)             #true numeric order since all three looks like number according to =~$Re_isnum
 btw(1,'02',13)          #true leading zero in '02' leads to alphabetical order
 btw(10, 012,10)         #true leading zero here means oct number, 012 = 10 (8*1+2), so 10 is btw 10 and 10
 btw('003', '02', '09')  #false because '003' lt '02'
 btw('a', 'b', 'c')      #false because 'a' lt 'b'
 btw('a', 'B', 'c')      #true because upper case letters comes before lower case ones in the "ascii alphabet"
 btw('a', 'c', 'B')      #true, btw() and between switches from and to if the first is > the second
 btw( -1, -2, 1)         #true
 btw( -1, -2, 0)         #true

Both between and btw returns C<undef> if any of the three input args are C<undef> (not defined).
If you're doing only numerical comparisons, using C<between> is faster than C<btw>.

=cut

sub between {
  my($test ,$fom, $tom)=@_;
  return if !defined$test or !defined$fom or !defined$tom;
  $fom < $tom ? $test >= $fom && $test <= $tom : $test >= $tom && $test <= $fom;
}

sub btw {
  my($test,$fom,$tom)=@_;
  return if !defined$test or !defined$fom or !defined$tom;
  $fom =~ $Re_isnum_wolz &&
  $tom =~ $Re_isnum_wolz &&
  $test=~ $Re_isnum_wolz
  ? $fom <  $tom ? $test >= $fom && $test <= $tom : $test >= $tom && $test <= $fom
  : $fom lt $tom ? $test ge $fom && $test le $tom : $test ge $tom && $test le $fom 
}

=head2 curb

B<Input:> Three arguments: value, minumum, maximum.

B<Output:> Returns the value if its between the given minumum and maximum.
Returns minimum if the value is less or maximum if the value is more.
Changes the variable if 1st arg is a scalarref.

 my $enthusiasm = 11;
 print curb( $enthusiasm, 1, 20 );      # prints 11, within bounds
 print curb( $enthusiasm, 1, 10 );      # prints 10
 print curb( $enthusiasm, 20, 100 );    # prints 20
 print curb(\$enthusiasm, 1, 10 );      # prints 10 and sets $enthusiasm = 10
 print $enthusiasm;                     # prints 10

=cut

sub curb {
  my($val,$min,$max)=@_;
  # todo: undef min|max => dont curb min|max
  croak "curb: wrong args" if @_!=3 or !defined$min or !defined$max or !defined$val or $min>$max;
  return $$val=curb($$val,$min,$max) if ref($val) eq 'SCALAR';
  $val < $min ? $min :
  $val > $max ? $max :
                $val;
}
sub bound { curb(@_) }

=head2 log10

=head2 log2

=head2 logn

 print log10(1000);                  # prints 3
 print log10(10000*sqtr(10));        # prints 4.5
 print log2(16);                     # prints 4
 print logn(4096, 8);                # prints 4 (12/3=4)
 print logn($PI, 2.71828182845905);  # same as  print log($PI)  using perls builtin log()

=cut

sub log10 { log($_[0]) / log(10)    }
sub log2  { log($_[0]) / log(2)     }
sub logn  { log($_[0]) / log($_[1]) }

=head1 STRINGS

=head2 upper

=head2 lower

Returns input string as uppercase or lowercase.

Can be used if Perls build in C<uc()> and C<lc()> for some reason does not convert æøå or other latin1 letters outsize a-z.

Converts C<< æøåäëïöüÿâêîôûãõàèìòùáéíóúýñð >> to and from C<< ÆØÅÄËÏÖÜ?ÂÊÎÔÛÃÕÀÈÌÒÙÁÉÍÓÚÝÑÐ >>

See also C<< perldoc -f uc >> and C<< perldoc -f lc >>

=head2 trim

Removes space from the beginning and end of a string. Whitespace (C<< \s >>) that is.
And removes any whitespace inside the string of more than one char, leaving the first whitespace char. Thus:

 trim(" asdf \t\n    123 ")  eq "asdf 123"
 trim(" asdf\t\n    123\n")  eq "asdf\t123"
 trim(" asdf\n\t    123\n")  eq "asdf\n123"

Works on C<< $_ >> if no argument is given:

 print join",", map trim, " please ", " remove ", " my ", " spaces ";   # please,remove,my,spaces
 print join",", trim(" please ", " remove ", " my ", " spaces ");       # works on arrays as well
 my $s=' please '; trim(\$s);                                           # now  $s eq 'please'
 trim(\@untrimmedstrings);                                              # trims array strings inplace
 @untrimmedstrings = map trim, @untrimmedstrings;                       # same, works on $_
 trim(\$_) for @untrimmedstrings;                                       # same, works on \$_

=head2 lpad

=head2 rpad

Left or right pads a string to the given length by adding one or more spaces at the end for  I<rpad> or at the start for I<lpad>.

B<Input:> First argument: string to be padded. Second argument: length of the output. Optional third argument: character(s) used to pad.
Default is space.

 rpad('gomle',9);         # 'gomle    '
 lpad('gomle',9);         # '    gomle'
 rpad('gomle',9,'-');     # 'gomle----'
 lpad('gomle',9,'+');     # '++++gomle'
 rpad('gomle',4);         # 'goml'
 lpad('gomle',4);         # 'goml'
 rpad('gomle',7,'xyz');   # 'gomlxy'
 lpad('gomle',10,'xyz');  # 'xyzxygoml'

=head2 cpad

Center pads. Pads the string both on left and right equal to the given length. Centers the string. Pads right side first.

 cpad('mat',5)            eq ' mat '
 cpad('mat',4)            eq 'mat '
 cpad('mat',6)            eq ' mat  '
 cpad('mat',9)            eq '   mat   '
 cpad('mat',5,'+')        eq '+mat+'
 cpad('MMMM',20,'xyzXYZ') eq 'xyzXYZxyMMMMxyzXYZxy'

=cut

sub upper {no warnings;my $s=@_?shift:$_;$s=~tr/a-zæøåäëïöü.âêîôûãõàèìòùáéíóúýñð/A-ZÆØÅÄËÏÖÜ.ÂÊÎÔÛÃÕÀÈÌÒÙÁÉÍÓÚÝÑÐ/;$s}
sub lower {no warnings;my $s=@_?shift:$_;$s=~tr/A-ZÆØÅÄËÏÖÜ.ÂÊÎÔÛÃÕÀÈÌÒÙÁÉÍÓÚÝÑÐ/a-zæøåäëïöü.âêîôûãõàèìòùáéíóúýñð/;$s}

sub trim {
  return trim($_) if !@_;
  return map trim($_), @_ if @_>1;
  my $s=shift;
  if(ref($s) eq 'SCALAR'){ $$s=~s,^\s+|(?<=\s)\s+|\s+$,,g; return $$s}
  if(ref($s) eq 'ARRAY') { trim(\$_) for @$s; return $s }
  $s=~s,^\s+|(?<=\s)\s+|\s+$,,g if defined $s;
  $s;
}

sub rpad {
  my($s,$l,$p)=@_;
  $p=' ' if @_<3 or !length($p);
  $s.=$p while length($s)<$l;
  substr($s,0,$l);
}

sub lpad {
  my($s,$l,$p)=@_;
  $p=' ' if @_<3 or !length($p);
  $l<length($s)
  ? substr($s,0,$l)
  : substr($p x (1+$l/length($p)), 0, $l-length($s)).$s;
}

sub cpad {
  my($s,$l,$p)=@_;
  $p=' ' if @_<3 or !length($p);
  my $ls=length($s);
  return substr($s,0,$l) if $l<$ls;
  $p=$p x (($l-$ls+2)/length($p));
  substr($p, 0, ($l-$ls  )/2) . $s .
  substr($p, 0, ($l-$ls+1)/2);
}

sub cpad_old {
  my($s,$l,$p)=@_;
  $p=' ' if !length($p);
  return substr($s,0,$l) if $l<length($s);
  my $i=0;
  while($l>length($s)){
    my $pc=substr($p,($i==int($i)?1:-1)*($i%length($p)),1);
    $i==int($i) ? ($s.=$pc) : ($s=$pc.$s);
    $i+=1/2;
  }
  $s;
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

=head2 sliding

Same as trigram (except there is no default width). Works also with arrayref instead of string.

Example:

 sliding( ["Reven","rasker","over","isen"], 2 )

Result:

  ( ['Reven','rasker'], ['rasker','over'], ['over','isen'] )

=head2 chunks

Splits strings and arrays into chunks of given size:

 my @a = chunks("Reven rasker over isen",7);
 my @b = chunks([qw/Og gubben satt i kveldinga og koste seg med skillinga/], 3);

Resulting arrays:

 ( 'Reven r', 'asker o', 'ver ise', 'n' )
 ( ['Og','gubben','satt'], ['i','kveldinga','og'], ['koste','seg','med'], ['skillinga'] )

=head2 chars

 chars("Tittentei");     # ('T','i','t','t','e','n','t','e','i')

Perhaps a more readable way of writing C< split(//,"Tittentei") >

=cut

sub trigram { sliding($_[0],$_[1]||3) }

sub sliding {
  my($s,$w)=@_;
  return map substr($s,$_,$w),   0..length($s)-$w  if !ref($s);
  return map [@$s[$_..$_+$w-1]], 0..@$s-$w         if ref($s) eq 'ARRAY';
}

sub chunks {
  my($s,$w)=@_;
  return $s=~/(.{1,$w})/g                                      if !ref($s);
  return map [@$s[$_*$w .. min($_*$w+$w-1,$#$s)]], 0..$#$s/$w  if ref($s) eq 'ARRAY';
}

sub chars { split//, shift }

=head2 huffman

Input: a hash of frequencies of the different letters or strings.

Output: a hash with the same letters/strings as keys and their binary representation as strings of 0s and 1s.

As in L< https://en.wikipedia.org/wiki/Huffman_coding#Basic_technique > the string
I<A_DEAD_DAD_CEDED_A_BAD_BABE_A_BEADED_ABACA_BED> has these frequencies:

 my %freq = (A=>11, B=>6, C=>2, D=>10, E=>7, _=>10);   #There are 11 A's, 6 B's and so on

To get a huffman encoding:

 my $str = 'A_DEAD_DAD_CEDED_A_BAD_BABE_A_BEADED_ABACA_BED';
 my %freq; $freq{$_}++ for chars($str);
 my %code = huffman(%freq);

Alternative input: just the string. The above three lines can be changed to:

 my %code = huffman('A_DEAD_DAD_CEDED_A_BAD_BABE_A_BEADED_ABACA_BED');

%code is now: C< ('A','10', 'B','1111', 'C','1110', 'D','01', 'E','110', '_','00') >.

A tip for decoding:

 my %letter = reverse huffman(%freq);      # $letter{'10'} is now A and so on

=head2 huffman_pack

Input: First arg: a string or arrayref. Optional second arg: a hashref to what encoding to use. Default is a ref to a hash found by L</huffman>.

Output: to elements: the encoded binary string and the hashref to the given or found encoding hash which is to be used upon L</huffman_decode>

 my($encoded_binary_string, $encoding_hashref) = huffman_pack("some string which will be split into chars")

=head2 huffman_unpack

Input:

First arg: a encoded binary string.

Second arg: a hashref to the encoding hash as returned by L</huffman_pack>.

An optional third arg: the length of the decoded output. Unless given
one or more extra "padding" chars might be output since the binary
string in the first arg is of length 8, 16, 24, ... a number divisible
by 8 since perl packs bytes, not bits. So we need a way of telling
huffman_unpack where to stop.

Output: A string or an array of codes depending on scalar or list context.

 my $string = "some string which will be split into chars";
 my($encoded_binary_string, $encoding_hashref) = huffman_pack($string)
 my $string2 = huffman_unpack($encoded_binary_string, $encoding_hashref, length$string);
 print "YES!" if $string2 eq $string; #should print YES!

=cut

sub huffman {
  if(@_==1){
      if   (ref($_[0]) eq 'SCALAR'){ return huffman([split//,${$_[0]}]) }
      elsif(!ref($_[0])           ){ return huffman([split//,$_[0]   ]) }
      elsif(ref($_[0]) eq 'ARRAY' ){ my %freq; $freq{$_}++ for @{pop()}; return huffman(map+($_=>$freq{$_}),sort keys%freq) }
      elsif(ref($_[0]) eq 'HASH'  ){ my$f=shift;return huffman(map+($_=>$$f{$_}),sort{$$f{$b}<=>$$f{$a} or $a<=>$b}keys%$f) }
  }
  my($s,@c,%h,$h)=0 x 9;
  push @c, [splice@_,0,2] while @_;
  while(@c>2){
    @c = sort {$$b[1]<=>$$a[1] or $$a[0]cmp$$b[0] or die} @c;
    push @c, [ ++$s, $c[-2][1]+$c[-1][1], pop@c, pop@c ];
  }
  $h=sub{my$n=0;my$pre=pop;@$_==2?($h{$$_[0]}=$pre.$n++):&$h(@$_,$pre.$n++) for grep ref,@_};
  &$h(@c,'');
  %h
}

our $Huffman_pack_length;
our $Huffman_pack_bits;
sub huffman_pack {
    my($data,$enchash)=@_;
    $enchash={huffman($data)} if @_<2;
    if(ref($data) eq 'ARRAY'){
	my($i,$r)=(0,'');
	vec($r,$i++,1)=$_ for map split(//,$$enchash{$_}), @$data;
	$Huffman_pack_length=@$data;
	$Huffman_pack_bits=$i;
	($r,$enchash);
    }
    elsif(ref($data) eq 'SCALAR'){ (huffman_pack($$data,         $enchash),$enchash) }
    else                         { (huffman_pack([split//,$data],$enchash),$enchash) }
}

sub huffman_unpack {
    my($str,$enchash,$len)=@_;
    $len=9e9 if @_<3;
    my($bits,$r,%dec,@r)=('','',reverse%$enchash);
    for(0..8*length($str)-1){
	$bits.=vec($str,$_,1);
	if(exists$dec{$bits} and $len--){
	    if(wantarray){ push @r, $dec{$bits} }
	    else         { $r.=$dec{$bits}      }
	    $bits='';
	}
    }
    wantarray ? @r : $r;
}

=head2 repl

Synonym for replace().

=head2 replace

Return the string in the first input argument, but where pairs of search-replace strings (or rather regexes) has been run.

Works as C<replace()> in Oracle, or rather regexp_replace() in Oracle 10 and onward. Except that this C<replace()> accepts more than three arguments.

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

sub replace { repl(@_) }
sub repl {
  my $str=shift;
  return $$str=replace($$str,@_) if ref($str) eq 'SCALAR';
 #return ? if ref($str) eq 'ARRAY';
 #return ? if ref($str) eq 'HASH';
  while(@_){
    my($fra,$til)=(shift,shift);
    defined $til ? $str=~s/$fra/$til/g : $str=~s/$fra//g;
  }
  return $str;
}

=head1 ARRAYS

=head2 subarr

The equivalent of C<substr> on arrays.

Input args: 1) arrayref, 2) offset, 3) optional length and 4) optional replacement array.

Without a third argument, subarr returns the rest of the array.

For one to three input args, subarr works as C<splice> without changing the array.

Negative offsets and lengths works as Perls substr, see C<perldoc -f substr>

For four or more input args, subarr works just as splice with replacement and as substr with four args, and returns what is replaced.

 @top10 = subarr( \@array, 0, 10);   # first 10
 @last2 = subarr( \@array, -2, 2);   # last 2
 @last2 = subarr( $array_ref, -2);   # also last 2
 @last6 = subarr  $array_ref, -6;    # returns last 6 elems, parens are optional
 @last6 = subarr( $array_ref, -6,6,'x','y'); # replaces last 6 elems with the two string elems x and y, still returns the last six
 my $ref = [1..10];
 @arr   = subarr( $ref, -6, -4, qw(X Y ZZ); #replaces sixth and fifth last elems with x, y and zz. Returns replaced two elems
 print join('+',@arr);               # 5+6
 print join('+',@$ref);              # 1+2+3+4+X+Y+ZZ+7+8+9+10

The same can be obtained from C<< @array[$from..$to] >> but that dont work the
same way with negative offsets and boundary control of length.

=cut

#Todo: sjekk paastand over


#sub subarr(+$;$) { #perl>=5.14        # t/35_subarr.t
sub subarr { #perl<5.14
  my($a,$o,$l,@r)=@_;
  croak "subarr: first arg not array ref" if ref($a) ne 'ARRAY';
  $o=@$a+$o    if $o<0;
  $o=0         if $o<0;
  $o=@$a-1     if $o>@$a-1;
  $l=@$a-$o    if @_<3;
  $l=@$a-$o+$l if $l<0;
  $l=@$a-$o    if $l<0;
  $l=@$a-$o    if $l>@$a-$o;
  @_>3 ? splice(@$a,$o,$l,@r)
       : @$a[$o..$o+$l-1];
}

=head2 min

Returns the smallest number in a list. Undef is ignored.

 @lengths=(3,2,5,2,10,undef,5,4);
 $shortest = min(@lengths);   # returns 2

Note: The comparison operator is perls C<< < >> which means empty strings is treated as C<0>, the number zero. The same goes for C<max()>, except of course C<< > >> is used instead.

 min(3,4,5)       # 3
 min(3,4,5,undef) # 3
 min(3,4,5,'')    # returns the empty string

=head2 max

Returns the largest number in a list. Undef is ignored.

 @heights=(123,90,134,undef,132);
 $highest = max(@heights);   # 134

=head2 mins

Just as L</min>, except for strings. Uses the alphanumerical comparison operator C< lt > (less than).

 print min(2,7,10);          # 2
 print mins("2","7","10");   # 10
 print mins(2,7,10);         # 10

=head2 maxs

Just as L</max>, except for strings. Uses the alphanumerical comparison operator C< gt > (greater than).

 print max(2,7,10);          # 10
 print maxs("2","7","10");   # 7
 print maxs(2,7,10);         # 7

=cut

sub min  {my $min;for(@_){ $min=$_ if defined($_) and !defined($min) || $_ < $min } $min }
sub mins {my $min;for(@_){ $min=$_ if defined($_) and !defined($min) || $_ lt $min} $min }
sub max  {my $max;for(@_){ $max=$_ if defined($_) and !defined($max) || $_ > $max } $max }
sub maxs {my $max;for(@_){ $max=$_ if defined($_) and !defined($max) || $_ gt $max} $max }

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

sub zip {
  my @t=@_;
  ref($_) ne 'ARRAY' and croak "ERROR: zip should have arrayrefs as arguments" for @t;
  @{$t[$_]} != @{$t[0]} and croak "ERROR: zip should have equal sized arrays" for 1..$#t;
  my @res;
  for my $i (0..@{$t[0]}-1){
    push @res, $$_[$i] for @t;
  }
  return @res;
}

=head2 sim

B<Input:> Two or more strings

B<Output:> A number 0 - 1 indicating the similarity between two strings.

Requires L<String::Similarity> where the real magic happens.

 sim("Donald Duck", "Donald E. Knuth");    # returns 0.615
 sim("Kalle Anka", "Kalle And")'           # returns 0.842
 sim("Kalle Anka", "Kalle Anka");          # returns 1
 sim("Kalle Anka", "kalle anka");          # returns 0.8
 sim(map lc, "Kalle Anka", "kalle anka");  # returns 1

Todo: more doc

=cut

#Todo:
#peat -le'print join", ",sim("GskOk",[zip([qw(Gsk_ok Vgdoknr Personnavn Adferdkode Ordenkode G_kok)],[0..5])],0.7,0.127)'
#Use of uninitialized value in subroutine entry at /usr/local/share/perl/5.22.1/Acme/Tools.pm line 2365.
#Use of uninitialized value $simlikest in numeric ge (>=) at /usr/local/share/perl/5.22.1/Acme/Tools.pm line 2366.
#Use of uninitialized value in subroutine entry at /usr/local/share/perl/5.22.1/Acme/Tools.pm line 2365.
#Use of uninitialized value $simnestlikest in numeric ge (>=) at /usr/local/share/perl/5.22.1/Acme/Tools.pm line 2372.

sub sim {
  require String::Similarity;
  my($str,@r)=@_;
  return String::Similarity::similarity(@_) if @r==1; #to param
  my($min,$mindiff);
  if(ref($r[0]) eq 'ARRAY'){
    ($min,$mindiff)=@r[1,2];
    @r=@{$r[0]};
  }
  $min=0 if!defined$min;
  my($simlikest,$simnestlikest,$likest,$idlikest)=(-1,-1);
  for(@r){
    my($s,$id)=ref($_) eq 'ARRAY' ? @$_ : ($_);
    my $sim=String::Similarity::similarity($str,$s,$simnestlikest//0);
    if($sim>=$simlikest){
      ($simnestlikest,$likest,$simlikest)=($simlikest,$s,$sim);
      $idlikest=$id if defined$id;
    }
    elsif($sim>=$simnestlikest){
      $simnestlikest=$sim;
    }
  }
  my@ret=($simlikest,$likest);
  @ret=(undef,undef) if $simnestlikest>0 and $simlikest-$simnestlikest<$mindiff;
  @ret=(undef,undef) if $simlikest<$min;
  @ret=(@ret,$simnestlikest,$simlikest,$likest);
  push(@ret, $ret[0] ? $idlikest : undef) if defined $idlikest;
  return wantarray?@ret:$ret[0];
}

=head2 sim_perm

B<Input:> Two strings

B<Output:> A number 0 - 1 indicating the maximum similarity between two strings tested
against all permutations of both strings split on C<< [\s,]+ >> and where the string
with most words (i.e. names) are cut to as many words as the one with least words.

Requires L<String::Similarity> where the real magic happens.

While sim() is case sensitive, sim_perm() is not.

 Name1                              Name2                                 sim() sim_perm()
 ---------------------------------- ------------------------------------- ----- ----------
 Humphrey DeForest Bogart           Bogart Humphrey DeForest               0.71       1.00
 Humphrey Bogart                    Humphrey Gump Bogart                   0.86       1.00
 Humphrey deforest Bogart           Bogart DeForest                        0.41       1.00
 Humfrey DeForest Boghart           BOGART HUMPHREY                        0.05       0.87
 Humphrey                           Bogart Humphrey                        0.70       1.00
 Humfrey Deforest Boghart           BOGART D. HUMFREY                      0.15       0.78 *)
 Presley, Elvis Aaron               Elvis Presley                          0.424242   1.00

sim_perm() was written to identify double-profiles in databases: two people with
either the same (or similar) email or phone number or zip code and similar enough
names are going on the list of probable doubles.

*) Todo: deal with initials better, should be higher than 0.78

=cut

sub sim_perm {
  require String::Similarity;
  my($s1,$s2)=map {s/^\s*(.+?)\s*$/$1/;$_} map upper($_), @_; #/r v5.14
  croak if !length($s1) or !length($s2);
  my $max;
  for(cart([permutations(split(/[\s,]+/,$s1))],
           [permutations(split(/[\s,]+/,$s2))])) {
    my($n1,$n2)=@$_;
    if(@$n1>@$n2){    pop@$n1 while @$n1>@$n2 }
    else         {    pop@$n2 while @$n1<@$n2 }
    my($str1,$str2)=map join(" ",@$_),($n1,$n2);
    if(defined $max){
      my $sim=String::Similarity::similarity($str1,$str2,$max);
      $max=$sim if $sim>$max;
    }
    else {
      $max=String::Similarity::similarity($str1,$str2);
    }
    last if $max==1;
  }
  return $max;
}

=head2 levdist

Returns the Levenshtein distance between two strings. This is the minimum number
of edits needed on one of them to become equal to the other. Three types of edits
are allowed: insertion of a char, deletion of a char and substitution of one char
into another.

Examples:

 levdist('vlepphan','elephant'); #3
 levdist('elephant','elephant'); #0, same string, 0 edits needed
 levdist('elephant','');         #8, empty string => length of the other (deletions)
 levdist('abc','cba');           #2

The first example returns 3 because 3 edits are needed. When v is substituted
to e, one of the p's is deleted and the t is inserted we get elephant.

L<https://en.wikipedia.org/wiki/Levenshtein_distance>

=cut
    
sub levdist {
  my($s1,$s2) = map[/./g],@_;
  my @a=0..@$s2;
  for my $i (1..@$s1){
    my $n=$i;
    @a=($i,map $n=1+min( $a[$_], $n, $a[$_-1]-($$s1[$i-1] eq $$s2[$_-1])), 1..@$s2);
  }
  pop@a
}

=head2 jsim

Jaro-similarity.

Input: two strings.

Returns a number between 0 and 1 to grade the similarity between two strings.
See L</jwsim>. Both jsim() and jwsim() are case-sensitive. So A and a is viewed
as completely different characters.

1 means the strings are equal, 0 means no similarity which means either zero
common letters or all common letters positions in their strings are too far
apart adjusted for the max lenght of the two strings.

Jaro-similarity. L<https://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance#Jaro_Similarity>

 jsim('DIXON', 'DICKSONX');  # 0.7666666666666666
 jsim('ABCDEF', 'GHIJKL');   # 0
 jsim('ABCDEF', 'GHIAJKL');  # 0 also, even if A is common, the A's are too far apart
 jsim('ABCDEF', 'GHAIJKL');  # 0.4444444444444440 because the A's are close enough to be significant

=head2 jwsim

Jaro-Winkler-similarity.

Input: two strings and an optional scaling factor (between 0 and 0.25) with a default of 0.1.

Returns a number between 0 and 1 to grade the similarity between two strings. See L</jsim>.

jwsim = jsim + reward

If the first 1-4 chars are equal the reward is higher. The longer the equal prefix (up to 4) the higher the reward.

L<https://en.wikipedia.org/wiki/Jaro%E2%80%93Winkler_distance#Jaro%E2%80%93Winkler_Similarity>

 jsim('MARTHA','MARHTA');      # 0.944444444444445
 jwsim('MARTHA','MARHTA');     # 0.961111111111111 which is higher, Winkler added a reward for equality in the beginning of the strings
 jwsim('MARTHA','MARHTA',0.1); # 0.961111111111111, same since 0.1 is the default scaling factor for the prefix reward
 jwsim('MARTHA','MARHTA',0.2); # 0.977777777777778, larger scaling factor makes jwsim put more weigh into same prefix.
                               # The 3rd argument should be between 0 - 0.25. Larger than 0.25 and jwsim() can in
                               # some cases return numbers larger than 1.
 jwsim('MARTHA','MARHTA',0.0); # 0.944444444444445, scaling factor = 0 makes jwsim() return the same a jsim().
                               # No reward for same prefix.

=cut

sub jsim {
    my @s = split//,shift;
    my @t = split//,shift;
    return 1 if !@s and !@t;
    my($match_distance, $matches, @s_matches, @t_matches) = (int(max(0+@s,0+@t)/2)-1, 0);
    for my $i (0 .. $#s) {
	my $start = max(0,    $i-$match_distance);
	my $end   = min(0+@t, $i+$match_distance+1);
	for my $j (grep !$t_matches[$_] && $s[$i] eq $t[$_], $start .. $end - 1) {
	    $s_matches[$i]=1;
	    $t_matches[$j]=1;
	    $matches++;
	    last;
	}
    }
    return 0 if !$matches;
    my($k,$tr) = (0,0);
    for(grep $s_matches[$_], 0..$#s) {
	$k++ while !$t_matches[$k];
	$tr++ if $s[$_] ne $t[$k++];
    }
    (  $matches/@s + $matches/@t + 1 - $tr/$matches/2  ) / 3;
}

sub jwsim {
    my($s1,$s2,$p)=@_;
    $p=0.1 if @_<3; #default
    my $sim=jsim($s1,$s2);
    my $prefix=(grep substr($s1,0,$_) eq substr($s2,0,$_), 0..min(4,length($s1),length($s2)))[-1];
    #print "...prefix=$prefix\n";
    $sim + $prefix*$p*(1-$sim);
}

sub hpush {
    my $heap=shift;
    my $attr=pop if ref($_[-1]) eq 'HASH';
    for(@_){
	push @$heap, $_;
	my $i=@$heap;
	while($i>=2 and $$heap[$i-1] > $$heap[$i/2-1]){
	    @$heap[$i-1,$i/2-1]=@$heap[$i/2-1,$i-1];
	    $i/=2;
	}
	pop@$heap while $attr and @$heap > $$attr{maxsize};
    }
    0+@$heap;
}
sub hpop {
    my $heap=shift;
    my $last=pop@$heap;
    return $last if !@$heap;
    my($i,$top)=(1,splice@$heap,0,1,$last);
    while(1){  #swap with largest kid while any kid is larger
	my $left_exists=  $#$heap >= $i*2-1 || last;
	my $right_exists= $#$heap >= $i*2;
	my($left,$right)=@$heap[$i*2-1,$i*2];
	last if (!$left_exists  or $last > $left)
            and (!$right_exists or $last > $right);
	$i = $i*2 + ($right_exists && $left < $right);
	@$heap[$i-1,$i/2-1]=@$heap[$i/2-1,$i-1];
    }
    $top
}

=head2 pushsort

Adds one or more element to a numerically sorted array and keeps it sorted.

  pushsort @a, 13;                         # this...
  push     @a, 13; @a = sort {$a<=>$b} @a; # is the same as this, but the former is faster if @a is large

=head2 pushsortstr

Same as pushsort except that the array is kept sorted alphanumerically (cmp) instead of numerically (<=>). See L</pushsort>.

  pushsort @a, "abc";                      # this...
  push     @a, "abc"; @a = sort @a;        # is the same as this, but the former is faster if @a is large

=cut

#todo: use List::BinarySearch::XS 'binsearch_pos';
our $Pushsort_cmpsub=undef;
sub pushsort (\@@) {
  my $ar=shift;

  #not needed but often faster
  if(!defined $Pushsort_cmpsub and @$ar+@_<100){ #hm speedup?
    @$ar=(sort {$a<=>$b} (@$ar,@_));
    return 0+@$ar;
  }

  for my $v (@_){

    #not needed but often faster
    if(!defined $Pushsort_cmpsub){ #faster rank() in most cases
      push    @$ar, $v and next if $v>=$$ar[-1];
      unshift @$ar, $v and next if $v< $$ar[0];
    }

    splice @$ar, binsearch($v,$ar,1,$Pushsort_cmpsub)+1, 0, $v;
  }
  0+@$ar
}
sub pushsortstr(\@@){ local $Pushsort_cmpsub=sub{$_[0]cmp$_[1]}; pushsort(@_) } #speedup: copy sub pushsort

=head2 binsearch

Returns the position of an element in a numerically sorted array. Returns undef if the element is not found.

B<Input:> Two, three or four arguments

B<First argument:> the element to find. Usually a number.

B<Second argument:> a reference to the array to search in. The array
should be sorted in ascending numerical order (se exceptions below).

B<Third argument:>  Optional. Default false.

If true, whether result I<not found> should return undef or a fractional position.

If the third argument is false binsearch returns undef if the element is not found.

If the third argument is true binsearch returns 0.5 plus closest position below the searched value.

Returns C< last position + 0.5 > if the searched element is greater than all elements in the sorted array.

Returns C< -0.5 > if the searched element is less than all elements in the sorted array.

Fourth argument: Optional. Default C<< sub { $_[0] <=> $_[1] } >>.

If present, the fourth argument is either:

=over 4

=item * a code-ref that alters the way binsearch compares two elements, default is C<< sub{$_[0]<=>$_[1]} >>

=item * a string that works as a hash key (column name), see example below

=back

B<Examples:>

 binsearch(10,[5,10,15,20]);                                # 1
 binsearch(10,[20,15,10,5],undef,sub{$_[1]<=>$_[0]});       # 2 search arrays sorted numerically in opposite order
 binsearch("c",["a","b","c","d"],undef,sub{$_[0]cmp$_[1]}); # 2 search arrays sorted alphanumerically
 binsearchstr("b",["a","b","c","d"]);                       # 1 search arrays sorted alphanumerically

 my @data=(  map {  {num=>$_, sqrt=>sqrt($_), square=>$_**2}  }
             grep !$_%7, 1..1000000   );
 my $i = binsearch( {num=>913374}, \@data, undef, sub {$_[0]{num} <=> $_[1]{num}} );
 my $i = binsearch( {num=>913374}, \@data, undef, 'num' );                           #same as previous line
 my $found_hashref = defined $i ? $data[$i] : undef;

=head2 binsearchstr

Same as binsearch except that the arrays is sorted alphanumerically
(cmp) instead of numerically (<=>) and the searched element is a
string, not a number. See L</binsearch>.

=cut

our $Binsearch_steps;
our $Binsearch_maxsteps=100;
sub binsearch {
  my($search,$aref,$insertpos,$cmpsub)=@_; #search pos of search in array
  croak "binsearch did not get arrayref as second arg" if ref($aref) ne 'ARRAY';
  croak "binsearch got fourth arg which is not a code-ref" if defined $cmpsub and ref($cmpsub) and ref($cmpsub) ne 'CODE';
  if(defined $cmpsub and !ref($cmpsub)){
      my $key=$cmpsub;
      $cmpsub = sub{ $_[0]{$key} <=> $_[1]{$key} };
  }
  return $insertpos ? -0.5 : undef if !@$aref;
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

=head2 rank

B<Input:> Two or three arguments. N and an arrayref for the list to look at.

In scalar context: Returns the nth smallest number in an array. The array doesn't have to be sorted.

In array context: Returns the n smallest numbers in an array.

To return the n(th) largest number(s) instead of smallest, just negate n.

An optional third argument can be a sub that is used to compare the elements of the input array.

Examples:

 my $second_smallest = rank(2, [11,12,13,14]);  # 12
 my @top10           = rank(-10, [1..100]);     # 100, 99, 98, 97, 96, 95, 94, 93, 92, 91
 my $max             = rank(-1, [101,102,103,102,101]); #103
 my @contest         = ({name=>"Alice",score=>14},{name=>"Bob",score=>13},{name=>"Eve",score=>12});
 my $second          = rank(2, \@contest, sub{$_[1]{score}<=>$_[0]{score}})->{name}; #Bob

=head2 rankstr

Just as C<rank> but sorts alphanumerically (strings, cmp) instead of numerically.

=cut

sub rank {
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

=head2 egrep

Extended grep.

Works like L<grep> but with more insight: local vars $i, $n, $prev, $next, $prevr and $nextr are available:

$i is the current index, starts with 0, ends with the length of the input array minus one

$n is the current element number, starts with 1, $n = $i + 1

$prev is the previous value (undef if current is first)

$next is the next value (undef if current is last)

$prevr is the previous value, rotated so that the previous of the first element is the last element

$nextr is the next value, rotated so that the next of the last element is the first element

$_ is the current value, just as with Perls built-in grep

 my @a = (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20);  # 1..20
 my @r = egrep { $_ % 3 == 0 } @a;  # @r is 3, 6, 9, 12, 15, 18. Plain grep could have been used here
 my @r = egrep { $i==1 or $next==12 or $prev==14 } @a;  # @r is now 2, 11, 15

 my @a=2..44;
 egrep { $prev =~/4$/ or $next =~/2$/ } @a;  # 5, 11, 15, 21, 25, 31, 35, 41
 egrep { $prevr=~/4$/ or $nextr=~/2$/ } @a;  # 2, 5, 11, 15, 21, 25, 31, 35, 41, 44
 egrep { $i%7==0 } @a;                       # 2, 9, 16, 23, 30, 37, 44
 egrep { $n%7==0 } @a;                       # 8, 15, 22, 29, 36, 43

=cut

sub egrep (&@) {
    my($code,$i,$package)=(shift,-1,(caller)[0]);
    my %h=map{($_=>"${package}::$_")}qw(i n prev next prevr nextr);
    no strict 'refs';
    grep {
	#no strict 'refs'; #not here! "no" not allowed in expression in perl5.16
	local ${$h{i}}     = ++$i;
	local ${$h{n}}     = $i+1;
	local ${$h{prev}}  = $i>0?$_[$i-1]:undef;
	local ${$h{next}}  = $i<$#_?$_[$i+1]:undef;
	local ${$h{prevr}} = $_[$i>0?$i-1:$#_];
	local ${$h{nextr}} = $_[$i<$#_?$i+1:0];
	&$code;
    }
    @_;
}

=head2 eqarr

B<Input:> Two or more references to arrays.

B<Output:> True (1) or false (0) for whether or not the arrays are numerically I<and> alphanumerically equal.
Comparing each element in each array with both C< == > and C< eq >.

Examples:

 eqarr([1,2,3],[1,2,3],[1,2,3]); # 1 (true)
 eqarr([1,2,3],[1,2,3],[1,2,4]); # 0 (false)
 eqarr([1,2,3],[1,2,3,4]);       # undef (different size, false)
 eqarr([1,2,3]);                 # croak (should be two or more arrays)
 eqarr([1,2,3],1,2,3);           # croak (not arraysrefs)

=cut

sub eqarr {
  my @arefs=@_;
  croak if @arefs<2;
  ref($_) ne 'ARRAY' and croak for @arefs;
  @{$arefs[0]} != @{$arefs[$_]} and return undef for 1..$#arefs;
  my $ant;

  for my $ar (@arefs[1..$#arefs]){
    for(0..@$ar-1){
      ++$ant and $ant>100 and croak ">100";  #TODO: feiler ved sammenligning av to tabeller > 10000(?) tall
      return 0 if $arefs[0][$_] ne $$ar[$_]
   	       or $arefs[0][$_] != $$ar[$_];
    }
  }
  return 1;
}

=head2 sorted

Return true if the input array is numerically sorted.

  @a=(1..10); print "array is sorted" if sorted @a;  #true

Optionally the last argument can be a comparison sub:

  @person=({Rank=>1,Name=>'Amy'}, {Rank=>2,Name=>'Paula'}, {Rank=>3,Name=>'Ruth'});
  print "Persons are sorted" if sorted @person, sub{$_[0]{Rank}<=>$_[1]{Rank}};

=head2 sortedstr

Return true if the input array is I<alpha>numerically sorted.

  @a=(1..10);      print "array is sorted" if sortedstr @a; #false
  @a=("01".."10"); print "array is sorted" if sortedstr @a; #true

=cut

sub sorted (\@@) {
  my($a,$cmpsub)=@_;
  if($cmpsub){ &$cmpsub($$a[$_],$$a[$_+1])>0 and return 0 for 0..$#$a-1 }
  else       { $$a[$_] > $$a[$_+1]           and return 0 for 0..$#$a-1 }
  return 1;
}
#sub sortedstr { sorted(@_,sub{$_[0]cmp$_[1]}) }
sub sortedstr { $_[$_] gt $_[$_+1] and return 0 for 0..$#$_-1; return 1 }

sub sortby {
    my($arr,@by)=@_;
    die if grep/^-/,@by; #hm 4now todo! - dash meaning descending order
    my $pattern=join(" ",map"%-40s",@by);#hm 4now bad, cant handle numeric sort
    map$$_[0],
    sort{$$a[1]cmp$$b[1]}
    map[$_,sprintf($pattern,@$_{@by})],
    @$arr;
}


=head2 subarrays

Returns all 2^n-1 combinatory subarrays of an array where each element
of input array participates or not. Note: The empty array is not among
the returned arrayrefs unless an empty input is given.

 my @a = subarrays( 'a', 'b', 'c' );         # same as:
 my @a = ( ['a'    ],
           [    'b'],
           ['a','b'],
           [        'c'],
           ['a',    'c'],
           [    'b','c'],
           ['a','b','c'] );

 sub subarrays { map { my $n = 2*$_; [ grep {($n/=2)%2} @_ ] } 1 .. 2**@_-1 } #implemented as

=cut

sub subarrays { map { my $n = 2*$_; [ grep {($n/=2)%2} @_ ] } 1 .. 2**@_-1 }

=head2 part

B<Input:> A code-ref and a list

B<Output:> Two array-refs

Like C<grep> but returns the false list as well. Partitions a list
into two lists where each element goes into the first or second list
whether the predicate (a code-ref) is true or false for that element.

 my( $odd, $even ) = part {$_%2} (1..8);
 print for @$odd;   #prints 1 3 5 7
 print for @$even;  #prints 2 4 6 8

(Works like C< partition() > in the Scala programming language)

=head2 parth

Like C<part> but returns any number of lists. Not just two. Sort of like I<group by> in SQL.

B<Input:> A code-ref and a list

B<Output:> A hash where the returned values from the code-ref are keys and the values are arrayrefs to the list elements which gave those keys.

 my @list = ('These','are','the','words','of','this','array');
 my %hash = parth { uc(substr($_,0,1)) } @list;  #returns a hash where keys are first char in uppercase
 print srlz(\%hash, 'hash');

Prints:

 %hash = (  T=>['These','the','this'],
            A=>['are','array'],
            O=>['of'],
            W=>['words']  )

=head2 parta

Like L<parth> but returns an array of lists where the predicate returns an index number.

 my @a = parta { length } qw/These are the words of this array/;

Result:

 @a = ( undef, undef, ['of'], ['are','the'], ['this'], ['These','words','array'] )

Two undefs at first (index positions 0 and 1) since there are no words of length 0 or 1 in the input array.

=cut

sub part  (&@) { my($c,@r)=(shift,[],[]); push @{ $r[ &$c?0:1 ] }, $_ for @_; @r }
sub parth (&@) { my($c,%r)=(shift);       push @{ $r{ &$c     } }, $_ for @_; %r }
sub parta (&@) { my($c,@r)=(shift);       push @{ $r[ &$c     ] }, $_ for @_; @r }
#sub mapn (&$@) { ... } like map but @_ contains n elems at a time, n=1 is map

=head2 refa

=head2 refh

=head2 refs

=head2 refaa

=head2 refah

=head2 refha

=head2 refhh

Returns true or false (1 or 0) if the argument is an arrayref, hashref, scalarref, ref to an array of arrays, ref to an array of hashes

Examples:

  my $ref_to_array  = [1,2,3];
  my $ref_to_hash   = {1,100,2,200,3,300};
  my $ref_to_scalar = \"String";
  print "arrayref"  if ref($ref_to_array)  eq 'ARRAY';  #true
  print "hashref"   if ref($ref_to_hash)   eq 'HASH';   #true
  print "scalarref" if ref($ref_to_scalar) eq 'SCALAR'; #true
  print "arrayref"  if refa($ref_to_array);             #also true, without: eq 'ARRAY'
  print "hashref"   if refh($ref_to_hash);              #also true, without: eq 'HASH'
  print "scalarref" if refs($ref_to_scalar);            #also true, without: eq 'SCALAR'

  my $ref_to_array_of_arrays = [ [1,2,3], [2,4,8], [10,100,1000] ];
  my $ref_to_array_of_hashes = [ {1=>10, 2=>100}, {first=>1, second=>2} ];
  my $ref_to_hash_of_arrays  = { alice=>[1,2,3], bob=>[2,4,8], eve=>[10,100,1000] };
  my $ref_to_hash_of_hashes  = { alice=>{a=>22,b=>11}, bob=>{a=>33,b=>66} };

  print "aa"  if refaa($ref_to_array_of_arrays);         #true
  print "ah"  if refah($ref_to_array_of_hashes);         #true
  print "ha"  if refha($ref_to_hash_of_arrays);          #true
  print "hh"  if refhh($ref_to_hash_of_hashes);          #true

=cut

sub refa  { ref($_[0]) eq 'ARRAY'  ? 1                         : ref($_[0]) ? 0 : undef }
sub refh  { ref($_[0]) eq 'HASH'   ? 1                         : ref($_[0]) ? 0 : undef }
sub refs  { ref($_[0]) eq 'SCALAR' ? 1                         : ref($_[0]) ? 0 : undef }
sub refaa { ref($_[0]) eq 'ARRAY'  ? refa($_[0][0])            : ref($_[0]) ? 0 : undef }
sub refah { ref($_[0]) eq 'ARRAY'  ? refh($_[0][0])            : ref($_[0]) ? 0 : undef }
sub refha { ref($_[0]) eq 'HASH'   ? refa((values%{$_[0]})[0]) : ref($_[0]) ? 0 : undef }
sub refhh { ref($_[0]) eq 'HASH'   ? refh((values%{$_[0]})[0]) : ref($_[0]) ? 0 : undef }


=head2 pushr

=head2 popr

=head2 shiftr

=head2 unshiftr

=head2 splicer

=head2 keysr

=head2 valuesr

=head2 eachr

=head2 joinr

In Perl versions 5.12 - 5.22 push, pop, shift, unshift, splice, keys, values and each
handled references to arrays and references to hashes just as if they where arrays and hashes. Examples:

 my $person={name=>'Gaga', array=>[1,2,3]};
 push    $person{array}  , 4;  #works in perl 5.12-5.22 but not before and after
 push @{ $person{array} }, 4;  #works in all perl5 versions
 pushr   $person{array}  , 4;  #use Acme::Tools and this should work in perl >= 5.8
 popr    $person{array};       #returns 4

=cut

sub pushr    { push    @{shift()}, @_ } # ?    ($@)
sub popr     { pop     @{shift()}     }
sub shiftr   { shift   @{shift()}     }
sub unshiftr { unshift @{shift()}, @_ }
sub splicer  { @_==1 ? splice( @{shift()} )
              :@_==2 ? splice( @{shift()}, shift() )
              :@_==3 ? splice( @{shift()}, shift(), shift() )
              :@_>=4 ? splice( @{shift()}, shift(), shift(), @_ ) : croak }
sub keysr    { ref($_[0]) eq 'HASH' ? keys(%{shift()}) : keysr({@{shift()}})  } #hm sort(keys%{shift()}) ?
sub valuesr  { values( %{shift()} )    }
sub eachr    { ref($_[0]) eq 'HASH'  ? each(%{shift()})
             #:ref($_[0]) eq 'ARRAY' ? each(@{shift()})  # perl 5.8.8 cannot compile each on array! eval?
		   :                        croak("eachr needs hashref or arrayref got '".ref($_[0])."'") }
sub joinr    {join(shift(),@{shift()})}
#sub mapr    # som scala: hvis map faar subref se kalles den sub paa hvert elem og resultatet returneres

#sub eachr    { each(%{shift()}) }

=head2 pile

B<Input:> a pile size s and a list

B<Output:> A list of lists of length s or the length of the remainder in
the last list. Piles together the input list in lists of the given size.

 my @list=(1,2,3,4,5,6,7,8,9,10);
 my @piles = pile(3, @list );        # ([1,2,3], [4,5,6], [7,8,9], [10])
 my $i=0;
 my @piles = parta {$i++/3} @list;   # same as above pile(3, @list)

=cut

sub pile { my $size=shift; my @r; for (@_){ push@r,[] if !@r or @{$r[-1]}>=$size; push @{$r[-1]}, $_ } @r }
#sub pile {my$s=shift; @{(reduce {!ref($a) ? [[$b]] : @{$$a[-1]} >= $s ? [@$a,[$b]] : [@$a[0..$#$a-1],[@{$$a[-1]},$b]]} 0,@_)[0]} }
#sub pile {my$s=shift; @{(reduce {!ref($a) ? [[$b]] : @{$$a[-1]} >= $s ? [@$a,[$b]] : [@$a[0..$#$a-1],[@{$$a[-1]},$b]]} 0,@_)[0]} }
#sub pile {my$s=shift; @{(reduce {!ref($a) ? [[$b]] : @{$$a[-1]} >= $s ? [@$a,[$b]] : do{push@{$$a[-1]},$b;$a}} 0,@_)[0]}
#sub pile {my$s=shift; @{(reduce {ref($a)?do{push@$a,[]if@{$$a[-1]}>=$s;push@{$$a[-1]},$b;$a}:[[$b]]} 0,@_)[0]}}

=head2 aoh2sql

  my @oceania=(
    {Area=>undef,   Capital=>'Pago Pago',        Code=>'AS', Name=>'American Samoa',                  Population=>54343},
    {Area=>7686850, Capital=>'Canberra',         Code=>'AU', Name=>'Australia',                       Population=>22751014},
    {Area=>undef,   Capital=>'West Island',      Code=>'CC', Name=>'Cocos (Keeling) Islands',         Population=>596},
    {Area=>240,     Capital=>'Avarua',           Code=>'CK', Name=>'Cook Islands',                    Population=>9838},
    {Area=>undef,   Capital=>'Flying Fish Cove', Code=>'CX', Name=>'Christmas Island',                Population=>1530},
    {Area=>18270,   Capital=>'Suva',             Code=>'FJ', Name=>'Fiji',                            Population=>909389},
    {Area=>702,     Capital=>'Palikir',          Code=>'FM', Name=>'Micronesia, Federated States of', Population=>105216},
    {Area=>549,     Capital=>'Hagatna (Agana)',  Code=>'GU', Name=>'Guam',                            Population=>161785},
    {Area=>811,     Capital=>'Tarawa',           Code=>'KI', Name=>'Kiribati',                        Population=>105711},
    {Area=>181.3,   Capital=>'Majuro',           Code=>'MH', Name=>'Marshall Islands',                Population=>72191},
    {Area=>19060,   Capital=>'Noumea',           Code=>'NC', Name=>'New Caledonia',                   Population=>271615},
    {Area=>undef,   Capital=>'Kingston',         Code=>'NF', Name=>'Norfolk Island',                  Population=>2210},
    {Area=>21,      Capital=>'Yaren District',   Code=>'NR', Name=>'Nauru',                           Population=>9540},
    {Area=>260,     Capital=>'Alofi',            Code=>'NU', Name=>'Niue',                            Population=>1190},
    {Area=>268680,  Capital=>'Wellington',       Code=>'NZ', Name=>'New Zealand',                     Population=>4438393},
    {Area=>undef,   Capital=>'Papeete',          Code=>'PF', Name=>'French Polynesia',                Population=>282703},
    {Area=>462840,  Capital=>'Port Moresby',     Code=>'PG', Name=>'Papua New Guinea',                Population=>6672429},
    {Area=>undef,   Capital=>'Adamstown',        Code=>'PN', Name=>'Pitcairn',                        Population=>48},
    {Area=>458,     Capital=>'Melekeok',         Code=>'PW', Name=>'Palau',                           Population=>21265},
    {Area=>28450,   Capital=>'Honiara',          Code=>'SB', Name=>'Solomon Islands',                 Population=>622469},
    {Area=>undef,   Capital=>undef,              Code=>'TK', Name=>'Tokelau',                         Population=>1337},
    {Area=>26,      Capital=>'Funafuti',         Code=>'TV', Name=>'Tuvalu',                          Population=>10869},
    {Area=>12200,   Capital=>'Port-Vila',        Code=>'VU', Name=>'Vanuatu',                         Population=>272264},
    {Area=>undef,   Capital=>'Mata-Utu',         Code=>'WF', Name=>'Wallis and Futuna',               Population=>15500},
    {Area=>2944,    Capital=>'Apia',             Code=>'WS', Name=>'Samoa (Western)',                 Population=>197773}
  );

 print aoh2sql(\@oceania,{
    name=>'country',
    drop=>2,
   #number=>'numeric',    #default
   #varchar=>'varchar',   #default, change to varchar2 if Oracle
   #date=>'date',         #default, perhaps change to 'timestamp with time zone' if postgres
   #varchar_maxlen=>4000, #default, 4000 (used to be?) is max in Oracle
   #create=>1,            #default, use 0 to dont include create table
   #drop=>0,              #default 0: dont include drop table x; 1: drop table x; 2: drop table if exists x;
   #end=>"commit;\n",
   #begin=>"begin;\n",
   #fix_colnames=>0,
 });

Returns:

 begin;

 drop table if exists country;

 create table country (
   Area                           numeric(9,1),
   Capital                        varchar(16),
   Code                           varchar(2) not null,
   Name                           varchar(36) not null,
   Population                     numeric(9)
 );

 insert into country values (null,'Pago Pago','AS','American Samoa',54343);
 insert into country values (7686850,'Canberra','AU','Australia',22751014);
 insert into country values (null,'West Island','CC','Cocos (Keeling) Islands',596);
 insert into country values (240,'Avarua','CK','Cook Islands',9838);
 insert into country values (null,'Flying Fish Cove','CX','Christmas Island',1530);
 insert into country values (18270,'Suva','FJ','Fiji',909389);
 insert into country values (702,'Palikir','FM','Micronesia, Federated States of',105216);
 insert into country values (549,'Hagatna (Agana)','GU','Guam',161785);
 insert into country values (811,'Tarawa','KI','Kiribati',105711);
 insert into country values (181.3,'Majuro','MH','Marshall Islands',72191);
 insert into country values (19060,'Noumea','NC','New Caledonia',271615);
 insert into country values (null,'Kingston','NF','Norfolk Island',2210);
 insert into country values (21,'Yaren District','NR','Nauru',9540);
 insert into country values (260,'Alofi','NU','Niue',1190);
 insert into country values (268680,'Wellington','NZ','New Zealand',4438393);
 insert into country values (null,'Papeete','PF','French Polynesia',282703);
 insert into country values (462840,'Port Moresby','PG','Papua New Guinea',6672429);
 insert into country values (null,'Adamstown','PN','Pitcairn',48);
 insert into country values (458,'Melekeok','PW','Palau',21265);
 insert into country values (28450,'Honiara','SB','Solomon Islands',622469);
 insert into country values (null,null,'TK','Tokelau',1337);
 insert into country values (26,'Funafuti','TV','Tuvalu',10869);
 insert into country values (12200,'Port-Vila','VU','Vanuatu',272264);
 insert into country values (null,'Mata-Utu','WF','Wallis and Futuna',15500);
 insert into country values (2944,'Apia','WS','Samoa (Western)',197773);
 commit;


=cut

sub aoh2sql {
    my($aoh,$conf)=@_;
    my %def=( #defaults
	name=>'my_table',
	number=>'numeric',
	varchar=>'varchar',
	date=>'date',
	varchar_maxlen=>4000,
	create=>1,
	drop=>0,  # 1 drop table if exists, 2 plain drop
	end=>"commit;\n",
	begin=>"begin;\n",
	fix_colnames=>0,
	);
    my %conf=(%def,(@_<2?():%$conf));
#    $conf{$_}||=$def{$_} for keys%def;
    my %col;
    map $col{$_}++, keys %$_ for @$aoh;
    my @col=sort keys %col;
    my @colerr=grep!/^[a-z]\w+$/i,@col;
    croak "Invalid column name(s): @colerr" if @colerr and !$conf{fix_colnames};
    my(%t,%tdb);
    for my $c (@col){
	my($l,$s,$p,$nn,%ant,$t)=(0,0,0,0);
	for my $r (@$aoh){
	    my $v=$$r{$c};
	    next if !defined$v or $v!~/\S/;
	    $nn++;
	    $l=length($v) if length($v)>$l;
	    no warnings 'uninitialized';
	    if($v=~/^(18|19|20)\d\d(0[1-9]|1[0-2])(0[1-9]|1\d|2\d|3[01])-?\d\d:?\d\d:?\d\d$/ and $conf{date}){
		$ant{date}++;
		next;
	    }
	    elsif($v=~/^\s*[-+]?(\d*)(\.\d+)?([Ee]\-?\d+)?\s*$/ and length("$1$2") and $conf{number}){
		$ant{number}++;
		$s=length("$1.$2") if length("$1.$2")>$s;#hm
		$p=length($2)-1 if $2 and length($2)-1>$p;
		next;
	    }
	    else {
		$ant{varchar}++;
	    }
	}
	$t||='varchar' if $ant{varchar}  or  $ant{number} and $ant{date};
	$t||='number'  if $ant{number};
	$t||='date'    if $ant{date};
	$t||='varchar'; #hm
	$l=$conf{varchar_maxlen} if $conf{varchar_maxlen} and $l>$conf{varchar_maxlen};
	$l||=1;
	my $tdb;
	$tdb="$conf{$t}($l)"    if $t eq 'varchar';
	$tdb="$conf{$t}($s)"    if $t eq 'number' and $p==0;
	$tdb="$conf{$t}($s,$p)" if $t eq 'number' and $p>0 and ++$s;
	$tdb.=" not null" if $nn == 0+@$aoh;
	$t{$c}=$t;
	$tdb{$c}=$tdb;
    }
    my $sql;
    $sql="create table $conf{name} (".
	 join(",",map sprintf("\n  %-30s %s",do{s/\W+//g;$_},$tdb{$_}), @col). "\n);\n\n" if $conf{create};
    my $val=sub{my($v,$t)=@_;defined$v or $v="";!length($v)?'null':$t eq 'number' ? $v : "'".repl($v,"\'","''")."'"};
    for my $r (@$aoh){
	my $v=join",",map &$val($$r{$_},$t{$_}), @col;
	$sql.="insert into $conf{name} values ($v);\n";
    }
    $sql="drop table $conf{name};\n\n$sql" if $conf{drop}==1;
    $sql="drop table if exists $conf{name};\n\n$sql" if $conf{drop}>=2;
    $sql="$conf{begin}\n$sql" if $conf{begin};
    $sql.=$conf{end};
    $sql;
}

sub aoh2xls { croak "Not implemented yet: aoh2xls" } #TODO

=head2 csv

Input, one or two arguments:
* The 1st arg is either an array of arrayrefs or an array of hashrefs
* The 2nd optional arg is a separation char. A comma is default

Outputs a multiline string where each line is a string of comma
separated values (thus the name csv). A value that contains comma in
itself is surrounded by " chars. Example:

 print csv(['Name','Address','Age'], ['Jerry','Manhattan, NYC',35],
           ['George','Queens, NYC',35], ['Cosmo','New Jersey',42] );

 Name,Address,Age
 Jerry,"Manhattan NYC",35
 George,"Queens, NYC",35
 Cosmo,New Jersey,42

=cut

sub csv {
  my $char=@_>0&&!ref($_[-1]) ? pop() : ',';
 #join '', map { join($char,map{!defined($_)?'':do{my$s=s/"/""/gr;/$char|\n|^\s|\s$|"/?qq("$s"):length($s)?$s:'""'}}@$_)."\n" } @_; #>v5.12
  join '', map { join($char,map{!defined($_)?'':do{my$s=$_;$s=~s/"/""/g;/$char|\n|^\s|\s$|"/?qq("$s"):length($s)?$s:'""'}}@$_)."\n" } @_;
}

sub uncsv {
  my($char,$tag,@s)=(@_>1?$_[1]:',', '__/&m=m&/__'); #hm, $tag='¤';
  map{ [ map{ my$q=s/$tag(\d+)/$s[$1]/g; s/""/"/g; length($_)?$_:$q?'':undef } split/\s*$char\s*/ ] }
  split /\n|\cM?\cJ/,
 #$_[0]=~s/"(.*?(?:""|[^"])*)"/ push@s,$1; $tag.$#s /segr; #>v5.12
  do{$_[0]=~s/"(.*?(?:""|[^"])*)"/ push@s,$1; $tag.$#s /seg;$_[0]}
}


=head1 STATISTICS

=head2 sum

Returns the sum of a list of numbers. Undef is ignored.

 print sum(1,3,undef,8);   # 12
 print sum(1..1000);       # 500500
 print sum(undef);         # undef

=cut

sub sum { my $sum; no warnings; defined($_) and $sum+=$_ for @_; $sum }

=head2 avg

Returns the I<average> number of a list of numbers. That is C<sum / count>

 print avg(  2, 4, 9);   # 5      (2+4+9) / 3 = 5
 print avg( [2, 4, 9] ); # 5      pass by reference, same result but faster for large arrays

Also known as I<arithmetic mean>.

Pass by reference: If one argument is given and it is a reference to an array,
this array is taken as the list of numbers. This mode is about twice as fast
for 10000 numbers or more. It most likely also saves memory.

=cut

sub avg {
  my($sum,$n,@a)=(0,0);
  no warnings;
  if( @_==0 )                          { return undef             }
  if( @_==1 and ref($_[0]) eq 'ARRAY' ){ @a=grep defined,@{$_[0]} }
  else                                 { @a=grep defined,@_       }
  if( @a==0 )                          { return undef             }
  $sum+=$_ for @a;
  return $sum/@a
}

=head2 geomavg

Returns the I<geometric average> (a.k.a I<geometric mean>) of a list of numbers.

 print geomavg(10,100,1000,10000,100000);               # 1000
 print 0+ (10*100*1000*10000*100000) ** (1/5);          # 1000 same thing
 print exp(avg(map log($_),10,100,1000,10000,100000));  # 1000 same thing, this is how geomavg() works internally

=cut

sub geomavg { exp(avg(map log($_), @_)) }

=head2 harmonicavg

Returns the I<harmonic average> (a.k.a I<geometric mean>) of a list of numbers. L<http://en.wikipedia.org/wiki/Harmonic_mean>

 print harmonicavg(10,11,12);               # 3 / ( 1/10 + 1/11 + 1/12) = 10.939226519337

=cut

sub harmonicavg { my $s; $s+=1/$_ for @_; @_/$s }

=head2 variance

C<< variance = ( sum (x[i]-Average)**2)/(n-1) >>

=cut

sub variance {
  my $sumx2; $sumx2+=$_*$_ for @_;
  my $sumx; $sumx+=$_ for @_;
  (@_*$sumx2-$sumx*$sumx)/(@_*(@_-1));
}

=head2 stddev

C<< Standard_Deviation = sqrt(variance) >>

Standard deviation (stddev) is a measurement of the width of a normal
distribution where one stddev on each side of the mean covers 68% and
two stddevs 95%.  Normal distributions are sometimes called Gauss curves
or Bell shapes. L<https://en.wikipedia.org/wiki/Standard_deviation>

 stddev(4,5,6,5,6,4,3,5,5,6,7,6,5,7,5,6,4)         # = 1.0914103126635
 avg(@testscores) + stddev(@testscores)            # = the score for one stddev above avg, 115
 avg(@testscores) - stddev(@testscores)            # = the score for one stddev below avg, 85

=cut

sub stddev {
  return undef        if @_==0;
  return stddev(\@_)  if @_>0 and !ref($_[0]);
  my $ar=shift;
  return undef        if @$ar==0;
  return 0            if @$ar==1;
  my $sumx2; $sumx2 += $_*$_ for @$ar;
  my $sumx;  $sumx  += $_    for @$ar;
  sqrt( (@$ar*$sumx2-$sumx*$sumx)/(@$ar*(@$ar-1)) );
}

=head2 rstddev

Relative stddev = stddev / avg

=cut

sub rstddev { stddev(@_) / avg(@_) }

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

sub median {
  no warnings;
  my @list = sort {$a<=>$b} @_;
  my $n=@list;
  $n%2 ?  $list[($n-1)/2]
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

But the latter is about three times faster for large @data since it then sorts those numbers only once.

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

 Percentile    Method 1                      Method 2
               (Acme::Tools::percentile      (Oracle)
               and others)
 ------------- ----------------------------- ---------
 0             -2                            1
 1             -1.61                         1.33
 25            6.25                          6.75
 50 (median)   15.5                          15.5
 75            46.5                          41.5
 99            1372.19                       943.93
 100           1429                          992

Found like this:

 perl -MAcme::Tools -le 'print for percentile([0,1,25,50,75,99,100], 1,4,6,7,8,9,22,24,39,49,555,992)'

And like this in Oracle-databases:

 select
   percentile_cont(0.00) within group(order by n) per0,
   percentile_cont(0.01) within group(order by n) per1,
   percentile_cont(0.25) within group(order by n) per25,
   percentile_cont(0.50) within group(order by n) per50,
   percentile_cont(0.75) within group(order by n) per75,
   percentile_cont(0.99) within group(order by n) per99,
   percentile_cont(1.00) within group(order by n) per100
 from (
   select 0+regexp_substr('1,4,6,7,8,9,22,24,39,49,555,992','[^,]+',1,i) n
   from dual,(select level i from dual connect by level <= 12)
 );

(Oracle also provides a similar function: C<percentile_disc> where I<disc>
is short for I<discrete>, meaning no interpolation is taking
place. Instead the closest number from the data set is picked.)

=cut

sub percentile {
  my(@p,@t,@ret);
  if(ref($_[0]) eq 'ARRAY'){ @p=@{shift()} }
  elsif(not ref($_[0]))    { @p=(shift())  }
  else{croak()}
  @t=@_;
  return if !@p;
  croak if !@t;
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

=head1 RANDOM

=head2 random

B<Input:> One or two arguments.

B<Output:>

If two integer arguments: returns a random integer between the integers in argument one and two.

If the first argument is an arrayref: returns a random member of that array without changing the array.

If the first argument is an arrayref and there is a second arg: return that many random members of that array

If the first argument is an hashref and there is no second arg: return a random key weighted by the values of that hash

If the first argument is an hashref and there is a second arg: return that many random keys weighted by the values of that hash

If there is no second argument and the first is an integer, a random integer between 0 and that number is returned. Including 0 and the number itself.

B<Examples:>

 $dice=random(1,6);                                      # 1, 2, 3, 4, 5 or 6
 $dice=random([1..6]);                                   # same as previous
 @dice=random([1..6],10);                                # 10 dice tosses
 $dice=random({1=>1, 2=>1, 3=>1, 4=>1, 5=>1, 6=>2});     # weighted dice with 6 being twice as likely as the others
 @dice=random({1=>1, 2=>1, 3=>1, 4=>1, 5=>1, 6=>2},10);  # 10 weighted dice tosses
 print random({head=>0.4999,tail=>0.4999,edge=>0.0002}); # coin toss (sum 1 here but not required to be)
 print random(2);                                        # prints 0, 1 or 2
 print 2**random(7);                                     # prints 1, 2, 4, 8, 16, 32, 64 or 128
 @dice=map random([1..6]), 1..10;                        # as third example above, but much slower
 perl -MAcme::Tools -le 'print for random({head=>0.499,tail=>0.499,edge=>0.002},10000);' | sort | uniq -c

=cut

sub random {
  my($from,$to)=@_;
  my $ref=ref($from);
  if($ref eq 'ARRAY'){
    my @r=map $$from[rand@$from], 1..$to||1;
    return @_>1?@r:$r[0];
  }
  elsif($ref eq 'HASH') {
    my @k=keys%$from;
    my $max;do{no warnings 'uninitialized';$_>$max and $max=$_ or $_<0 and croak"negative weight" for values%$from};
    my @r=map {my$r;1 while $$from{$r=$k[rand@k]}<rand($max);$r} 1..$to||1;
    return @_>1?@r:$r[0];
  }
  ($from,$to)=(0,$from) if @_==1;
  ($from,$to)=($to,$from) if $from>$to;
  return int($from+rand(1+$to-$from));
}
#todo?: https://en.wikipedia.org/wiki/Irwin%E2%80%93Hall_distribution

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
 print "Percent above two stddevs: ".(100*@M/@I)."%\n"; #prints a number close to 2.27%

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

sub random_gauss {
  my($avg,$stddev,$num)=@_;
  $avg=0    if !defined $avg;
  $stddev=1 if !defined $stddev;
  $num=1    if !defined $num;
  croak "random_gauss should have 0-3 arguments" if @_>3;
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

sub random_exp {
    my($lambda,$n)=@_;
    my $L=-1/$lambda;
    return     $L*log(1-rand()) if !@_;
    return map $L*log(1-rand()), 1..(defined$n?$n:1);
}

sub random_poisson {
    my($alpha,$n)=@_;
    $n=1 if !defined$n;
    my $A=exp(-$alpha);
    my @r=map{
	my($x,$p)=(1,rand());
	$p*=rand() while $p>=$A and ++$x;
	$x
    }1..$n;
    return $r[0] if @_<2;
    return @r;
}

=head2 mix

Mixes an array in random order. In-place if given an array reference or not if given an array.

C<mix()> could also have been named C<shuffle()>, as in shuffling a deck of cards.

Example:

This:

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

Note: C<List::Util::shuffle()> is approximately four times faster. Both respects the Perl built-in C<srand()>.

=cut

sub mix {
  if(@_==1 and ref($_[0]) eq 'ARRAY'){ #just one arg, and its ref array
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

=head2 pwgen

Generates random passwords.

B<Input:> 0-n args

* First arg: length of password(s), default 8

* Second arg: number of passwords, default 1

* Third arg: string containing legal chars in password, default A-Za-z0-9,-./&%_!

* Fourth to n'th arg: list of requirements for passwords, default if the third arg is false/undef (so default third arg is used) is:

 sub{/^[a-zA-Z0-9].*[a-zA-Z0-9]$/ and /[a-z]/ and /[A-Z]/ and /\d/ and /[,-.\/&%_!]/}

...meaning the password should:
* start and end with: a letter a-z (lower- or uppercase) or a digit 0-9
* should contain at least one char from each of the groups lower, upper, digit and special char

To keep the default requirement-sub but add additional ones just set the fourth arg to false/undef
and add your own requirements in the fifth arg and forward (examples below). Sub pwgen uses perls
own C<rand()> internally.

C<< $Acme::Tools::Pwgen_max_sec >> and C<< $Acme::Tools::Pwgen_max_trials >> can be set to adjust for how long
pwgen tries to find a password. Defaults for those are 0.01 and 10000.
Whenever one of the two limits is reached, a first generates a croak.

Examples:

 my $pw=pwgen();             # a random 8 chars password A-Z a-z 0-9 ,-./&%!_ (8 is default length)
 my $pw=pwgen(12);           # a random 12 chars password A-Z a-z 0-9 ,-./&%!_
 my @pw=pwgen(0,10);         # 10 random 8 chars passwords, containing the same possible chars
 my @pw=pwgen(0,1000,'A-Z'); # 1000 random 8 chars passwords containing just uppercase letters from A to Z

 pwgen(3);                                # dies, defaults require chars in each of 4 group (see above)
 pwgen(5,1,'A-C0-9',  qr/^\D{3}\d{2}$/);  # a 5 char string starting with three A, B or Cs and endring with two digits
 pwgen(5,1,'ABC0-9',sub{/^\D{3}\d{2}$/}); # same as above

Examples of adding additional requirements to the default ones:

 my @pwreq = ( qr/^[A-C]/ );
 pwgen(8,1,'','',@pwreq);    # use defaults for allowed chars and the standard requirements
                             # but also demand that the password must start with A, B or C

 push @pwreq, sub{ not /[a-z]{3}/i };
 pwgen(8,1,'','',@pwreq);    # as above and in addition the password should not contain three
                             # or more consecutive letters (to avoid "offensive" words perhaps)

=cut

our $Pwgen_max_sec=0.01;     #max seconds/password before croak (for hard to find requirements)
our $Pwgen_max_trials=10000; #max trials/password  before croak (for hard to find requirements)
our $Pwgen_sec=0;            #seconds used in last call to pwgen()
our $Pwgen_trials=0;         #trials in last call to pwgen()
sub pwgendefreq{/^[a-z].*[a-z\d]$/i and /[a-z]/ and /[A-Z]/ and /\d/ and /[,-.\/&%_!]/}
sub pwgen {
  my($len,$num,$chars,@req)=@_;
  $len||=8;
  $num||=1;
  $chars||='A-Za-z0-9,-./&%_!';
  $req[0]||=\&pwgendefreq if !$_[2];
  $chars=~s/([$_])-([$_])/join("","$1".."$2")/eg  for ('a-z','A-Z','0-9');
  my($c,$t,@pw,$d)=(length($chars),time_fp());
  ($Pwgen_trials,$Pwgen_sec)=(0,0);
  TRIAL:
  while(@pw<$num){
    croak "pwgen timeout after $Pwgen_trials trials"
      if ++$Pwgen_trials   >= $Pwgen_max_trials
      or ($d=time_fp()-$t) >  $Pwgen_max_sec*$num
            and $d!~/^\d+$/; #jic int from time_fp
    my $pw=join"",map substr($chars,rand($c),1),1..$len;
    for my $r (@req){
      if   (ref($r) eq 'CODE'  ){ local$_=$pw; &$r()    or next TRIAL }
      elsif(ref($r) eq 'Regexp'){ no warnings; $pw=~$r or next TRIAL }
      else                      { croak "pwgen: invalid req type $r ".ref($r) }
    }
    push@pw,$pw;
  }
  $Pwgen_sec=time_fp()-$t;
  return $pw[0] if $num==1;
  return @pw;
}

#push_srand() and pop_srand dont work as intended
#=head2 push_srand
#
# srand(7); print rand(), 
#
#=head2 pop_srand
#
#=cut
our @Srand;
sub push_srand {
    $] >= 5.024 or croak "Returning current srand (when called without params) started with Perl v5.14, see perldoc -f srand";
    my($new,$old)=(shift(),srand());
    push @Srand, $old;
    srand($new) if defined $new;
    $old;
}
sub pop_srand {
    croak "Can not pop_srand more times than push_srand" if !@Srand;
    srand(pop@Srand);
}

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
# sub vecibs ($) {
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


=head1 SETS

=head2 distinct

Returns the values of the input list, sorted alfanumerically, but only
one of each value. This is the same as L</uniq> except uniq does not
sort the returned list.

Example:

 print join(", ", distinct(4,9,3,4,"abc",3,"abc"));    # 3, 4, 9, abc
 print join(", ", distinct(4,9,30,4,"abc",30,"abc"));  # 30, 4, 9, abc       note: alphanumeric sort

=cut

sub distinct { sort keys %{{map {($_,1)} @_}} }

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

sub in     { no warnings 'uninitialized'; my $val=shift; $_ eq $val and return 1 for @_; return 0 }
sub in_num { no warnings 'uninitialized'; my $val=shift; $_ == $val and return 1 for @_; return 0 }

=head2 union

Input: Two arrayrefs. (Two lists, that is)

Output: An array containing all elements from both input lists, but no element more than once even if it occurs twice or more in the input.

Example, prints 1,2,3,4:

 perl -MAcme::Tools -le 'print join ",", union([1,2,3],[2,3,3,4,4])'              # 1,2,3,4

=cut

sub union { my %seen; grep !$seen{$_}++, map @{shift()},@_ }
=head2 minus

Input: Two arrayrefs.

Output: An array containing all elements in the first input array but not in the second.

Example:

 perl -MAcme::Tools -le 'print join " ", minus( ["five", "FIVE", 1, 2, 3.0, 4], [4, 3, "FIVE"] )'

Output is C<< five 1 2 >>.

=cut

sub minus {
  my %seen;
  my %notme=map{($_=>1)}@{$_[1]};
  grep !$notme{$_}&&!$seen{$_}++, @{$_[0]};
}

=head2 intersect

Input: Two arrayrefs

Output: An array containing all elements which exists in both input arrays.

Example:

 perl -MAcme::Tools -le 'print join" ", intersect( ["five", 1, 2, 3.0, 4], [4, 2+1, "five"] )'      # 4 3 five

Output: C<< 4 3 five >>

=cut

sub intersect {
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

sub not_intersect {
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

Beware of using C<sort> like the following because sort will see C<uniq>
as the subroutine for comparing elements! Which you most likely didnt mean.
This has nothing to do with the way uniq is implemented. It's Perl's C<sort>.

 print sort uniq('a','dup','z','dup');  # will return this four element array: a dup z dup
 print sort(uniq('a','dup','z','dup')); # better, probably what you meant
 print distinct('a','dup','z','dup'));  # same, distinct includes alphanumeric sort

=cut

sub uniq(@) { my(%seen,$undef); grep defined($_) ? !$seen{$_}++ : !$undef++, @_ }

=head1 HASHES

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

Note2: For perl versions >= 5.20 subhashes (hash slices returning keys as well as values) is built in like this:

 %scandinavia = %population{'Norway','Sweden','Denmark'};

=cut

sub subhash {
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

#Hashtrans brukes automatisk når første argument er -1 i sub hashtabell()

sub hashtrans {
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

=head2 a2h

B<Input:> array of arrays

B<Output:> array of hashes

Transforms an array of arrays (arrayrefs) to an array of hashes (hashrefs).

Example:

 my @h = a2h( ['Name', 'Age',  'Gender'],  #1st row become keys
              ['Alice', 20,    'F'],
              ['Bob',   30,    'M'],
              ['Eve',   undef, 'F'] );

Result array @h:

 (
   {Name=>'Alice', Age=>20,    Gender=>'F'},
   {Name=>'Bob',   Age=>30,    Gender=>'M'},
   {Name=>'Eve',   Age=>undef, Gender=>'F'},
 );

=head2 h2a

B<Input:> array of hashes

B<Output:> array of arrays

Opposite of L</a2h>

=cut

sub a2h {
    my @col=@{shift@_};
    map { my%h;@h{@col}=@$_;\%h} @_;
}

sub h2a {
    my %c;
    map $c{$_}++, keys%$_ for @_;
    my @c=sort{$c{$a}<=>$c{$b} or $a cmp $b}keys%c;
    (\@c,map[@$_{@c}],@_);
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

sub zipb64 {
  require MIME::Base64;
  return MIME::Base64::encode_base64(zipbin(@_));
}


=head2 zipbin

C<zipbin()> does the same as C<zipb64()> except that zipbin()
does not base64 encode the result. Returns binary data.

See L</zip> for documentation.

=cut

sub zipbin {
  require Compress::Zlib;
  my($data,$dict)=@_;
  my $x=Compress::Zlib::deflateInit(-Dictionary=>$dict||'',-Level=>Compress::Zlib::Z_BEST_COMPRESSION()) or croak();
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

sub unzipb64 {
  my($data,$dict)=@_;
  require MIME::Base64;
  unzipbin(MIME::Base64::decode_base64($data),$dict);
}

=head2 unzipbin

C<unzipbin()> does the same as L</unzip> except that C<unzipbin()>
wants a pure binary compressed string as input, not base64.

See L</unzipb64> for documentation.

=cut

sub unzipbin {
  require Compress::Zlib;
  require Carp;
  my($data,$dict)=@_;
  my $x=Compress::Zlib::inflateInit(-Dictionary=>$dict||'') or croak();
  my($output,$status)=$x->inflate($data);
  croak() if $status!=Compress::Zlib::Z_STREAM_END();
  return $output;
}

=head2 gzip

B<Input:> A string or reference to a string you want to compress. Text or binary.

B<Output:> The binary compressed representation of that input string.

C<gzip()> is really just a wrapper for C< Compress:Zlib::memGzip() > and uses the same
compression algorithm as the well known GNU program gzip found in most unix/linux/cygwin
distros. Except C<gzip()> does this in-memory. (Both using the C-library C<zlib>).

 writefile( "file.gz", gzip("some string") );

=head2 gunzip

B<Input:> A binary compressed string or a reference to such a string. I.e. something returned from
C<gzip()> earlier or read from a C<< .gz >> file.

B<Output:> The original larger non-compressed string. Text or binary.

C<gunzip()> is a wrapper for Compress::Zlib::memGunzip()

 print gunzip( gzip("some string") );   #some string

=head2 bzip2

Same as L</gzip> and L</gunzip> except with a different compression algorithm (compresses more but is slower). Wrapper for Compress::Bzip2::memBzip.

Compared to gzip/gunzip, bzip2 compression is much slower, bunzip2 decompression not so much.

See also L<Compress::Bzip2>, C<man Compress::Bzip2>, C<man bzip2>, C<man bunzip2>.

 writefile( "file.bz2", bzip2("some string") );
 print bunzip2( bzip2("some string") );   #some string

=head2 bunzip2

Decompressed something compressed by bzip2() or data from a C<.bz2> file. See L</bzip2>.

=cut

sub gzip    { my $s=shift; eval"require Compress::Zlib"  if !$INC{'Compress/Zlib.pm'};  croak "Compress::Zlib not found"  if $@; Compress::Zlib::memGzip(    ref($s)?$s:\$s ) }
sub gunzip  { my $s=shift; eval"require Compress::Zlib"  if !$INC{'Compress/Zlib.pm'};  croak "Compress::Zlib not found"  if $@; Compress::Zlib::memGunzip(  ref($s)?$s:\$s ) }
sub bzip2   { my $s=shift; eval"require Compress::Bzip2" if !$INC{'Compress/Bzip2.pm'}; croak "Compress::Bzip2 not found" if $@; Compress::Bzip2::memBzip(   ref($s)?$s:\$s ) }
sub bunzip2 { my $s=shift; eval"require Compress::Bzip2" if !$INC{'Compress/Bzip2.pm'}; croak "Compress::Bzip2 not found" if $@; Compress::Bzip2::memBunzip( ref($s)?$s:\$s ) }

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
sub ipaddr {
  my $ipnr=shift;
  #hm, NOTE: The 2 parameter on the next code line is not 2 for all OSes,
  #but seems to work in Linux and HPUX. Den correct way is to use the
  #AF_INET constant in the Socket or the IO::Socket package.
  return $IPADDR_memo{$ipnr} ||= gethostbyaddr(pack("C4",split("\\.",$ipnr)),2);
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
sub ipnum {
  my $ipaddr=shift;
  #croak "No $ipaddr" if !length($ipaddr);
  return $IPNUM_memo{$ipaddr} if exists $IPNUM_memo{$ipaddr};
  my $h=gethostbyname($ipaddr);
  #croak "No ipnum for $ipaddr" if !$h;
  return if !defined $h;
  my $ipnum = join(".",unpack("C4",$h));
  $IPNUM_memo{$ipaddr} = $ipnum=~/^(\d+\.){3}\d+$/ ? $ipnum : undef;
  return $IPNUM_memo{$ipaddr};
}

our $Ipnum_errmsg;
our $Ipnum;
sub ipnum_ok {
    my $ipnum=shift;
    $Ipnum=undef;
    eval{
      die "malformed ipnum $ipnum\n" if not $ipnum=~/^(\d+)\.(\d+)\.(\d+)\.(\d+)$/;
      die "invalid ipnum $ipnum\n"   if grep$_>255,$1,$2,$3,$4;
      $Ipnum=$1*256**3 + $2*256**2 + $3*256 + $4;
    };
    my$r=($Ipnum_errmsg=$@) ? 0 : 1;
    $r
}
our $Iprange_errmsg;
our $Iprange_start;
sub iprange_ok {
    my $iprange=shift;
    $Iprange_start=undef;
    my($r,$m);
    eval{
      die "malformed iprange $iprange\n"   if not $iprange=~m|^(\d+)\.(\d+)\.(\d+)\.(\d+)(?:/(\d+))$|;
      die "iprange part should be 0-255\n" if grep$_<0||$_>255,$1,$2,$3,$4;
      die "iprange mask should be 0-32\n"  if defined$5 and $5>32;
      ($r,$m)=($1*256**3+$2*256**2+$3*256+$4,32-$5);
    };
    return if $Iprange_errmsg=$@;
    my $x=$r>>$m<<$m;
    return if $r!=$x and $Iprange_errmsg=sprintf("need zero in last %d bits, should be %d.%d.%d.%d/%d",
						 $m, $x>>24, ($x>>16)&255, ($x>>8)&255, $x&255, 32-$m);
    $Iprange_start=$r;
    return 1;
}
sub in_iprange {
  my($ipnum,$iprange)=@_;
  croak $Ipnum_errmsg   if !ipnum_ok($ipnum);
  croak $Iprange_errmsg if !iprange_ok($iprange=~m|/\d+$| ? $iprange : "$iprange/32");
  "$iprange/32"=~m|/(\d+)| or die;
  $Ipnum>=$Iprange_start &&
  $Ipnum<=$Iprange_start + 2**(32-$1)-1;
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

sub webparams {
  my $query=shift();
  $query=$ENV{QUERY_STRING} if !defined $query;
  if(!defined $query  and  $ENV{REQUEST_METHOD} eq "POST"){
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

 $search="Østdal, Åge";
 my $url="http://machine.somewhere.com/search?q=" . urlenc($search);
 print $url;

Prints C<< http://machine.somewhere.com/search?q=%D8stdal%2C%20%C5ge >>

=cut

sub urlenc {
  my $str=shift;
  $str=~s/([^\w\-\.\/\,\[\]])/sprintf("%%%02x",ord($1))/eg; #more chars is probably legal...
  return $str;
}

=head2 urldec

Opposite of L</urlenc>.

Example, this returns 'C< ø>'. That is space and C<< ø >>.

 urldec('+%C3')

=cut

sub urldec {
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
 my $url = "http://en.wikipedia.org/wiki/List_of_countries_by_population";
 for( ht2t( get($url), "Countries" ) ) {
   my($rank, $country, $pop) = @$_;
   $pop =~ s/,//g;
   printf "%3d | %-32s | %9d\n", @$_ if $pop>0;
 }

Output:

  1 | China                            | 1367740000
  2 | India                            | 1262090000
  3 | United States                    | 319043000
  4 | Indonesia                        | 252164800
  5 | Brazil                           | 203404000

...and so on.

=cut

sub ht2t {
  my($f,$s,$r)=@_; 1>@_||@_>3 and croak; $s='' if @_==1;
  $f=~s,.*?($s).*?(<table.*?)</table.*,$2,si;
  my $e=0;$e++ while index($f,$s=chr($e))>=$[;
  $f=~s/<t(d|r|h).*?>/\l$1$s/gsi;
  $f=~s/\s*<.*?>\s*/ /gsi;
  my @t=split("r$s",$f);shift @t;
  $r||=sub{s/&(#160|nbsp);/ /g;s/&amp;/&/g;s/^\s*(.*?)\s*$/$1/s;
	   s/(\d) (\d)/$1$2/g if /^[\d \.\,]+$/};
  for(@t){my @r=split/[dh]$s/;shift@r;$_=[map{&$r;$_}@r]}
  @t;
}

=head1 FILES, DIRECTORIES

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

Automatic compression:

 writefile('file.txt.gz','my text is compressed by /bin/gzip when written to the file');

Extentions C<.gz>, C<.bz2>, C<.xz> and C<.zst> are recognized for compression. See also C<readfile()> and C<openstr()>.

B<Output:> Nothing (for the time being). C<die()>s (C<croak($!)> really) if something goes wrong.

=cut

sub writefile {
    my($file,$text)=@_;
    return map writefile(@$_), @$file                     if ref($file) eq 'ARRAY';
    return map writefile($_,$$file{$_}), sort keys %$file if ref($file) eq 'HASH';
    open my $FH, openstr(">$file") or croak($!);
    binmode($FH);
    if(  !ref$text){ print $FH $text }
    elsif(ref($text) eq 'SCALAR' ){ print $FH $$text }
    elsif(ref($text) eq 'ARRAY'  ){ print $FH "$_\n" for @$text }
    else                          { croak }
    close($FH);
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

Automatic decompression:

 my $txt = readfile('file.txt.gz');  #uses /bin/gunzip to decompress content

Extentions C<.gz>, C<.bz2> and C<.xz> are recognized for decompression. See also C<writefile()> and C<openstr()>.

=cut

#http://blogs.perl.org/users/leon_timmermans/2013/05/why-you-dont-need-fileslurp.html
#todo: readfile with grep-filter code ref in a third arg (avoid reading all into mem)

sub readfile {
  my($file,$ref,$filter)=@_;
  return readfile($file,undef,$ref) if ref($ref) eq 'CODE';
  return map{[$_=>"".readfile($_)]}@$file           if ref($file) eq 'ARRAY';
  return map{($_=>"".readfile($_))}sort keys %$file if ref($file) eq 'HASH';

  if(@_==1 or @_==3 and !defined$ref){
    if(wantarray){ my @data; readfile($file,\@data,$filter); return @data }
    else         { my $data; readfile($file,\$data,$filter); return $data }
  }
  else {
    open my $FH, openstr($file) or croak("ERROR: readfile $! $?");
    if   ( ref($ref) eq 'SCALAR') { $$ref=join"",<$FH> }
    elsif( ref($ref) eq 'ARRAY' ) { while(my $l=<$FH>){ chomp($l); push @$ref, $l if!defined$filter or &$filter($l)} }
    else { croak "ERROR: Second arg to readfile should be a ref to a scalar og array" }
    close($FH);
    return;#?
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

sub readdirectory {
  my $dir=shift;
  opendir(my $D,$dir);
  my @filer=map "$dir/$_", grep {!/^\.\.?$/} readdir($D);
  closedir($D);
  return @filer;
}

=head2 basename

The basename and dirname functions behaves like the *nix shell commands with the same names.

B<Input:> One or two arguments: Filename and an optional suffix

B<Output:> Returns the filename with any directory and (if given) the suffix removed.

 basename('/usr/bin/perl')                   # returns 'perl'
 basename('/usr/local/bin/report.pl','.pl')  # returns 'report' since .pl at the end is removed
 basename('report2.pl','.pl')                # returns 'report2'
 basename('report2.pl','.\w+')               # returns 'report2.pl', probably not what you meant
 basename('report2.pl',qr/.\w+/)             # returns 'report2', use qr for regex

=head2 dirname

B<Input:> A filename including path

B<Output:> Removes the filename path and returns just the directory path up until but not including
the last /. Return just a one char C<< . >> (period string) if there is no directory in the input.

 dirname('/usr/bin/perl')                    # returns '/usr/bin'
 dirname('perl')                             # returns '.'

=head2 username

Returns the current linux/unix username, for example the string root

 print username();                        #just (getpwuid($<))[0] but more readable perhaps

=cut

sub basename { my($f,$s)=(@_,'');$s=quotemeta($s)if!ref($s);$f=~m,^(.*/)?([^/]*?)($s)?$,;$2 }
sub dirname  { $_[0]=~m,^(.*)/,;defined($1) && length($1) ? $1 : '.' }
sub username { (getpwuid($<))[0] }

=head2 wipe

Deletes a file by "wiping" it on the disk. Overwrites the file before deleting. (May not work properly on SSDs)

B<Input:>
* Arg 1: A filename
* Optional arg 2: number of times to overwrite file. Default is 3 if omitted, 0 or undef
* Optional arg 3: keep (true/false), wipe() but no delete of file

B<Output:> Same as the C<unlink()> (remove file): 1 for success, 0 or false for failure.

See also: L<https://www.google.com/search?q=wipe+file>, L<http://www.dban.org/>

=cut

sub wipe {
  my($file,$times,$keep,$progress)=@_;
  $times||=3;
  croak "ERROR: File $file nonexisting\n" if not -f $file or not -e $file;
  my $size=-s$file;
  open my $WIFH, '+<', $file or croak "ERROR: Unable to open $file: $!\n";
  binmode($WIFH);
  my $bs=10240;
  my $p;if($progress and require'Term::ProgressBar'){$p=Term::ProgressBar->new({count=>$times*$size/$bs,name=>'Wipe...',remove=>1,ETA=>'linear',max_update_rate=>0.5})}
  my $i=0;
  for(1..$times){
    my $block=chr(int(rand(256))) x $bs;#hm
    for(0..($size/$bs)){
      seek($WIFH,$_*$bs,0);
      print $WIFH $block;
      $p->update(++$i) if $p;
    }
  }
  close($WIFH);
  $keep or unlink($file);
}

=head2 chall

Does chmod + utime + chown on one or more files.

Returns the number of files of which those operations was successful.

Mode, uid, gid, atime and mtime are set from the array ref in the first argument.

The first argument references an array which is exactly like an array returned from perls internal C<stat($filename)> -function.

Example:

 my @stat=stat($filenameA);
 chall( \@stat,       $filenameB, $filenameC, ... );  # by stat-array
 chall( $filenameA,   $filenameB, $filenameC, ... );  # by file name

Copies the chmod, owner, group, access time and modify time from file A to file B and C.

See C<perldoc -f stat>, C<perldoc -f chmod>, C<perldoc -f chown>, C<perldoc -f utime>

=cut


sub chall {
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

C<makedir()> memoizes directories it has checked for existence before (trading memory and for speed).
Thus directories removed during running the script is not discovered by makedir.

See also C<< perldoc -f mkdir >>, C<< man umask >>

=cut

our %MAKEDIR;

sub makedir {
  my($d,$p,$dd)=@_;
  $p=0777^umask() if !defined$p;
  (
  $MAKEDIR{$d} or -d$d or mkdir($d,$p) #or croak("mkdir $d, $p")
  or ($dd)=($d=~m,^(.+)/+([^/]+)$,) and makedir($dd,$p) and mkdir($d,$p) #or die;
  ) and ++$MAKEDIR{$d};
}

=head2 md5sum

B<Input:> a filename (or a scalar ref to a string, see below)

B<Output:> a string of 32 hexadecimal chars from 0-9 or a-f.

Example, the md5sum gnu/linux command without options could be implementet like this:

 use Acme::Tools;
 print eval{ md5sum($_)."  $_\n" } || $@ for @ARGV;

This sub requires L<Digest::MD5>, which is a core perl-module since
version 5.?.?  It does not slurp the files or spawn new processes.

If the input argument is a scalar ref then the MD5 of the string referenced is returned in hex.

=cut

sub md5sum {
  require Digest::MD5;
  my $fn=shift;
  return Digest::MD5::md5_hex($$fn) if ref($fn) eq 'SCALAR';
  croak "md5sum: $fn is a directory (no md5sum)" if -d $fn;
  open my $FH, '<', $fn or croak "Could not open file $fn for md5sum() $!";
  binmode($FH);
  my $r = eval { Digest::MD5->new->addfile($FH)->hexdigest };
  croak "md5sum on $fn failed ($@)\n" if $@;
  $r;
}

=head2 which

Returns the first executable program in $ENV{PATH} paths (split by : colon) with the given name.

 echo $PATH
 perl -MAcme::Tools -le 'print which("gzip")'      # maybe prints /bin/gzip

=head2 read_conf

B<First argument:> A file name or a reference to a string with settings in the format described below.

B<Second argument, optional:> A reference to a hash. This hash will have the settings from the file (or stringref).
The hash do not have to be empty beforehand.

Returns a hash with the settings as in this examples:

 my %conf = read_conf('/etc/your/thing.conf');
 print $conf{sectionA}{knobble};  #prints ABC if the file is as shown below
 print $conf{sectionA}{gobble};   #prints ZZZ, the last gobble
 print $conf{switch};             #prints OK here as well, unsectioned value
 print $conf{part2}{password};    #prints oh:no= x

File use for the above example:

 switch:    OK       #before first section, the '' (empty) section
 [sectionA]
 knobble:   ABC
 gobble:    XYZ      #this gobble is overwritten by the gobble on the next line
 gobble:    ZZZ
 [part2]
 password:  oh:no= x  #should be better
 text:      { values starting with { continues
              until reaching a line with }

Everything from # and behind is regarded comments and ignored. Comments can be on any line.
To keep a # char, put a \ in front of it.

A C< : > or C< = > separates keys and values.  Spaces at the beginning or end of lines are
ignored (after removal of #comments), as are any spaces before and after : and = separators.

Empty lines or lines with no C< : > or C< = > is also ignored. Keys and values can contain
internal spaces and tabs, but not at the beginning or end.

Multi-line values must start and end with { and }. Using { and } keep spaces at the start
or end in both one-line and multi-line values.

Sections are marked with C<< [sectionname] >>.  Section names, keys and values is case
sensitive. C<Key:values> above the first section or below and empty C<< [] >> is placed
both in the empty section in the returned hash and as top level key/values.

C<read_conf> can be a simpler alternative to the core module L<Config::Std> which has
its own hassles.

 $Acme::Tools::Read_conf_empty_section=1;        #default 0 (was 1 in version 0.16)
 my %conf = read_conf('/etc/your/thing.conf');
 print $conf{''}{switch};                        #prints OK with the file above
 print $conf{switch};                            #prints OK here as well

=head2 read_conf_yaml (TODO)

=cut

our $Read_conf_empty_section=0;
sub read_conf {
  my($fn,$hr)=(@_,{});
  my $conf=ref($fn)?$$fn:readfile($fn);
  $conf=~s,\s*(?<!\\)#.*,,g;
  my($section,@l)=('',split"\n",$conf);
  while(@l) {
    my $l=shift@l;
    if( $l=~/^\s*\[\s*(.*?)\s*\]/ ) {
      $section=$1;
      $$hr{$1}||={};
    }
    elsif( $l=~/^\s*([^\:\=]+?)\s*[:=]\s*(.*?)\s*$/ ) {
      my $ml=sub{my$v=shift;$v.="\n".shift@l while $v=~/^\{[^\}]*$/&&@l;$v=~s/^\{(.*)\}\s*$/$1/s;$v=~s,\\#,#,g;$v};
      my $v=&$ml($2);
      $$hr{$section}{$1}=$v if length($section) or $Read_conf_empty_section;
      $$hr{$1}=$v if !length($section);
    }
  }
  %$hr;
}
#  my $incfn=sub{return $1 if $_[0]=~m,^(/.+),;my$f=$fn;$f=~s,[^/]+$,$_[0],;$f};
#    s,<INCLUDE ([^>]+)>,"".readfile(&$incfn($1)),eg; #todo


=head2 openstr

                                            # returned from openstr:
  open my $FH, openstr("fil.txt")  or die;  # fil.txt
  open my $FH, openstr("fil.gz")   or die;  # zcat fil.gz |
  open my $FH, openstr("fil.bz2")  or die;  # bzcat fil.bz2 |
  open my $FH, openstr("fil.xz")   or die;  # xzcat fil.xz |
  open my $FH, openstr(">fil.txt") or die;  # > fil.txt
  open my $FH, openstr(">fil.gz")  or die;  # | gzip > fil.gz
  open my $FH, openstr(">fil.bz2") or die;  # | bzip2 > fil.bz2
  open my $FH, openstr(">fil.xz")  or die;  # | xz    > fil.bz2

Environment variable PATH is used. So in the examples above, /bin/gzip
is returned instead of gzip if /bin is the first directory in
$ENV{PATH} containing an executable file gzip. Dirs /usr/bin, /bin and
/usr/local/bin is added to PATH in openstr(). They are checked even if
PATH is empty.

See also C<writefile()> and C<readfile()> for automatic compression and decompression using C<openstr>.

=cut

our @Openstrpath=(grep$_,split(":",$ENV{PATH}),
		  qw( /usr/bin  /bin  /usr/local/bin
                      /usr/sbin /sbin /usr/local/sbin ));
our $Magic_openstr=1;
sub openstr_prog { @Openstrpath or return $_[0];(grep -x$_, map "$_/$_[0]", @Openstrpath)[0] or croak"$_[0] not found" }
sub openstr {
  my($fn,$ext)=(shift()=~/^(.*?(?:\.(t?gz|bz2|xz|zstd?))?)$/i);
  !$ext           ? $fn :
  !$Magic_openstr ? $fn :
  $fn=~/^\s*>/    ? "| ".(openstr_prog({qw/gz gzip bz2 bzip2 xz xz    tgz gzip zst zstd    zstd zstd/   }->{lc($ext)})).$fn
                  :       openstr_prog({qw/gz zcat bz2 bzcat xz xzcat tgz zcat zst zstdcat zstd zstdcat/}->{lc($ext)})." $fn |";
}

=head2 printed

Redirects C<print> and C<printf> from STDOUT to a string which is returned.

 my $p = printed { print "hello!" };     # now $p eq 'hello!'
 my $p = printed { some_sub() };         # now $p contains whatever was printed by some_sub() and the subs call from it

=cut

sub printed (&) { my $s; open(local *STDOUT, '>', \$s) or croak "ERR: $! $?"; shift->(); $s } #todo catch stderr also?

#todo: sub stdin{}
#todo: sub stdout{}
#todo: sub stderr{}
#todo: sub stdouterr{}

=head1 TIME FUNCTIONS

=head2 tms

Timestring, works somewhat like the Gnu/Linux C<date> command and Oracle's C<to_char()>

Converts timestamps to more readable forms of time strings.

Converts seconds since I<epoch> and time strings on the form C<YYYYMMDD-HH24:MI:SS> to other forms.

B<Input:> One, two or three arguments.

B<First argument:> A format string.

B<Second argument: (optional)> An epock C<time()> number or a time
string of the form YYYYMMDD-HH24:MI:SS or YYYYMMDDTHH:MI:SS or
YYYY-MM-DDTHH:MI:SS (in which T is litteral and HH is the 24-hour
version of hours) or YYYYMMDD. Uses the current C<time()> if the
second argument is missing.

TODO: Formats with % as in C<man date> (C<%Y%m%d> and so on)

B<Third argument: (optional> True or false. If true and first argument
is eight digits: Its interpreted as a date like YYYYMMDD time string,
not an epoch time.  If true and first argument is six digits its
interpreted as a date like DDMMYY (not YYMMDD!).

B<Output:> a date or clock string on the wanted form.

B<Examples:>

Prints C<< 3. july 1997 >> if thats the dato today:

  perl -MAcme::Tools -le 'print timestr("D. month YYYY")'

  print tms("HH24:MI");              # prints 23:55 if thats the time now
  tms("HH24:MI",time());             # ...same,since time() is the default
  tms("HH:MI",time()-5*60);          # 23:50 if that was the time 5 minutes ago
  tms("HH:MI",time()-5*60*60);       # 18:55 if thats the time 5 hours ago
  tms("Day Month Dth YYYY HH:MI");   # Saturday July 1st 2004 23:55    (big S, big J)
  tms("Day D. Month YYYY HH:MI");    # Saturday 8. July 2004 23:55     (big S, big J)
  tms("DAY D. MONTH YYYY HH:MI");    # SATURDAY 8. JULY 2004 23:55     (upper)
  tms("dy D. month YYYY HH:MI");     # sat 8. july 2004 23:55          (small s, small j)
  tms("Dy DD. MON YYYY HH12:MI am"); # Sat 08. JUL 2004 11:55 pm       (HH12, am becomes pm if after 12)
  tms("DD-MON-YYYY");                # 03-MAY-2004                     (mon, english)

The following list of codes in the first argument will be replaced:

  YYYY    Year, four digits
  YY      Year, two digits, i.e. 04 instead of 2004
  yyyy    Year, four digits, but nothing if its the current year
  YYYY|HH:MI  Year if its another year than the current, a time in hours and minutes elsewise
  MM      Month, two digits. I.e. 08 for August
  DD      Day of month, two digits. I.e. 01 (not 1) for the first day in a month
  D       Day of month, one digit. I.e. 1 (not 01)
  HH      Hour. From 00 to 23.
  HH24    Same as HH.
  HH12    12 becomes 12 (never 00), 13 becomes 01, 14 02 and so on.
          Note: 00 after midnight becomes 12 (am). Tip: always include the code
          am in a format string that uses HH12.
  MI      Minutt. Fra 00 til 59.
  SS      Sekund. Fra 00 til 59.
  am      Becomes am or pm
  pm      Same
  AM      Becomes AM or PM (upper case)
  PM      Same

  Month   The full name of the month in English from January to December
  MONTH   Same in upper case (JANUARY)
  month   Same in lower case (january)
  Mont    Jan Feb Mars Apr May June July Aug Sep Oct Nov Dec
  Mont.   Jan. Feb. Mars Apr. May June July Aug. Sep. Oct. Nov. Dec. (always four chars)
  Mon     Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec            (always three chars)

  Day     The full name of the weekday. Sunday to Saturday
  Dy      Three letters: Sun Mon Tue Wed Thu Fri Sat
  DAY     Upper case
  DY      Upper case
  Dth     1st 2nd 3rd 4th 5th ... 11th 12th ... 20th 21st 22nd 23rd 24th ... 30th 31st

  WW      Week number of the year 01-53 according to the ISO8601-definition (which most countries uses)
  WWUS    Week number of the year 01-53 according to the most used definition in the USA.
          Other definitions also exists.

  epoch   Converts a time string from YYYYMMDD-HH24:MI:SS, YYYYMMDD-HH24:MI:SS, YYYYMMDDTHH:MI:SS,
          YYYY-MM-DDTHH:MI:SS or YYYYMMDD to the number of seconds since January 1st 1970.
          Commonly known as the Unix epoch.

  JDN     Julian day number. Integer. The number of days since the day starting at noon on January 1 4713 BC
  JD      Same as JDN but a float accounting for the time of day

B<Third argument:> (optional) Is_date. False|true, default false. If true, the second argument is
interpreted as a date of the form YYYYMMDD, not as a number of seconds since epoch (January 1st 1970).

=cut

#Se også L</tidstrk> og L</tidstr>

our $Tms_pattern;
our %Tms_str=
	  ('MÅNED' => [4, 'JANUAR','FEBRUAR','MARS','APRIL','MAI','JUNI','JULI',
		          'AUGUST','SEPTEMBER','OKTOBER','NOVEMBER','DESEMBER' ],
	   'Måned' => [4, 'Januar','Februar','Mars','April','Mai','Juni','Juli',
		          'August','September','Oktober','November','Desember'],
	   'måned' => [4, 'januar','februar','mars','april','mai','juni','juli',
		          'august','september','oktober','november','desember'],
	   'MÅNE.' => [4, 'JAN.','FEB.','MARS','APR.','MAI','JUNI','JULI','AUG.','SEP.','OKT.','NOV.','DES.'],
	   'Måne.' => [4, 'Jan.','Feb.','Mars','Apr.','Mai','Juni','Juli','Aug.','Sep.','Okt.','Nov.','Des.'],
	   'måne.' => [4, 'jan.','feb.','mars','apr.','mai','juni','juli','aug.','sep.','okt.','nov.','des.'],
	   'MÅNE'  => [4, 'JAN','FEB','MARS','APR','MAI','JUNI','JULI','AUG','SEP','OKT','NOV','DES'],
	   'Måne'  => [4, 'Jan','Feb','Mars','Apr','Mai','Juni','Juli','Aug','Sep','Okt','Nov','Des'],
	   'måne'  => [4, 'jan','feb','mars','apr','mai','juni','juli','aug','sep','okt','nov','des'],
	   'MÅN'   => [4, 'JAN','FEB','MAR','APR','MAI','JUN','JUL','AUG','SEP','OKT','NOV','DES'],
	   'Mån'   => [4, 'Jan','Feb','Mar','Apr','Mai','Jun','Jul','Aug','Sep','Okt','Nov','Des'],
	   'mån'   => [4, 'jan','feb','mar','apr','mai','jun','jul','aug','sep','okt','nov','des'],
	   'MONTH' => [4, 'JANUARY','FEBRUARY','MARCH','APRIL','MAY','JUNE','JULY',
		          'AUGUST','SEPTEMBER','OCTOBER','NOVEMBER','DECEMBER'],
	   'Month' => [4, 'January','February','March','April','May','June','July',
		          'August','September','October','November','December'],
	   'month' => [4, 'january','february','march','april','may','june','july',
		          'august','september','october','november','december'],
	   'MONT.' => [4, 'JAN.','FEB.','MAR.','APR.','MAY','JUNE','JULY','AUG.','SEP.','OCT.','NOV.','DEC.'],
	   'Mont.' => [4, 'Jan.','Feb.','Mar.','Apr.','May','June','July','Aug.','Sep.','Oct.','Nov.','Dec.'],
	   'mont.' => [4, 'jan.','feb.','mar.','apr.','may','june','july','aug.','sep.','oct.','nov.','dec.'],
	   'MONT'  => [4, 'JAN','FEB','MAR','APR','MAY','JUNE','JULY','AUG','SEP','OCT','NOV','DEC'],
	   'Mont'  => [4, 'Jan','Feb','Mar','Apr','May','June','July','Aug','Sep','Oct','Nov','Dec'],
	   'mont'  => [4, 'jan','feb','mar','apr','may','june','july','aug','sep','oct','nov','dec'],
	   'MON'   => [4, 'JAN','FEB','MAR','APR','MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'],
	   'Mon'   => [4, 'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'],
	   'mon'   => [4, 'jan','feb','mar','apr','may','jun','jul','aug','sep','oct','nov','dec'],
	   'DAY'   => [6, 'SUNDAY','MONDAY','TUESDAY','WEDNESDAY','THURSDAY','FRIDAY','SATURDAY'],
	   'Day'   => [6, 'Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'],
	   'day'   => [6, 'sunday','monday','tuesday','wednesday','thursday','friday','saturday'],
	   'DY'    => [6, 'SUN','MON','TUE','WED','THU','FRI','SAT'],
	   'Dy'    => [6, 'Sun','Mon','Tue','Wed','Thu','Fri','Sat'],
	   'dy'    => [6, 'sun','mon','tue','wed','thu','fri','sat'],
	   'DAG'   => [6, 'SØNDAG','MANDAG','TIRSDAG','ONSDAG','TORSDAG','FREDAG','LØRDAG'],
	   'Dag'   => [6, 'Søndag','Mandag','Tirsdag','Onsdag','Torsdag','Fredag','Lørdag'],
	   'dag'   => [6, 'søndag','mandag','tirsdag','onsdag','torsdag','fredag','lørdag'],
	   'DG'    => [6, 'Søn','MAN','TIR','ONS','TOR','FRE','LØR'],
	   'Dg'    => [6, 'SØn','Man','Tir','Ons','Tor','Fre','Lør'],
	   'dg'    => [6, 'søn','man','tir','ons','tor','fre','lør'],
	   );
my $_tms_inited=0;
sub tms_init {
  return if $_tms_inited++;
  for(qw(MAANED Maaned maaned MAAN Maan maan),'MAANE.','Maane.','maane.'){
    $Tms_str{$_}=$Tms_str{replace($_,"aa","å","AA","Å")};
  }
  $Tms_pattern=join("|",map{quotemeta($_)}
		        sort{length($b)<=>length($a)}
			keys %Tms_str);
  #without sort "måned" could be "mared" because "mån"=>"mar"
}

sub totime {

}

=head2 s2t

Convert strings to "time pieces". Example:

 my($dd,$mm,$yyyy,$str) = s2t("18/february/2019:13:53","DD","MM","YYYY","YYYYMMDD-HH24:MI:SS")
 print "dd: $dd   mm: $mm   yyyy: $yyyy   str: $str\n";  # dd: 18   mm: 02   yyyy: 2019   str: 20190218-13:53:00

=cut

sub s2t {
  require Date::Parse;
  my $s=shift;
  if($s=~/\b(?:mai|okt|des|juni|juli|februar)/i){ #fix norwegian/danish (for now)
     $s=~s/\bMai\b/May/i;         $s=~s/\bmai\b/may/i;         $s=~s/\bMAI\b/MAY/i;
     $s=~s/\bOkt\b/Oct/i;         $s=~s/\bokt\b/oct/i;         $s=~s/\bOKT\b/OCT/i;
     $s=~s/\bDes/Dec/;            $s=~s/\bdes/dec/;            $s=~s/\bDES/DEC/;
     $s=~s/\bFebruar\b/February/; $s=~s/\bfebruar\b/february/; $s=~s/\bFEBRUAR\b/FEBRUARY/;
     $s=~s/\bjuli\b/July/i;
     $s=~s/\bjuni\b/June/i;
  }
  elsif($s           =~ /^[19]\d{9}$/){ $s=localtime($s)      } #hm, make faster
  elsif($s           =~ /^[19]\d{12}$/
    and int($s/1000) =~ /^[19]\d{9}$/){ $s=localtime($s/1000) } #hm
  elsif($s=~/^((?:17|18|19|20|21)\d\d)(0[1-9]|1[012])(0[1-9]|[12]\d|3[01])$/){#hm
      $s="$1-$2-$3T00:00:00";
  }
  return Date::Parse::str2time($s)                  if !@_;
  return tms(Date::Parse::str2time($s),shift(@_))   if 0+@_ == 1;
  return map tms(Date::Parse::str2time($s),$_), @_;
}

sub date_ok {
  my($y,$m,$d)=@_;
  return date_ok($1,$2,$3) if @_==1 and $_[0]=~/^(\d{4})(\d\d)(\d\d)$/;
  return 0 if $y!~/^\d\d\d\d$/;
  return 0 if $m<1||$m>12||$d<1||$d>(31,$y%4||$y%100==0&&$y%400?28:29,31,30,31,30,31,31,30,31,30,31)[$m-1];
  return 1;
}

# YYYY-MM-DD date validation from https://www.perlmonks.org/?node_id=371015 (ikke testet)
# /(?=\d{4}-\d\d-\d\d)             # Date format
#  (?=.{8}(?:0[1-9]|[12]\d|3[01])) # Day 01-31
#  (?=.{5}(?:0[1-9]|1[0-2]))       # Month 01-12
#  (?!.{5}(?:0[2469]|11)-31)       # Not 31 days in those months
#  (?!.{5}02-30)                   # Never 30 days in Feb
#  (?!...[13579]-02-29)            # Not a leap year
#  (?!..[13579][048]-02-29)        # -"-
#  (?!..[02468][26]-02-29)         # -"-
#  (?!.[13579]00-02-29)            # -"-
#  (?![13579][048]00-02-29)        # -"-
#  (?![02468][26]00-02-29)         # -"-
# /x

sub weeknum {
  return weeknum(tms('YYYYMMDD')) if @_<1;
  return weeknum($1,$2,$3) if @_==1 and $_[0]=~/^(\d{4})(\d\d)(\d\d)$/;
  my($year,$month,$day)= @_;
  eval{
    if(@_<2){
      if($year=~/^\d{8}$/) { ($year,$month,$day)=unpack("A4A2A2",$year) }
      elsif($year>99999999){ ($year,$month,$day)=(localtime($year))[5,4,3]; $year+=1900; $month++ }
      else {die}
    }
    elsif(@_!=3){croak}
    croak if !date_ok(sprintf("%04d%02d%02d",$year,$month,$day));
  };
  croak "ERROR: Wrong args Acme::Tools::weeknum(".join(",",@_).")" if $@;
  use integer;#heltallsdivisjon
  my $y=$year+4800-(14-$month)/12;
  my $j=$day+(153*($month+(14-$month)/12*12-3)+2)/5+365*$y+$y/4-$y/100+$y/400-32045;
  my $d=($j+31741-$j%7)%146097%36524%1461;
  return (($d-$d/1460)%365+$d/1460)/7+1;
}

#perl -MAcme::Tools -le 'print "$_ ".tms($_."0501","day",1) for 2015..2026'

sub _yyyymmddhh24miss_time{
    my $s=shift;
    $s=~s/\D+//g;
    $s=~s/^((?:19|20)\d{6})$/${1}000000/; #burde vært unødv, kun 19yy og 20yy
    $s=~/^(\d{4})(\d\d)(\d\d)(\d\d)(\d\d)(\d\d)?/ or croak("Ugyldig tidspunkt $s til yyyymmddhh24miss_time()");
    my($year,$mon,$mday,$hours,$min,$sec)=($1,$2,$3,$4,$5,$6);
    croak("Time::Local cannot handle years before 1000 AD") if $year<1000;
    my $time;
    eval{
      require Time::Local;
      $time=Time::Local::timelocal(0+$sec,0+$min,0+$hours,$mday,$mon-1,$year);
    };
    $@ and croak("<$s> | <$@> | year=$year | mon=$mon | mday=$mday");
    $time;
}

sub tms {
  if(@_>1 and not defined $_[1]){
    return undef; #time=undef => undef
  }
  elsif(@_==0){
    my @lt=localtime();
    return sprintf("%04d%02d%02d-%02d:%02d:%02d",1900+$lt[5],1+$lt[4],@lt[3,2,1,0]);
  }
  elsif(@_==1){
    my $isnum=$_[0]=~$Re_isnum;
    my @lt=$isnum?localtime($_[0]):localtime();
    $isnum              and return sprintf('%04d%02d%02d-%02d:%02d:%02d',1900+$lt[5],1+$lt[4],@lt[3,2,1,0]);
    $_[0] eq 'YYYYMMDD' and return sprintf('%04d%02d%02d',               1900+$lt[5],1+$lt[4],$lt[3]);
    $_[0] eq 'YYYY'     and return 1900+$lt[5];

  }
  my($format,$time,$is_date)=@_;
  $time=time_fp() if !defined$time;
  ($time,$format)=($format,$time) if @_>=2 and $format=~/^[\d+\:\-\.]+$/; #swap /hm/
  my @lt;
  #todo? $is_date=0 if $time=~s/^\@(\-?\d)/$1/; #@n where n is sec since epoch makes it clear that its not a formatted, as in `date`
  #todo? date --date='TZ="America/Los_Angeles" 09:00 next Fri' #`info date`
  #      Fri Nov 13 18:00:00 CET 2015
  #date --date="next Friday"  #--date or -d
  #date --date="last friday"
  #date --date="2 days ago"
  #date --date="yesterday" #or tomorrow
  #date --date="-1 day"  #date --date='10 week'

  if( $is_date ){
    @lt=localtime($time);
    my $yy2c=sub{10+$_[0]>$lt[5]%100?"20":"19"}; #hm 10+
    $time=totime(&$yy2c($1)."$1$2$3")."000000" if $time=~/^(\d\d)(\d\d)(\d\d)$/;
    $time=totime("$1$2${3}000000")             if $time=~/^((?:18|19|20)\d\d)(\d\d)(\d\d)$/; #hm 18-20?
  }
  else {
    $time = _yyyymmddhh24miss_time("$1$2$3$4$5$6") #yyyymmddhh24miss_time ???
      if $time=~/^((?:1\d|2\d)\d\d)     -?        #yyyy
                  (0[1-9]|1[012])       -?        #mm
                  (0[1-9]|[12]\d|3[01]) (?:\-|T)? #dd
                  ([01]\d|2[0-3])       \:?       #hh24
                  ([0-5]\d)             \:?       #mi
                  ([0-5]\d)             $/x;      #ss
    return $time if $format eq 'epoch' or $format eq 'E';
    @lt=localtime($time);
  }
  tms_init() if !$_tms_inited;
  return sprintf("%04d%02d%02d-%02d:%02d:%02d",1900+$lt[5],1+$lt[4],@lt[3,2,1,0]) if !$format;
  my %p=('%'=>'%',
	 a=>'Dy',
	 A=>'Day',
	 b=>'Mon',
	 b=>'Month',
	 c=>'Dy Mon D HH:MI:SS YYYY',
	 C=>'CC',
	 d=>'DD',
	 D=>'MM/DD/YY',
	 e=>'D',
	 F=>'YYYY-MM-DD',
        #G=>'',
	 h=>'Month', H=>'HH24', I=>'HH12',
	 j=>'DoY', #day of year
	 k=>'H24', _H=>'H24',
	 l=>'H12', _I=>'H12',
	 m=>'MM', M=>'MI',
	 n=>"\n",
	#N=>'NS', #sprintf%09d,1e9*(time_fp()-time()) #000000000..999999999
	 p=>'AM', #AM|PM upper (yes, opposite: date +%H%M%S%P%p)
	 P=>'am', #am|pm lower
	 S=>'SS',
	 t=>"\t",
	 T=>'HH24:MI:SS',
	 u=>'DoW',  #day of week 1..7, 1=mon 7=sun
	 w=>'DoW0', #day of week 0..6, 1=mon 0=sun
	#U=>'WoYs', #week num of year 00..53, sunday as first day of week
	#V=>'UKE',  #ISO week num of year 01..53, monday as first day of week
	#W=>'WoYm', #week num of year 00..53, monday as first day of week, not ISO!
	#x=>$ENV{locale's date representation}, #e.g. MM/DD/YY
	#X=>$ENV{locale's time representation}, #e.g. HH/MI/SS
	 y=>'YY',
	 Y=>'YYYY',
	#z=>'TZHHMI', #time zone hour minute e.g. -0430
	#':z'=>'TZHH:MI',
	#'::z'=>'TZHH:MI:SS',
	#':::z'=>'TZ', #number of :'s necessary precision, e.g. -02 or +03:30
	#Z=>'TZN', #e.g. CET, EDT, ...
      );
  my $pkeys=join"|",keys%p;
  $format=~s,\%($pkeys),$p{$1},g;
  $format=~s/($Tms_pattern)/$Tms_str{$1}[1+$lt[$Tms_str{$1}[0]]]/g;
  $format=~s/YYYY              / 1900+$lt[5]                    /gxe;
  $format=~s/(\s?)yyyy         / $lt[5]==(localtime)[5]?"":$1.(1900+$lt[5])/gxe;
  $format=~s/YY                / sprintf("%02d",$lt[5]%100)     /gxei;
  $format=~s|CC                | sprintf("%02d",(1900+$lt[5])/100) |gxei;
  $format=~s/MM                / sprintf("%02d",$lt[4]+1)       /gxe;
  $format=~s/mm                / sprintf("%d",$lt[4]+1)         /gxe;
  $format=~s,M/                ,               ($lt[4]+1).'/'   ,gxe;
  $format=~s,/M                ,           '/'.($lt[4]+1)       ,gxe;
  $format=~s/DD                / sprintf("%02d",$lt[3])         /gxe;
  $format=~s/d0w|dow0          / $lt[6]                         /gxei;
  $format=~s/dow               / $lt[6]?$lt[6]:7                /gxei;
  $format=~s/d0y|doy0          / $lt[7]                         /gxei; #0-364 (365 leap)
  $format=~s/doy               / $lt[7]+1                       /gxei; #1-365 (366 leap)
  $format=~s/D(?![AaGgYyEeNn]) / $lt[3]                         /gxe;  #EN pga desember og wednesday
  $format=~s/dd                / sprintf("%d",$lt[3])           /gxe;
  $format=~s/hh12|HH12         / sprintf("%02d",$lt[2]<13?$lt[2]||12:$lt[2]-12)/gxe;
  $format=~s/HH24|HH24|HH|hh   / sprintf("%02d",$lt[2])         /gxe;
  $format=~s/MI                / sprintf("%02d",$lt[1])         /gxei;
  $format=~s{SS\.([1-9])      }{ sprintf("%0*.$1f",3+$1,$lt[0]+(repl($time,qr/^[^\.]+/)||0)) }gxei;
  $format=~s/SS(?:\.0)?        / sprintf("%02d",$lt[0])         /gxei;
  $format=~s/(?:am|pm|apm|xm)  / $lt[2]<13 ? 'am' : 'pm'        /gxe;
  $format=~s/(?:AM|PM|APM|XM)  / $lt[2]<13 ? 'AM' : 'PM'        /gxe;
  $format=~s/WWI|WW            / sprintf("%02d",weeknum($time)) /gxei;
  $format=~s/W                 / weeknum($time)                 /gxei;
  $format=~s/(?:\bE\b|epoch)   /$time                           /gxi;
  $format;
}

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

Note: The Spencer Jones formula differs Oudins used in C<easter()> in some years
before 1498. However, in that period the Julian calendar with a different formula was
used anyway. Countries introduced the current Gregorian calendar between 1583 and 1926.

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

sub time_fp {  # {return 0+gettimeofday} is just as well?
    eval{ require Time::HiRes } or return time();
    my($sec,$mic)=Time::HiRes::gettimeofday();
    return $sec+$mic/1e6; #1e6 not portable?
}

sub timems {
    eval{ require Time::HiRes } or return time();
    my($sec,$mic)=Time::HiRes::gettimeofday();
    return $sec*1000+$mic/1e3;
}

=head2 sleep_fp

sleep_fp() work as the built in C<< sleep() >> but also accepts fractional seconds:

 sleep_fp(0.020);  # sleeps for 20 milliseconds

Sub sleep_fp do a C<require Time::HiRes>, thus it might take some
extra time the first call. To avoid that, add C<< use Time::HiRes >>
to your code. Sleep_fp should not be trusted for accuracy to more than
a tenth of a second. Virtual machines tend to be less accurate (sleep
longer) than physical ones. This was tested on VMware and RHEL
(Linux). See also L<Time::HiRes>.

=head2 sleeps

=head2 sleepms

=head2 sleepus

=head2 sleepns

 sleep_fp(0.020);   #sleeps for 20 milliseconds
 sleeps(0.020);     #sleeps for 20 milliseconds, sleeps() is a synonym to sleep_fp()
 sleepms(20);       #sleeps for 20 milliseconds
 sleepus(20000);    #sleeps for 20000 microseconds = 20000 μs = 20 milliseconds
 sleepns(20000000); #sleeps for 20 million nanoseconds = 20 milliseconds

=cut

#73e-6 (73μs) below is call overhead (on some systems, like on v5.22 on linux on a 2015 state of the art intel laptop)
#TODO: self modifying overhead estimation
sub sleep_fp { eval{require Time::HiRes} or (sleep(shift()),    return);my$s=shift()-73e-6;Time::HiRes::sleep($s>0?$s:0) }
sub sleeps   { eval{require Time::HiRes} or (sleep(shift()),    return);my$s=shift()-73e-6;Time::HiRes::sleep($s>0?$s:0) }
sub sleepms  { eval{require Time::HiRes} or (sleep(shift()/1e3),return);my$s=shift()-73e-6;Time::HiRes::sleep($s>0?$s/1e3:0) }
sub sleepus  { eval{require Time::HiRes} or (sleep(shift()/1e6),return);my$s=shift()-73e-6;Time::HiRes::sleep($s>0?$s/1e6:0) }
sub sleepns  { eval{require Time::HiRes} or (sleep(shift()/1e9),return);my$s=shift()-73e-6;Time::HiRes::sleep($s>0?$s/1e9:0) }

=head2 eta

Estimated time of arrival (ETA).

 for(@files){
    ...do work on file...
    my $eta = eta( ++$i, 0+@files ); # file now, number of files
    print "" . localtime($eta);
 }

TODO: eta is borken and out of wack, good idea?: http://en.wikipedia.org/wiki/Kalman_filter

=head2 etahhmm

 ...NOT YET

=cut

our %Eta;
our $Eta_forgetfulness=2;
sub eta {
  my($id,$pos,$end,$time_fp)=( @_==2 ? (join(";",caller()),@_) : @_ );
  $time_fp||=time_fp();
  my $a=$Eta{$id}||=[];
  push @$a, [$pos,$time_fp];
  @$a=@$a[map$_*2,0..@$a/2] if @$a>40;  #hm 40
  splice(@$a,-2,1) if @$a>1 and $$a[-2][0]==$$a[-1][0]; #same pos as last
  return undef if @$a<2;
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

Note: sleep_until() will remember the time of ANY last call of this sub,
not just the one on the same line in the source code (this might change
in the future). The first call to sleep_until() will be the same as
sleep_fp() or Perl's own sleep() if the argument is an integer.

=cut

our $Time_last_sleep_until;
sub sleep_until {
  my $s=@_==1?shift():0;
  my $time=time_fp();
  my $sleep=$s-($time-nvl($Time_last_sleep_until,0));
  $Time_last_sleep_until=time;
  sleep_fp($sleep) if $sleep>0;
}

my %thr;
sub throttle {
  my($times,$mintime,$what)=@_;
  $what||=join(":",@{[caller(1)]}[3,2]);
  $thr{$what}||=[];
  my $thr=$thr{$what};
  push @$thr,time_fp();
  return if @$thr<$times;
  my $since=$$thr[-1]-shift(@$thr);
  my $sleep=$since<$mintime?$mintime-$since:0;
  sleep_fp($sleep);
  return $sleep;
}

=head2 leapyear

B<Input:> A year. A four digit number.

B<Output:> True (1) or false (0) of whether the year is a leap year or
not. (Uses current calendar even for periods before leapyears was used).

 print join(", ",grep leapyear($_), 1900..2014)."\n";

 1904, 1908, 1912, 1916, 1920, 1924, 1928, 1932, 1936, 1940, 1944, 1948, 1952, 1956,
 1960, 1964, 1968, 1972, 1976, 1980, 1984, 1988, 1992, 1996, 2000, 2004, 2008, 2012

Note: 1900 is not a leap year, but 2000 is. Years divided by 100 is a leap year only
if it can be divided by 400.

=cut

sub leapyear{$_[0]%400?$_[0]%100?$_[0]%4?0:1:0:1} #bool

#http://rosettacode.org/wiki/Levenshtein_distance#Perl
our %ldist_cache;
sub ldist {
  my($s,$t,$l) = @_;
  return length($t) if !$s;
  return length($s) if !$t;
  %ldist_cache=() if !$l and 1000<0+%ldist_cache;
  $ldist_cache{$s,$t} ||=
  do {
    my($s1,$t1) = ( substr($s,1), substr($t,1) );
    substr($s,0,1) eq substr($t,0,1)
      ? ldist($s1,$t1)
      : 1 + min( ldist($s1,$t1,1+$l), ldist($s,$t1,1+$l), ldist($s1,$t,1+$l) );
  };
}

=head1 OTHER

=head2 nvl

The I<no value> function (or I<null value> function)

C<nvl()> takes two or more arguments. (Oracles nvl-function take just two)

Returns the value of the first input argument with length() > 0.

Return I<undef> if there is no such input argument.

In perl 5.10 and perl 6 this will most often be easier with the C< //
> operator, although C<nvl()> and C<< // >> treats empty strings C<"">
differently. Sub nvl here considers empty strings and undef the same.

=cut

sub nvl {
  return $_[0] if defined $_[0] and length($_[0]) or @_==1;
  return $_[1] if @_==2;
  return nvl(@_[1..$#_]) if @_>2;
  return undef;
}

=head2 decode_num

See L</decode>.

=head2 decode

C<decode()> and C<decode_num()> works just as Oracles C<decode()>.

C<decode()> and C<decode_num()> accordingly uses perl operators C<eq> and C<==> for comparison.

Examples:

 my $a=123;
 print decode($a, 123,3,  214,4, $a);     # prints 3
 print decode($a, 123=>3, 214=>4, $a);    # prints 3, same thing since => is synonymous to comma in Perl

The first argument is tested against the second, fourth, sixth and so on,
and then the third, fifth, seventh and so on is
returned if decode() finds an equal string or number.

In the above example: 123 maps to 3, 124 maps to 4 and the last argument $a is returned elsewise.

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

A more perl-ish and often faster way of doing the same:

 {123=>3, 214=>7}->{$a} || $a                       # (beware of 0)

=cut

sub decode {
  croak "Must have a mimimum of two arguments" if @_<2;
  my $uttrykk=shift;
  if(defined$uttrykk){ shift eq $uttrykk and return shift or shift for 1..@_/2 }
  else               { !defined shift    and return shift or shift for 1..@_/2 }
  return shift;
}

sub decode_num {
  croak "Must have a mimimum of two arguments" if @_<2;
  my $uttrykk=shift;
  if(defined$uttrykk){ shift == $uttrykk and return shift or shift for 1..@_/2 }
  else               { !defined shift    and return shift or shift for 1..@_/2 }
  return shift;
}

=head2 qrlist

Input: An array of values to be used to test againts for existence.

Output: A reference to a regular expression. That is a C<qr//>

The regex sets $1 if it match.

Example:

  my @list=qw/ABc XY DEF DEFG XYZ/;
  my $filter=qrlist("ABC","DEF","XY.");         # makes a regex of it qr/^(\QABC\E|\QDEF\E|\QXY.\E)$/
  my @filtered= grep { $_ =~ $filter } @list;   # returns DEF and XYZ, but not XYZ because the . char is taken literally

Note: Filtering with hash lookups are WAY faster.

Source:

 sub qrlist (@) { my $str=join"|",map quotemeta, @_; qr/^($str)$/ }

=cut

sub qrlist (@) {
  my $str=join"|",map quotemeta,@_;
  return qr/^($str)$/;
}

=head2 ansicolor

Perhaps easier to use than L<Term::ANSIColor> ?

B<Input:> One argument. A string where the char C<¤> have special
meaning and is replaced by color codings depending on the letter
following the C<¤>.

B<Output:> The same string, but with C<¤letter> replaced by ANSI color
codes respected by many types terminal windows. (xterm, telnet, ssh,
telnet, rlog, vt100, cygwin, rxvt and such...).

B<Codes for ansicolor():>

 ¤r red
 ¤g green
 ¤b blue
 ¤y yellow
 ¤m magenta
 ¤B bold
 ¤u underline
 ¤c clear
 ¤¤ reset, quits and returns to default text color.

B<Example:>

 print ansicolor("This is maybe ¤ggreen¤¤?");

Prints I<This is maybe green?> where the word I<green> is shown in green.

If L<Term::ANSIColor> is not installed or not found, returns the input
string with every C<¤> including the following code letters
removed. (That is: ansicolor is safe to use even if Term::ANSIColor is
not installed, you just don't get the colors).

See also L<Term::ANSIColor>.

=cut

sub ansicolor {
  my $txt=shift;
  eval{require Term::ANSIColor} or return replace($txt,qr/¤./);
  my %h=qw/r red  g green  b blue  y yellow  m magenta  B bold  u underline  c clear  ¤ reset/;
  my $re=join"|",keys%h;
  $txt=~s/¤($re)/Term::ANSIColor::color($h{$1})/ge;
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

sub ccn_ok {
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

sub KID_ok {
  croak "Non-numeric argument" if $_[0]=~/\D/;
  my @k=split//,shift or return undef;
  my $s;$s+=pop(@k)+[qw/0 2 4 6 8 1 3 5 7 9/]->[pop@k] while @k;
  $s%10==0?1:0;
}



=head2 range

B<Input:>

One or more numeric arguments:

First: x (first returned element)

Second: y (up to y but not including y)

Third: step, default 1. The step between each returned element

If a fourth, fifth and so on arguments are given, they change the step for each returned element. As first derivative, second derivative.

B<Output:>

If one argument: returns the array C<(0 .. x-1)>

If two arguments: returns the array C<(x .. y-1)>

If three arguments: The default step is 1. Use a third argument to use a different step.

B<Examples:>

 print join ",", range(11);         # prints 0,1,2,3,4,5,6,7,8,9,10  (but not 11)
 print join ",", range(2,11);       # 2,3,4,5,6,7,8,9,10             (but not 11)
 print join ",", range(11,2,-1);    # 11,10,9,8,7,6,5,4,3
 print join ",", range(2,11,3);     # 2,5,8
 print join ",", range(11,2,-3);    # 11,8,5
 print join ",", range(11,2,+3);    # prints nothing

 print join ", ",range(2,11,1,0.1);       # 2, 3, 4.1, 5.3, 6.6, 8, 9.5   adds 0.1 to step each time
 print join ", ",range(2,11,1,0.1,-0.01); # 2, 3, 4.1, 5.29, 6.56, 7.9, 9.3, 10.75

Note: In the Python language and others, C<range> is a build in iterator (a
generator), not an array. This saves memory for large sets and sometimes time.
Use C<range> in L<List::Gen> to get a similar lazy generator in Perl.

=cut

sub range {
  return _range_accellerated(@_) if @_>3;  #see below
  my($x,$y,$jump)=@_;
  return (  0 .. $x-1 ) if @_==1;
  return ( $x .. $y-1 ) if @_==2;
  croak "Wrong number of arguments or jump==0" if @_!=3 or $jump==0;
  my @r;
  if($jump>0){  while($x<$y){ push @r, $x; $x+=$jump } }
  else       {  while($x>$y){ push @r, $x; $x+=$jump } }
  return @r;
}

#jumps derivative, double der., trippled der usw
sub _range_accellerated {
  my($x,$y,@jump)=@_;
  my @r;
  my $test = $jump[0]>=0 ? sub{$x<$y} : sub{$x>$y};
  while(&$test()){
    push @r, $x;
    $x+=$jump[0];
    $jump[$_-1]+=$jump[$_] for 1..$#jump;
  }
  return @r;
}

=head2 globr

Works like and uses Perls builtin C<< glob() >> but adds support for ranges
with C<< {from..to} >> and C<< {from..to..step} >>. Like brace expansion in bash.

Examples:

 my @arr = glob  "X{a,b,c,d}Z";         # @arr now have four elements: XaZ XbZ XcZ XdZ
 my @arr = globr "X{a,b,c,d}Z";         # same as above
 my @arr = globr "X{a..d}Z";            # same as above
 my @arr = globr "X{a..f..2}";          # step 2, returns array: Xa Xc Xe
 my @arr = globr "{aa..bz..13}Z";       # aaZ anZ baZ bnZ
 my @arr = globr "{1..12}b";            # 1b 2b 3b 4b 5b 6b 7b 8b 9b 10b 11b 12b
 my @arr = globr "{01..11}b";           # 01b 02b 03b 04b 05b 06b 07b 08b 09b 10b 11b (keeps leading zero)
 my @arr = globr "{01..12..3}b";        # 01b 04b 07b 10b

=cut

sub globr($) {
  my $p=shift;
  $p=~s{
    \{(-?\w+)\.\.(-?\w+)(\.\.(-?\d+))?\}
  }{
    my $i=0;
    my @r=$1 le $2 ? ($1..$2) : reverse($2..$1);
    @r=grep !($i++%$4),@r if $4;
    "{" . join(",",@r) . "}"
  }xeg;
  glob $p;
}

=head2 permutations

How many ways (permutations) can six people be placed around a table:

 One person:          one way
 Two persons:         two ways  (they can swap places)
 Three persons:         6
 Four persons:         24
 Five persons:        120
 Six  persons:        720

The formula is C<x!> where the postfix unary operator C<!>, also known as I<faculty> is defined as:
C<x! = x * (x-1) * (x-2) ... * 1>. Example: C<5! = 5 * 4 * 3 * 2 * 1 = 120>.Run this to see the 100 first C<< n! >>

 perl -MAcme::Tools -le'$i=big(1);print "$_!=",$i*=$_ for 1..100'

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

#TODO: see t/test_perm.pl and t/test_perm2.pl

sub permutations {
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

=head2 perm

 print @$_,"\n" for perm("a".."c");           # prints six lines: abc acb bac bca cab cba

=head2 permute

 my $c = permute { print @_,"\n" } "a".."c";  # prints six lines: abc acb bac bca cab cba
 print "count: $c\n";                         # prints 6 = 3*2*1 = 3!

The permute BLOCK needs to return true (which print does) for permute to continue:

 my $c = permute { print @_,"\n"; rand()<.5 } "a".."d";  # probably prints less than 24 strings
 print "count: $c\n";                                    # prints random number up to 24 = 4*3*2*1 = 4!

=head2 permute_continue

 my @abc   = ("a", "b", "c");
 my @start = ("b", "a", "c");                               # starting sequence to continue from
 my $c = permute_continue { print @_,"\n" } \@abc, \@start; # prints four lines: bac bca cab cba
 my $c = permute          { print @_,"\n" } \@abc, \@start; # same, =permute_continue when coreref+arrayref+arrayref
 print "count: $c\n";                                       # prints 6-2 = 3*2*1-2 = 3!-2

The permute BLOCK needs to return true (which print does) for permute to continue:

 my $c = permute { print @_,"\n"; rand()<.5 } "a".."d";  # probably prints less than 24 strings
 print "count: $c\n";                                    # prints random number up to 24 = 4*3*2*1 = 4!

=cut

sub perm {
    my(@i,@r) = 0..$#_;
    @_ || return;
    while ( push @r, [@_[@i]] ) {
	my $p = $#i || last;
	--$p || last while $i[$p-1] > $i[$p];
	push @i, reverse splice @i, my$q=$p;
	++$q while $i[$p-1] > $i[$q];
	@i[$p-1,$q] = @i[$q,$p-1];
    }
    @r
}

sub permute (&@) {
    return permute_continue(@_) if 'CODE,ARRAY,ARRAY' eq join',',map ref,@_;
    my $f = shift;
    my @i = 0..$#_;
    my $n = 0;
    @_ || do{ &$f(@_); return 0 };
    while ( ++$n and &$f(@_[@i]) ) {
	my $p = $#i || last;
	--$p || last while $i[$p-1] > $i[$p];
	push @i, reverse splice @i, my$q=$p;
	++$q while $i[$p-1] > $i[$q];
	@i[$p-1,$q] = @i[$q,$p-1];
    }
    $n;
}

#Fischer-Krause permutation starting from a specific sequence, for example to farm out permute to more than one process
sub permute_continue (&\@\@) {
    my ($f,$begin,$from) = @_;
    my %h; @h{@$begin} = 0 .. $#$begin;
    my @idx = @h{@$from};
    my $n = 0;
    while ( ++$n and &$f(@$begin[@idx]) ) {
	my $p = $#idx || last;
	--$p || last while $idx[$p-1] > $idx[$p];
	push @idx, reverse splice @idx, my$q=$p;
	++$q while $idx[$p-1] > $idx[$q];
	@idx[$p-1,$q]=@idx[$q,$p-1];
    }
    $n
}


=head2 cart

Cartesian product

B<Easy usage:>

Input: two or more arrayrefs with accordingly x, y, z and so on number of elements.

Output: An array of x * y * z number of arrayrefs. The arrays being the cartesian product of the input arrays.

It can be useful to think of this as joins in SQL. In C<select> statements with
more than one table behind C<from>, but without any C<where> condition to join the tables.

B<Advanced usage, with condition(s):>

B<Input:>

- Either two or more arrayrefs with x, y, z and so on number of elements.

- Or coderefs to subs containing condition checks. Somewhat like C<where> conditions in SQL.

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

B<This:> with a condition: the sum of the first two should be divisible by 3:

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

B<Examples, from the tests:>

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

B<Example, hash-mode:>

Returns hashrefs instead of arrayrefs:

 my @cards=cart(          # @card gets 5200 hashrefs, 100 decks of 52 cards
   deck => [1..100],
   rank => [qw(2 3 4 5 6 7 8 9 10 J Q K A)],
   suit => [qw(heart diamond club star)],
 );
 for my $card ( mix(@cards) ) {
   print "From deck number $$card{deck} we got $$card{rank} $$card{suit}\n";
 }

Note: using sub-ref filters do not work (yet) in hash-mode. Use grep on result instead.

=cut

sub cart {
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

sub cart_easy { #not tested, not exported http://stackoverflow.com/questions/2457096/in-perl-how-can-i-get-the-cartesian-product-of-multiple-sets
  my $last = pop @_;
  @_ ? (map {my$left=$_; map [@$left, $_], @$last } cart_easy(@_) )
     : (map [$_], @$last);
}

=head2 reduce

From: Why Functional Programming Matters: L<http://www.md.chalmers.se/~rjmh/Papers/whyfp.pdf> L<http://www.cse.chalmers.se/~rjmh/Papers/whyfp.html>

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

sub reduce_bk (&@) {
  my ($proc, $first, @rest) = @_;
  return $first if @rest == 0;
  no warnings;
  local ($a, $b) = ($first, reduce($proc, @rest));
  return $proc->();
}

sub reduce (&@) {
  my $code = shift;
  no strict 'refs';
  return shift unless @_ > 1;
  use vars qw($a $b);
  my $caller = caller;
  local(*{$caller."::a"}) = \my $a;
  local(*{$caller."::b"}) = \my $b;
  $a = shift;
  $b = $_, $a = &{$code}() for @_;
  $a;
}
#sub reduce(&@){my$sub=shift;unshift@_,$sub->(shift,shift) while @_>1; $_[0]}
#my $sum = reduce { $_[0] + $_[1] } @list;

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

sub pivot {
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
             map { defined($_)?$_:exists$opt{undefined}?$opt{undefined}:undef }
	     map {
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
    return $c if $c and "$a[$_]$b[$_]"!~/[iI][nN][fF]|þ|∞/i; # hm inf(inity)
    $c=$a[$_]cmp$b[$_];
    return $c if $c;
  }
  return 0;
}

=head2 tablestring

B<Input:> one or two arguments:

1) a reference to an array of arrayrefs  -- a two dimensional table of strings and numbers

2) an optional hashref to options:



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

sub tablestring {
  my $tab=shift;
  my %o=$_[0] ? %{shift()} : ();
  my $remove_empty       = $o{remove_empty_columns};
  my $no_multiline_space = $o{no_multiline_space};
  my $nodup              = $o{nodup}||0;
  my $no_header_line     = $o{no_header_line};
  my $pagesize           = exists $o{pagesize} ? $o{pagesize}-3 : 9999999;
  my $left_force         = $o{left};
  my(@width,@left,@height,@not_empty,@nodup);
  my $head=1;
  my $i=0;
  my $j;
  for(@$tab){
    $j=0;
    $height[$i]=0;
    my $nodup_rad=$nodup;
    if(ref($_) eq 'ARRAY'){
      for(@$_){
	my $cell=$_;
	$width[$j]||=0;
	if($nodup_rad and $i>0 and $$tab[$i][$j] eq $$tab[$i-1][$j] || ($nodup_rad=0)){
	  $cell=$nodup==1?"":$nodup;
	  $nodup[$i][$j]=1;
	}
	else{
	  my $height=0;
	  my $wider;
	  no warnings;
	  $not_empty[$j]=1 if !$head && length($cell)>0;
	  for(split("\n",$cell)){
	    $wider=/<input.+type=text.+size=(\d+)/i?$1:0; #hm
	    s/<[^>]+>//g;
	    $height++;
	    s/&gt;/>/g;
	    s/&lt;/</g;
	    $width[$j]=length($_)+1+$wider if length($_)+1+$wider>$width[$j];
	    $left[$j]=1 if $_ && !/^\s*[\-\+]?(\d+|\d*\.\d+)\s*\%?$/ && !$head;
	  }
	  if( $height>1 && !$no_multiline_space){
	    $height++ if !$head;
	    $height[$i-1]++ if $i>1 && $height[$i-1]==1;
	  }
	  $height[$i]=$height if $height>$height[$i];
	}
	$j++;
      }
    }
    else{
      $height[$i]=1;
      $no_header_line=1;
    }
    $head=0;
    $i++;
  }
  $i=$#height;
  $j=$#width;
  if($i==0 or $left_force) { @left=map{1}(0..$j)                         }
  else { for(0..$j){ $left[$_]=1 if !$not_empty[$_] }  }
  my @tabout;
  my $row_start_line=0;
  my @header;
  my $header_last;
  for my $x (0..$i){
    if($$tab[$x] eq '-'){
      my @char=map {$$tab[$x-1][$_]=~/\S/?"-":" "} (0..$j);
      $tabout[$row_start_line]=join(" ",map {$char[$_] x ($width[$_]-1)} (0..$j));
    }
    else{
      for my $y (0..$j){
	next if $remove_empty && !$not_empty[$y];
	no warnings;
	my @cell = !$header_last&&$nodup&&$nodup[$x][$y]
     	         ? ($nodup>0?():((" " x (($width[$y]-length($nodup))/2)).$nodup))
                 : split("\n",$$tab[$x][$y]);
	for(0..($height[$x]-1)){
	  my $line=$row_start_line+$_;
	  my $txt=shift(@cell);
	  $txt='' if !defined$txt;
	  $txt=sprintf("%*s",$width[$y]-1,$txt) if length($txt)>0 && !$left[$y] && ($x>0 || $no_header_line);
	  $tabout[$line].=$txt;
	  if($y==$j){
	    $tabout[$line]=~s/\s+$//;
	  }
	  else{
	    my $wider;
	       $wider = $txt=~/<input.+type=text.+size=(\d+)/i?1+$1:0;
	    $txt=~s/<[^>]+>//g;
	    $txt=~s/&gt;/>/g;
	    $txt=~s/&lt;/</g;
	    $tabout[$line].= ' ' x ($width[$y]-length($txt)-$wider);
	  }
	}
      }
    }
    $row_start_line+=$height[$x];

    #--lage streker?
    if(not $no_header_line){
      if($x==0){
	for my $y (0..$j){
	  next if $remove_empty && !$not_empty[$y];
	  $tabout[$row_start_line].=('-' x ($width[$y]-1))." ";
	}
	$row_start_line++;
	@header=("",@tabout);
      }
      elsif(
	    $x%$pagesize==0 || $nodup>0&&!$nodup[$x+1][$nodup-1]
	    and $x+1<@$tab
	    and !$no_header_line
	    )
      {
	push(@tabout,@header);
	$row_start_line+=@header;
	$header_last=1;
      }
      else{
	$header_last=0;
      }
    }
  }#for x
  my $r=join("\n",@tabout)."\n";
  #tablestring_box(\$r) if $o{box}; #hm
  $r
}

=head2 tablestring_box

Returns a multiline string of the rendered two dimentional input table with
utf-8 box-drawing chars (like C<.mode box> in newer sqlite3 versions).
Numeric columns are right aligned. Requires a UTF-8 enabled terminal to
see the UTF-8 lines properly. Run the 'locale' command if on Linux-ish
systems to check for UTF-8. Otherwise, use the C<tablestring()> functions.

 my @tab = (  ['aa', 'bbbbb', 'cccc', 'ddddddddd'],
              [1, undef,'hello'],
              [2],
              ['3', -23.4, 'xxx'],
              [126, 20, 'asdfasdf1', 'xyz'] );
  
 print tablestring_box(\@tab);

Output this multiline string with utf-8 lines: (ie for utf-8 terminals or <pre> blocks in html)

 ┌─────┬───────┬───────────┬───────────┐
 │ aa  │ bbbbb │ cccc      │ ddddddddd │
 ├─────┼───────┼───────────┼───────────┤
 │   1 │       │ hello     │           │
 │   2 │       │           │           │
 │   3 │ -23.4 │ xxx       │           │
 │ 126 │    20 │ asdfasdf1 │ xyz       │
 └─────┴───────┴───────────┴───────────┘

Cells can be multilined:

 print tablestring_box([
   ["aaaa\n(%)", 'bbbbb', 'cccc', "dddddd\nddd\nasdfdsa"],
   [1, undef,'hello'],
   ['3', -23.4, 'xxx'],
   [12345, 20, "asdfasdf1\nasdffdsa\nxasdf", 'xyz']]);
 ┌───────┬───────┬───────────┬─────────┐
 │ aaaa  │ bbbbb │ cccc      │ dddddd  │
 │ (%)   │       │           │ ddd     │
 │       │       │           │ asdfdsa │
 ├───────┼───────┼───────────┼─────────┤
 │     1 │       │ hello     │         │
 │     3 │ -23.4 │ xxx       │         │
 │       │       │           │         │
 │ 12345 │    20 │ asdfasdf1 │ xyz     │
 │       │       │ asdffdsa  │         │
 │       │       │ xasdf     │         │
 │       │       │           │         │
 └───────┴───────┴───────────┴─────────┘

TODO: tablestring_box() dont yet support tags in values as in html/xml tags like tablestring() do.

=cut

sub tablestring_box {
    use utf8;
    my $tmpo=ref($_[-1]) eq 'HASH'?pop:{};
    return tablestring_box([@_],$tmpo) if !ref($_[0]) or !ref($_[0][0]);
    my($hl,$i,$t,$opt)=(0,-1,@_);
    my @t=map{
	my @r=map[split/\n/,$_//''],@$_;
	my $l=0;$l=$l<@$_?@$_:$l for@r;
	my @l=map{my$i=$_;[map$$_[$i]//'',@r]}0..$l-1;
	@l=([],@l,[]) if $l>1 and $hl;
	$hl||=$l;
	@l
    }@$t;
    my @w;for(@t){$w[$i]=!defined$w[++$i]||length>$w[$i]?length:$w[$i] for@$_;$i=-1} #width
    my %l;for(@t[$hl..$#t]){++$i,/\S/&&!/$Re_isnum/&&$l{$i}++for@$_;$i=-1} #left align
    my $ts="┌───┬───┐\n"
	  ."│ x │ x │\n"x$hl
	  ."├───┼───┤\n"
	  ."│ y │ y │\n"x(@t-$hl)
	  ."└───┴───┘";
    $ts=~s/^(.+?)([┼┴┬]───|│ [xy] )/$1.$2x$#w/gem;
    $ts=join'',map{for my$w(1..@w){my$pos=2+4*(@w-$w);s/(.{$pos})(.)/$1.($2x$w[@w-$w])/e};"$_\n"}split/\n/,$ts;
    $ts=~s!([xy])+!sprintf$l{++$i%@w}||$1eq'x'?"%-*s":"%*s",length$&,$t[$i/@w][$i%@w]//''!ge;
    #utf8::encode($ts); #hm ::decode input?
    $ts
}

=head2 serialize

Returns a data structure as a string. See also C<Data::Dumper>
(serialize was created in the 90s on early Perl5s before awareness
if Data::Dumper existed or not)

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
sub _kallstack { my $tilbake=shift||0; my @c; my $ret; $ret.=serialize(\@c,"caller$tilbake") while @c=caller(++$tilbake); $ret }
sub dserialize{join "\n",serialize(@_)=~/(.{1,$Dserialize_width})/gs}
sub serialize {
  no warnings;
  my($r,$name,$filename,$level)=@_;
  my @r=(undef,undef,($level||0)-1);
  if($filename){
    open my $fh, '>', $filename or croak("FEIL: could not open file $filename\n" . _kallstack());
    my $ret=serialize($r,$name,undef,$level);
    print $fh "$ret\n1;\n";
    close($fh);
    return $ret;
  }
  if(ref($r) eq 'SCALAR'){
    return "\$$name=".serialize($r,@r).";\n" if $name;
    return "undef" unless defined $$r;
    my $ret=$$r;
    $ret=~s/\\/\\\\/g;
    $ret=~s/\'/\\'/g;
    return "'$ret'";
  }
  elsif(ref($r) eq 'ARRAY'){
    return "\@$name=".serialize($r,@r).";\n" if $name;
    my $ret="(";
    for(@$r){
      $ret.=serialize(\$_,@r).",";
      $ret.="\n" if $level>=0;
    }
    $ret=~s/,$//;
    $ret.=")";
    $ret.=";\n" if $name;
    return $ret;
  }
  elsif(ref($r) eq 'HASH'){
    return "\%$name=".serialize($r,@r).";\n" if $name;
    my $ret="(";
    for(sort keys %$r){
      $ret.=serialize(\$_,@r)."=>".serialize(\$$r{$_},@r).",";
      $ret.="\n" if $level>=0;
    }
    $ret=~s/,$//;
    $ret.=")";
    $ret.=";\n" if $name;
    return $ret;
  }
  elsif(ref($$r) eq 'ARRAY'){
    return "\@$name=".serialize($r,@r).";\n" if $name;
    my $ret="[";
    for(@$$r){
      $ret.=serialize(\$_,@r).",";
      $ret.="\n" if !defined $level or $level>=0;
    }
    $ret=~s/,$//;
    $ret.="]";
    $ret.=";\n" if $name;
    return $ret;
  }
  elsif(ref($$r) eq 'HASH'){
    return "\%$name=".serialize($r,@r).";\n" if $name;
    my $ret="{";
    for(sort keys %$$r){
      $ret.=serialize(\$_,@r)."=>".serialize(\$$$r{$_},@r).",";
      $ret.="\n" if $level>=0;
    }
    $ret=~s/,$//;
    $ret.="}";
    $ret.=";\n" if $name;
    return $ret;
  }
  elsif(ref($$r) eq 'SCALAR'){
    return "\\".serialize($$r,@r);
  }
  elsif(ref($r) eq 'LVALUE'){
    my $s="$$r";
    return serialize(\$s,@r);
  }
  elsif(ref($$r) eq 'CODE'){
    #warn "Tried to serialize CODE";
    return 'sub{croak "Can not serialize CODE-references, see perhaps B::Deparse and Storable"}'
  }
  elsif(ref($$r) eq 'GLOB'){
    warn "Tried to serialize a GLOB";
    return '\*STDERR'
  }
  else{
    my $tilbake;
    my($pakke,$fil,$line,$sub,$hasargs,$wantarray);
      ($pakke,$fil,$line,$sub,$hasargs,$wantarray)=caller($tilbake++) until $sub ne 'serialize' || $tilbake>20;
    croak("serialize() argument should be reference!\n".
        "\$r=$r\n".
        "ref(\$r)   = ".ref($r)."\n".
        "ref(\$\$r) = ".ref($$r)."\n".
        "kallstack:\n". _kallstack());
  }
}

=head2 srlz

Synonym to L</serialize>, but remove unnecessary single quote chars around
C<< \w+ >>-keys and number values (except numbers with leading zeros). Example:

serialize:

 %s=('action'=>{'del'=>'0','ins'=>'0','upd'=>'18'},'post'=>'1348','pre'=>'1348',
     'updcol'=>{'Laerestednr'=>'18','Studietypenr'=>'18','Undervisningssted'=>'7','Url'=>'11'},
     'where'=>'where 1=1');

srlz:

 %s=(action=>{del=>0,ins=>0,upd=>18},post=>1348,pre=>1348,
     updcol=>{Laerestednr=>18,Studietypenr=>18,Undervisningssted=>7,Url=>11},
     where=>'where 1=1');

Todo: update L</serialize> to do the same, but in the right way. (For now
srlz runs the string from serialize() through two C<< s/// >>, this will break
in certain cases). L</srlz> will be kept as a synonym (or the other way around).

=cut

sub srlz {
  my $s=serialize(@_);
  $s=~s,'(\w+)'=>,$1=>,g;                                       #todo: ikke ledende null!
  $s=~s,=>'([+-]?(0|[1-9]\d*)(\.\d+)?([eE][-+]?\d+)?)',=>$1,g;  #todo?: ikke ledende null!    hm
  $s;
}

#sub srz {
#    ref circular safe...
#}

=head2 cnttbl

 my %nordic_country_population=(Norway=>5214890,Sweden=>9845155,Denmark=>5699220,Finland=>5496907,Iceland=>331310);
 print cnttbl(\%nordic_country_population);
 Iceland   331310   1.25%
 Norway   5214890  19.61%
 Finland  5496907  20.67%
 Denmark  5699220  21.44%
 Sweden   9845155  37.03%
 SUM     26587482 100.00%

Todo: Levels...:

 my %sales=(
  Toyota=>{Prius=>19,RAV=>12,Auris=>18,Avensis=>7},
  Volvo=>{V40=>14, XC90=>4},
  Nissan=>{Leaf=>19,Qashqai=>17},
  Tesla=>{ModelS=>8}
 );
 print cnttbl(\%sales);
 Toyota SUM 56
 Volvo SUM 18
 Nissan SUM 36
 Tesla SUM 8
 SUM SUM 56 100%

=cut

sub cnttbl {
  my $hr=shift;
  my $maxlen=max(3,map length($_),keys%$hr);
  join"",ref((values%$hr)[0])
  ?do{ map {my$o=$_;join("",map rpad($$o[0],$maxlen)." $_\n",split("\n",$$o[1]))}
       map [$_,cnttbl($$hr{$_})],
       sort keys%$hr }
  :do{ my $sum=sum(values%$hr);
       my $fmt=repl("%-xs %yd %6.2f%%\n",x=>$maxlen,y=>length($sum));
       map sprintf($fmt,@$_,100*$$_[1]/$sum),
       (map[$_,$$hr{$_}],sort{$$hr{$a}<=>$$hr{$b} or $a cmp $b}keys%$hr),
       (['SUM',$sum]) }
}

=head2 ref_deep

NOT IMPLEMENTED

Same as ref, but goes deeper.

 print ref_deep( { 10=>[1,'ten'], 100=>[2,'houndred'], 1000=>[3,'thousand'] } );   # prints HASH_of_ARRAYS
 print ref_deep( { 10=>'ten',     100=>[2,'houndred'], 1000=>[3,'thousand'] } );   # prints same (mixed, deepest)
 print ref_deep( { 1=>[{a=>3,b=>6},{a=>1,b=>8}], 5=>[{a=>2,b=>5},{a=>7,b=>1}] } ); # HASH_of_ARRAYS_of_HASHES

(Todo, not supported: circular, alternatives for mixed)

=cut

sub ref_deep {
  my $s=shift; #
}



=head2 nicenum

 print 14.3 - 14.0;              # 0.300000000000001
 print 34.3 - 34.0;              # 0.299999999999997
 print nicenum( 14.3 - 14.0 );   # 0.3
 print nicenum( 34.3 - 34.0 );   # 0.3

=cut

our $Nicenum;
sub nicenum { #hm
  $Nicenum=$_[0];
  $Nicenum=~s/([\.,]\d*)((\d)\3\3\3\3\3)\d$/$1$2$3$3$3$3$3$3$3$3$3/;
  my $r=0+$Nicenum;
  #warn "nn $_[0] --> $Nicenum --> $r\n";
  $r;
}


=head2 sys

Call instead of C<system> if you want C<die> (Carp::croak) when something fails.

 sub sys($){ my$s=shift; my$r=system($s); $r==0 or croak"ERROR: system($s)==$r ($!) ($?)" }


=cut

sub sys($){ my$s=shift; my$r=system($s); $r==0 or croak"ERROR: system($s)==$r ($!) ($?)" }

=head2 recursed

Returns true or false (actually 1 or 0) depending on whether the
current sub has been called by itself or not.

 sub xyz
 {
    xyz() if not recursed;

 }

=cut

sub recursed {(caller(1))[3] eq (caller(2))[3]?1:0}



=head2 ed

String editor commands

 literals:               a-z 0-9 space
 move cursor:            FBAEPN MF MB ME
 delete:                 D Md
 up/low/camelcase word   U L C
 backspace:              -
 search:                 S
 return/enter:           R
 meta/esc/alt:           M
 shift:                  T
 cut to eol:             K
 caps lock:              C
 yank:                   Y
 start and end:          < >
 macro start/end/play:   { } !
 times for next cmd:     M<number>  (i.e. M24a inserts 24 a's)

(TODO: alfa...and more docs needed)

=cut

our $Edcursor;
sub ed {
  my($s,$cs,$p,$buf)=@_; #string, commands, point (or cursor)
  return $$s=ed($$s,$cs,$p,$buf) if ref($s);
  my($sh,$cl,$m,$t,@m)=(0,0,0,undef);
  while(length($cs)){
    my $n = 0;
    my $c = $cs=~s,^(M\d+|M.|""|".+?"|S.+?R|\\.|.),,s ? $1 : die;
    $p = curb($p||0,0,length($s));
    if(defined$t){$cs="".($c x $t).$cs;$t=undef;next}
    my $add=sub{substr($s,$p,0)=$_[0];$p+=length($_[0])};
    if   ($c =~ /^([a-z0-9 ])/){ &$add($sh^$cl?uc($1):$1); $sh=0 }
    elsif($c =~ /^"(.+)"$/)    { &$add($1) }
    elsif($c =~ /^\\(.)/)      { &$add($1) }
    elsif($c =~ /^S(.+)R/)     { my $i=index($s,$1,$p);$p=$i+length($1) if $i>=0 }
    elsif($c =~ /^M(\d+)/)     { $t=$1; next }
    elsif($c eq 'F') { $p++ }
    elsif($c eq 'B') { $p-- }
    elsif($c eq 'A') { $p-- while $p>0 and substr($s,$p-1,2)!~/^\n/ }
    elsif($c eq 'E') { substr($s,$p)=~/(.*)/ and $p+=length($1) }
    elsif($c eq 'D') { substr($s,$p,1)='' }
    elsif($c eq 'MD'){ substr($s,$p)=~s/^(\W*\w+)// and $buf=$1 }
    elsif($c eq 'MF'){ substr($s,$p)=~/(\W*\w+)/ and $p+=length($1) }
    elsif($c eq 'MB'){ substr($s,0,$p)=~/(\w+\W*)$/ and $p-=length($1) }
    elsif($c eq '-') { substr($s,--$p,1)='' if $p }
    elsif($c eq 'M-'){ substr($s,0,$p)=~s/(\w+\W*)$// and $p-=length($buf=$1)}
    elsif($c eq 'K') { substr($s,$p)=~s/(\S.+|\s*?\n)// and $buf=$1 }
    elsif($c eq 'Y') { &$add($buf) }
    elsif($c eq 'U') { substr($s,$p)=~s/(\W*)(\w+)/$1\U$2\E/; $p+=length($1.$2) }
    elsif($c eq 'L') { substr($s,$p)=~s/(\W*)(\w+)/$1\L$2\E/; $p+=length($1.$2) }
    elsif($c eq 'C') { substr($s,$p)=~s/(\W*)(\w+)/$1\u\L$2\E/; $p+=length($1.$2) }
    elsif($c eq '<') { $p=0 }
    elsif($c eq '>') { $p=length($s) }
    elsif($c eq 'T') { $sh=1 }
    elsif($c eq 'C') { $cl^=1 }
    elsif($c eq '{') { $m=1; @m=() }
    elsif($c eq '}') { $m=0 }
    elsif($c eq '!') { $m||!@m and die"ed: no macro"; $cs=join("",@m).$cs }
    elsif($c eq '""'){ &$add('"') }
    else             { croak "ed: Unknown cmd '$c'\n" }
    push @m, $c if $m and $c ne '{';
    #warn serialize([$c,$m,$cs],'d');
  }
  $Edcursor=$p;
  $s;
}

=head2 changed

 while(<>){
    my $line=$_;
    print "\n" if changed(/^\d\d\d\d-\d\d-(\d\d)/);
    print "\n" if changed(substr($_,8,2));
 }

Returns undef, 0 or 1. Undef if its the first time C<changed> is
called on that perl line. 0 if not the first time and the parameters
differ from the last call on that line. 1 if not the first time and
the parameters is the exact same as they where on the previous call on
that line of perl source code.

=cut

our %Changed_lastval;
sub changed {
    my $now=join($;,@_);
    my $key=join($;,caller());
    my $e=exists $Changed_lastval{$key};
    if($e){
	my $last=$Changed_lastval{$key};
	return 0 if  defined $last and  defined $now and $last eq $now
                 or !defined $last and !defined $now;
    }
    $Changed_lastval{$key}=$now;
    return $e?1:undef;
}

=head2 graph_scc

Returns the strongly connected components of a graph.

A strongly connected component (a SCC) is a group of vertices in the graph that can all be reached from every other vertice in the same
group by following the directed edges.  A SCC is either one vertice, a subset of the vertices in the graph or all the vertices. A graph has
one or more SCCs. In graph_scc() Kosaraju's algorithm is implemented L<https://en.wikipedia.org/wiki/Kosaraju%27s_algorithm> Example:

       A ---> B       ,---  G <--- H
       ^      |      /      ^      ^
       |      |      |      |      |
       |      v      v      |      |
       D <--- C ---> E ---> F      I

 my @scc = graph_scc(
     ['A'=>'B'], ['B'=>'C'], ['C'=>'D'], ['D'=>'A'],   ['C'=>'E'],
     ['E'=>'F'], ['F'=>'G'], ['G'=>'E'],              ['H'=>'G'],  ['I'=>'H']
 );
 print srlz( \@scc, 'scc' );

This will print the four SCCs (four lists of vertices) of that graph:

 @scc=(  ['A','B','C','D'],   ['E','F','G'],  ['H'],  ['I']  );

=cut

sub graph_scc {
    my($vtag, @stack, %visited, %goto, %seen, $dfs, $trav) = (1);

    $dfs= sub { my $v = shift; $visited{$v} = $vtag; &$trav(@{$goto{$v}}); unshift @stack, $v };
    $trav=sub { $visited{$_} or &$dfs($_) for @_ };

    push @{$goto{$$_[0]}}, $$_[1] for @_;
    &$trav(sort grep !$seen{$_}++, map@$_, @_);
     %visited = %goto = ();
    push @{$goto{$$_[1]}}, $$_[0] for @_;

    sort { $$a[0] cmp $$b[0] } #sort unnecessary?
    grep ref,
    map { $visited{$_} ? 0 : do { $vtag++; &$dfs($_); [ sort grep $visited{$_}==$vtag, keys %visited ] } }
    @stack
}

#todo: sub unbless eller sub damn
#todo: ..se også: use Data::Structure::Util qw/unbless/;
#todo: ...og: Acme::Damn sin damn()
#todo? sub swap($$) http://www.idg.no/computerworld/article242008.ece
#todo? catal
#todo?
#void quicksort(int t, int u) int i, m; if (t >= u) return; swap(t, randint(t, u)); m = t; for (i = t + 1; i <= u; i++) if (x[i] < x[t]) swap(++m, i); swap(t, m) quicksort(t, m-1); quicksort(m+1, u);


=head1 JUST FOR FUN

=head2 brainfu

B<Input:> one or two arguments

First argument: a string, source code of the brainfu
language. String containing the eight charachters + - < > [ ] . ,
Every other char is ignored silently.

Second argument: if the source code contains commas (,) the second
argument is the input characters in a string.

B<Output:> The resulting output from the program.

Example:

 print brainfu(<<"");  #prints "Hallo Verden!\n"
 ++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>---.+++++++++++..+++.>++.<<++++++++++++++
 .>----------.+++++++++++++.--------------.+.+++++++++.>+.>.

See L<http://en.wikipedia.org/wiki/Brainfuck>

=head2 brainfu2perl

Just as L</brainfu> but instead it return the perl code to which the
brainfu code is translated. Just C<< eval() >> this perl code to run.

Example:

 print brainfu2perl('>++++++++[<++++++++>-]<++++++++.>++++++[<++++++>-]<---.');

Prints this string:

 my($c,$o,@b)=(0); sub out{$o.=chr($b[$c]) for 1..$_[0]||1}
 ++$c;++$b[$c];++$b[$c];++$b[$c];++$b[$c];++$b[$c];++$b[$c];++$b[$c];++$b[$c];
 while($b[$c]){--$c;++$b[$c];++$b[$c];++$b[$c];++$b[$c];++$b[$c];++$b[$c];++$b[$c];
 ++$b[$c];++$c;--$b[$c];}--$c;++$b[$c];++$b[$c];++$b[$c];++$b[$c];++$b[$c];++$b[$c];
 ++$b[$c];++$b[$c];out;++$c;++$b[$c];++$b[$c];++$b[$c];++$b[$c];++$b[$c];++$b[$c];
 while($b[$c]){--$c;++$b[$c];++$b[$c];++$b[$c];++$b[$c];++$b[$c];++$b[$c];++$c;--$b[$c];}
 --$c;--$b[$c];--$b[$c];--$b[$c];out;$o;

=head2 brainfu2perl_optimized

Just as L</brainfu2perl> but optimizes the perl code. The same
example as above with brainfu2perl_optimized returns this equivalent
but shorter perl code:

 $b[++$c]+=8;while($b[$c]){$b[--$c]+=8;--$b[++$c]}$b[--$c]+=8;out;$b[++$c]+=6;
 while($b[$c]){$b[--$c]+=6;--$b[++$c]}$b[--$c]-=3;out;$o;

=cut

sub brainfu { eval(brainfu2perl(@_)) }

sub brainfu2perl {
  my($bf,$inp)=@_;
  my $perl='my($c,$inp,$o,@b)=(0,\''.$inp.'\'); no warnings; sub out{$o.=chr($b[$c]) for 1..$_[0]||1}'."\n";
  $perl.='sub inp{$inp=~s/(.)//s and $b[$c]=ord($1)}'."\n" if $inp and $bf=~/,/;
  $perl.=join("",map/\+/?'++$b[$c];':/\-/?'--$b[$c];':/\[/?'while($b[$c]){':/\]/?'}':/>/?'++$c;':/</?'--$c;':/\./?'out;':/\,/?'inp;':'',split//,$bf).'$o;';
  $perl;
}

sub brainfu2perl_optimized {
  my $perl=brainfu2perl(@_);
  $perl=~s{(((\+|\-)\3\$b\[\$c\];){2,})}{ '$b[$c]'.$3.'='.(grep/b/,split//,$1).';' }gisex;
  1 while $perl=~s/\+\+\$c;\-\-\$c;//g + $perl=~s/\-\-\$c;\+\+\$c;//g;
  $perl=~s{((([\-\+])\3\$c;){2,})}{"\$c$3=".(grep/c/,split//,$1).';'}gisex;
  $perl=~s{((\+\+|\-\-)\$c;([^;{}]+;))}{my($o,$s)=($2,$3);$s=~s/\$c/$o\$c/?$s:$1}ge;
  $perl=~s/\$c(\-|\+)=(\d+);(\+\+|\-\-)\$b\[\$c\]/$3.'$b[$c'.$1.'='.$2.'];'/ge;
  $perl=~s{((out;){2,})}{'out('.(grep/o/,split//,$1).');'}ge;
  $perl=~s/;}/}/g;$perl=~s/;+/;/g;
  $perl;
}


=head1 BLOOM FILTER SUBROUTINES

Bloom filters can be used to check whether an element (a string) is a
member of a large set using much less memory or disk space than other
data structures. Trading speed and accuracy for smaller memory usage.
Accepting a few false positives, Bloom filters have a very strong
space advantage over other data structures for representing sets.

In the example below, a set of 100000 phone numbers (or any string of
any length) can be "stored" in just 91230 bytes if you accept that you
can only check the data structure for existence of a string and accept
false positives with an error rate of 0.03 (that is three percent as
rates are given in numbers between 0 and 1). While false positives
will occur, false negatives will not. If the bloom filter says a
string is not in the set, then it's not.

You can not retrieve the strings in the set without using "brute
force" methods and even then you would get slightly more strings
out than you put in because of the error rate inaccuracy.

Bloom Filters have many uses.

See also: L<http://en.wikipedia.org/wiki/Bloom_filter>

See also: L<Bloom::Filter>

=head2 bfinit

Initialize a new Bloom Filter:

  my $bf = bfinit( error_rate=>0.01, capacity=>100000 );

The same:

  my $bf = bfinit( 0.01, 100000 );

Two arguments is interpreted as error_rate and capacity accordingly.

=head2 bfadd

  bfadd($bf, $_) for @phone_numbers;   # Adding strings one at a time

  bfadd($bf, @phone_numbers);          # ...or all at once (faster)

Returns 1 on success or C<die>s (croaks) if more strings than capacity is added.

=head2 bfcheck

  my $phone_number="99999999";
  if ( bfcheck($bf, $phone_number) ) {
    print "Yes, $phone_number was PROBABLY added\n";
  }
  else {
    print "No, $phone_number was DEFINITELY NOT added\n";
  }

Returns true if C<$phone_number> exists in C<@phone_numbers>.

Returns false most of the times, but sometimes true*), if C<$phone_number> doesn't exists in C<@phone_numbers>.

*) This is what is called a false positive.

Checking more than one key:

 @bools = bfcheck($bf, @keys);          # or ...
 @bools = bfcheck($bf, \@keys);         # better, uses less memory if @keys are many

Returns an array the same size as @keys where each element is true or false accordingly.

=head2 bfgrep

Same as C<bfcheck> except it returns the keys that exists in the bloom filter

 @found = bfgrep($bf, @keys);           # or ...
 @found = bfgrep($bf, \@keys);          # uses less memory if @keys are many, or ...
 @found = grep bfcheck($bf,$_), @keys;  # same but slower

=head2 bfgrepnot

Same as C<bfgrep> except it returns the keys that do NOT exists in the bloom filter:

 @not_found = bfgrepnot($bf, @keys);          # or ...
 @not_found = bfgrepnot($bf, \@keys);         # uses less memory if @keys are many, or ...
 @not_found = grep !bfcheck($bf,$_), @keys);  # same but slower

=head2 bfdelete

Deletes from a counting bloom filter.

To enable deleting be sure to initialize the bloom filter with the
numeric C<counting_bits> argument. The number of bits could be 2 or 3*)
for small filters with a small capacity (a small number of keys), but
setting the number to 4 ensures that even very large filters with very
small error rates would not overflow.

*) Acme::Tools do not currently support C<< counting_bits => 3 >> so 4
and 8 are the only practical alternatives where 8 is almost always overkill.

 my $bf = bfinit(
   error_rate    => 0.001,
   capacity      => 10000000,
   counting_bits => 4              # power of 2, that is 2, 4, 8, 16 or 32
 );
 bfadd(   $bf, @unique_phone_numbers);
 bfdelete($bf, @unique_phone_numbers);

Example: examine the frequency of the counters with 4 bit counters and 4 million keys:

 my $bf = bfinit( error_rate=>0.001, capacity=>4e6, counting_bits=>4 );
 bfadd($bf,[1e3*$_+1 .. 1e3*($_+1)]) for 0..4000-1;  # add 4 million keys one thousand at a time
 my %c; $c{vec($$bf{filter},$_,$$bf{counting_bits})}++ for 0..$$bf{filterlength}-1;
 printf "%8d counters = %d\n",$c{$_},$_ for sort {$a<=>$b} keys %c;

The output:

 28689562 counters = 0
 19947673 counters = 1
  6941082 counters = 2
  1608250 counters = 3
   280107 counters = 4
    38859 counters = 5
     4533 counters = 6
      445 counters = 7
       46 counters = 8
        1 counters = 9

Even after the error_rate is changed from 0.001 to a percent of that,
0.00001, the upper limit of counting 0-15 (4 bits) is still far away:

 47162242 counters = 0
 33457237 counters = 1
 11865217 counters = 2
  2804447 counters = 3
   497308 counters = 4
    70608 counters = 5
     8359 counters = 6
      858 counters = 7
       65 counters = 8
        4 counters = 9

In algorithmic terms the number of bits needed is C<ln of ln of n>.  Thats why 4 bits (counters up
to 15) is "always" good enough except for extremely large capasities or extremely small error rates.
(Except when adding the same key many times, which is the users responsibility to avoid as
Acme::Tools::bfadd do not check for that, perhaps in a mode of a future version. In
non-counting bloom filters, for when you don't need delete, you can add the same keys
many times without ruining the filter).

Bloom filters of the counting type are not very space efficient: The tables above shows that 84%-85%
of the counters are 0 or 1. This means most counting bits are zero. This doesn't have to be a problem
if a counting bloom filter is used to be sent over slow networks because they are very compressable by
common tools like I<gzip> or L<Compress::Zlib>.

Deletion of non-existing keys makes C<bfdelete> die (croak).

=head2 bfdelete

Deletes from a counting bloom filter:

 bfdelete($bf, @keys);
 bfdelete($bf, \@keys);

Returns C<$bf> after deletion.

Croaks (dies) on deleting a non-existing key or deleting from a previouly overflown counter in a counting bloom filter.

=head2 bfaddbf

Adds another bloom filter to a bloom filter.

Bloom filters has the proberty that bit-wise I<OR>-ing the bit-filters
of two filters with the same capacity and the same number and type of
hash functions, adds the filters:

  my $bf1=bfinit(error_rate=>0.01,capacity=>$cap,keys=>[1..500]);
  my $bf2=bfinit(error_rate=>0.01,capacity=>$cap,keys=>[501..1000]);

  bfaddbf($bf1,$bf2);     # bf1 = bf1 + bf2

  print "Yes!" if bfgrep($bf1, 1..1000) == 1000;  #prints Yes!

Prints yes since C<bfgrep> now returns an array of all the 1000 elements.

Croaks if the filters are of different dimensions and properties.

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

Is the same as:

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

...except that bfretrieve/bfinit/new will C<warn> (carp) if the stored filter was created
with an earlier version of Acme::Tools. (Todo: only C<warn> or C<die> rather when the new
version has actually broken backwards compatibility. Most new versions do not and might never do.
Todo2: backwards compatibility in versions of Storable should also be checked)

=head2 bfclone

Deep copies the bloom filter data structure. (Which btw is not very deep, two levels at most)

This:

 my $bfc = bfclone($bf);

Is the same as:

 my $bfc=Storable::dclone($bf);

=head2 Object oriented interface to bloom filters

 use Acme::Tools;
 my $bf=new Acme::Tools::BloomFilter(0.1,1000); # the same as bfinit, see bfinit above
 print ref($bf),"\n";                           # prints Acme::Tools::BloomFilter
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

 time perl -e'use Digest::MD5 qw(md5);md5("asdf$_")       for 1..1e7' #5.56 sec
 time perl -e'use String::CRC32;crc32("asdf$_")           for 1..1e7' #2.79 sec, faster but not per bit
 time perl -e'use Digest::SHA qw(sha512);sha512("asdf$_") for 1..1e7' #36.10 sec, too slow (sha1, sha224, sha256 and sha384 too)

MD5 seems to be an ok choice both for speed and avoiding collitions due to skewed data keys.

=head2 Theory and math on bloom filters

L<http://www.internetmathematics.org/volumes/1/4/Broder.pdf>

L<http://blogs.sun.com/jrose/entry/bloom_filters_in_a_nutshell>

L<http://pages.cs.wisc.edu/~cao/papers/summary-cache/node8.html>

See also Scaleable Bloom Filters for when you don't know the capacity in advance: L<http://gsd.di.uminho.pt/members/cbm/ps/dbloom.pdf> (not implemented in Acme::Tools)

...and perhaps L<http://intertrack.naist.jp/Matsumoto_IEICE-ED200805.pdf>

=cut

sub bfinit {
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
  croak "Not implemented counting_bits=$arg{counting_bits}, should be 2, 4, 8, 16 or 32" if !in(nvl($arg{counting_bits},1),1,2,4,8,16,32);
  croak "A bloom filters here can not be in both adaptive and counting_bits modes" if $arg{adaptive} and $arg{counting_bits}>1;
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
sub bfadd {
  require Digest::MD5;
  my($bf,@keys)=@_;
  return if !@keys;
  my $keysref=@keys==1 && ref($keys[0]) eq 'ARRAY' ? $keys[0] : \@keys;
  my($m,$k,$up,$n,$cb,$adaptive)=@$bf{'filterlength','hashfuncs','unpack','capacity','counting_bits','adaptive'};
  for(@$keysref){
    #croak "Key should be scalar" if ref($_);
    $$bf{key_count} >= $n and croak "Exceeded filter capacity $n"  or  $$bf{key_count}++;
    my @h; push @h, unpack $up, Digest::MD5::md5($_,0+@h) while @h<$k;
    if ($cb==1 and !$adaptive) { # normal bloom filter
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
	$i+=push(@h, unpack $up, Digest::MD5::md5($key,$i)) if !@h;
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
sub bfcheck {
  require Digest::MD5;
  my($bf,@keys)=@_;
  return if !@keys;
  my $keysref=@keys==1 && ref($keys[0]) eq 'ARRAY' ? $keys[0] : \@keys;
  my($m,$k,$up,$cb,$adaptive)=@$bf{'filterlength','hashfuncs','unpack','counting_bits','adaptive'};
  my $wa=wantarray();
  if(!$adaptive){    # normal bloom filter  or  counting bloom filter
    return map {
      my $match = 1; # match if every bit is on
      my @h; push @h, unpack $up, Digest::MD5::md5($_,0+@h) while @h<$k;
      vec($$bf{filter}, $h[$_] % $m, $cb) or $match=0 or last for 0..$k-1;
      return $match if !$wa;
      $match;
    } @$keysref;
  }
  else {             # adaptive bloom filter
    return map {
      my($match,$i,$key,$bit,@h)=(1,0,$_);
      for(0..$$bf{filterlength}-1){
	$i+=push(@h, unpack $up, Digest::MD5::md5($key,$i)) if !@h;
	my $pos=shift(@h) % $m;
	$bit=vec($$bf{filter}, $pos, 1);
	$match++ if $_ >  $k-1 and $bit==1;
	$match=0 if $_ <= $k-1 and $bit==0;
	last     if $bit==0;
      }
      return $match if !$wa;
      $match;
    } @$keysref;
  }
}
sub bfgrep { # just a copy of bfcheck with map replaced by grep
  require Digest::MD5;
  my($bf,@keys)=@_;
  return if !@keys;
  my $keysref=@keys==1 && ref($keys[0]) eq 'ARRAY' ? $keys[0] : \@keys;
  my($m,$k,$up,$cb)=@$bf{'filterlength','hashfuncs','unpack','counting_bits'};
  return grep {
    my $match = 1; # match if every bit is on
    my @h; push @h, unpack $up, Digest::MD5::md5($_,0+@h) while @h<$k;
    vec($$bf{filter}, $h[$_] % $m, $cb) or $match=0 or last for 0..$k-1;
    $match;
  } @$keysref;
}
sub bfgrepnot { # just a copy of bfgrep with $match replaced by not $match
  require Digest::MD5;
  my($bf,@keys)=@_;
  return if !@keys;
  my $keysref=@keys==1 && ref($keys[0]) eq 'ARRAY' ? $keys[0] : \@keys;
  my($m,$k,$up,$cb)=@$bf{'filterlength','hashfuncs','unpack','counting_bits'};
  return grep {
    my $match = 1; # match if every bit is on
    my @h; push @h, unpack $up, Digest::MD5::md5($_,0+@h) while @h<$k;
    vec($$bf{filter}, $h[$_] % $m, $cb) or $match=0 or last for 0..$k-1;
    !$match;
  } @$keysref;
}
sub bfdelete {
  require Digest::MD5;
  my($bf,@keys)=@_;
  return if !@keys;
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
sub bfstore {
  require Storable;
  Storable::store(@_);
}
sub bfretrieve {
  require Storable;
  my $bf=Storable::retrieve(@_);
  carp "Retrieved bloom filter was stored in version $$bf{version}, this is version $VERSION"
    if $$bf{version} > $VERSION;
  return $bf;
}
sub bfclone {
  require Storable;
  return Storable::dclone(@_); #could be faster
}
sub bfdimensions_old {
  my($n,$p,$mink,$maxk, $k,$flen,$m)=
    @_==1 ? (@{$_[0]}{'capacity','error_rate','min_hashfuncs','max_hashfuncs'},1)
   :@_==2 ? (@_,1,100,1)
          : croak "Wrong number of arguments (".@_."), should be 2";
  croak "p ($p) should be > 0 and < 1" if not ( 0<$p && $p<1 );
  $m=-1*$_*$n/log(1-$p**(1/$_)) and (!defined $flen or $m<$flen) and ($flen,$k)=($m,$_) for $mink..$maxk;
  $flen = int(1+$flen);
  return ($flen,$k);
}
sub bfdimensions {
  my($n,$p,$mink,$maxk)=
    @_==1 ? (@{$_[0]}{'capacity','error_rate','min_hashfuncs','max_hashfuncs'})
   :@_==2 ? (@_,1,100)
          : croak "Wrong number of arguments (".@_."), should be 2";
  my $k=log(1/$p)/log(2);           # k hash funcs
  my $m=-$n*log($p)/log(2)**2;      # m bits in filter
  return ($m+0.5,min($maxk,max($mink,int($k+0.5))));
}

#crontab -e
#01 4,10,16,22 * * * /usr/bin/perl -MAcme::Tools -e'Acme::Tools::_update_currency_file("/var/www/html/currency-rates")' > /dev/null 2>&1

sub _update_currency_file { #call from cron
  my $fn=shift()||'/var/www/html/currency-rates';
  my %exe=map+($_=>"/usr/bin/$_"),qw/curl ci/;-x$_ or croak for values %exe;
  open my $F, '>', $fn or die"ERROR: Could not write file $fn ($!)\n";
  print $F "#-- Currency rates ".localtime()." (".time().")\n";
  print $F "#   File generated by Acme::Tools version $VERSION\n";
  print $F "#   Updated every 6th hour on http://calthis.com/currency-rates\n";
  print $F "NOK 1.000000000\n";
  my $amount=1000;
  my $data=qx($exe{curl} -s "https://www.x-rates.com/table/?from=NOK&amount=$amount");
  $data=~s,to=([A-Z]{3})(.)>,$2>$1</td><td>,g;
  my @data=ht2t($data,"Alphabetical order"); shift @data;
  @data=map "$$_[1] ".($$_[4]>1e-2?$$_[4]:$$_[2]?sprintf("%.8f",$amount/$$_[2]):0)."\n",@data;
  my %data=map split,@data;
  my $json=qx( $exe{curl} -s https://api.coinmarketcap.com/v1/ticker/ );
  eval "require JSON;"; croak if $@;
  my $arr=JSON::decode_json($json);
  for my $c (qw(BTC LTC XBT ETH XRP BCH ETC)) {
      my @a=grep$$_{symbol} eq $c,@$arr;
      next if @a != 1 or !$a[0]{price_usd};
      push @data, "$c ".($a[0]{price_usd}*$data{USD})."\n";
  }
  #die srlz(\@data,'data');
  print $F sort(@data);
  close($F);
  qx($exe{ci} -l -m. -d $fn) if -w"$fn,v";
}

sub ftype {
  my $f=shift;
  -e $f and
      -f$f ? 'file'         # -f  File is a plain file.
     :-d$f ? 'dir'          # -d  File is a directory.
     :-l$f ? 'symlink'      # -l  File is a symbolic link.
     :-p$f ? 'pipe'         # -p  File is a named pipe (FIFO), or Filehandle is a pipe.
     :-S$f ? 'socket'       # -S  File is a socket.
     :-b$f ? 'blockfile'    # -b  File is a block special file.
     :-c$f ? 'charfile'     # -c  File is a character special file.
     :-t$f ? 'ttyfile'      # -t  Filehandle is opened to a tty.
     :       ''
  or undef;
}

sub ext2mime {
  my $ext=shift(); #or filename
  #http://www.sitepoint.com/web-foundations/mime-types-complete-list/
  croak "todo: ext2mime not yet implemented";
  #return "application/json";#feks
}

sub base64 ($;$) { #
  if ($] >= 5.006) {
    require bytes;
    croak "base64 failed: only defined for bytes"
      if bytes::length($_[0]) > length($_[0])
      or $] >= 5.008 && $_[0] =~ /[^\0-\xFF]/
  }
  my $eol=defined$_[1]?$_[1]:"\n";
  my $res=pack("u",$_[0]);
  $res=~s/^.//mg;
  $res=~s/\n//g;
  $res=~tr|` -_|AA-Za-z0-9+/|;
  my $pad=(3-length($_[0])%3)%3;
  $res=~s/.{$pad}$/'=' x $pad/e if $pad;
  $res=~s/(.{1,76})/$1$eol/g if length($eol); #todo !=76
  $res;
}

our $Fix_unbase64=0;
sub unbase64 ($) {
  my $s=shift;
  $s=~tr,0-9a-zA-Z+=/,,cd;
  if($Fix_unbase64){ $s.='=' while length($s)%4 }
  croak "unbase64 failed: length ".length($s)." not multiple of 4" if length($s)%4;
  $s=~s/=+$//;
  $s=~tr|A-Za-z0-9+/| -_|;
  length($s) ? unpack("u",join'',map(chr(32+length($_)*3/4).$_,$s=~/(.{1,60})/gs)) : "";
}


=head1 COMMANDS

=head2 install_tools

=head2 install_acme_command_tools

 sudo perl -MAcme::Tools -e install_tools

 Wrote executable /usr/local/bin/conv
 Wrote executable /usr/local/bin/due
 Wrote executable /usr/local/bin/xcat
 Wrote executable /usr/local/bin/freq
 Wrote executable /usr/local/bin/deldup
 Wrote executable /usr/local/bin/ccmd
 Wrote executable /usr/local/bin/z2z
 Wrote executable /usr/local/bin/2gz
 Wrote executable /usr/local/bin/2gzip
 Wrote executable /usr/local/bin/2bz2
 Wrote executable /usr/local/bin/2bzip2
 Wrote executable /usr/local/bin/2xz
 Wrote executable /usr/local/bin/resubst

Examples of commands then made available:

 conv 1 USD EUR                #might show 0.88029 if thats the current currency rate. Uses conv()
 conv .5 in cm                 #reveals that 1/2 inch is 1.27 cm, see doc on conv() for all supported units
 due [-h] /path/1/ /path/2/    #like du, but show statistics on file extentions instead of subdirs
 xcat file                     #like cat, zcat, bzcat or xzcat in one. Uses file extention to decide. Uses openstr()
 freq file                     #reads file(s) or stdin and view counts of each byte 0-255
 ccmd grep string /huge/file   #caches stdout+stderr for 15 minutes (default) for much faster results later
 ccmd "sleep 2;echo hello"     #slow first time. Note the quotes!
 ccmd "du -s ~/*|sort -n|tail" #ccmd store stdout+stderr in /tmp files (default)
 z2z [-pvk1-9oe -t type] files #convert from/to .gz/bz2/xz files, -p progress, -v verbose (output result),
                               #-k keep org file, -o overwrite, 1-9 compression degree, -e for xz does "extreme"
                               #compressions, very slow. For some data types this reduces size significantly
                               #2xz and 2bz2 depends on xz and bzip2 being installed on system
 2xz                           #same as z2z with -t xz
 2bz2                          #same as z2z with -t bz2
 2gz                           #same as z2z with -t gz

 rttop
 wipe file(s)

=head3 z2z

=head3 2xz

=head3 2bz2

=head3 2gz

The commands C<2xz>, C<2bz2> and C<2gz> are just synonyms for C<z2z> with an implicitly added option C<-t xz>, C<-t xz> or C<-t gz> accordingly.

 z2z [-p -k -v -o -1 -2 -3 -4 -5 -6 -7 -8 -9 ] files

Converts (recompresses) files from one compression type to another. For instance from .gz to .bz2
Keeps uid, gid, mode (chmod) and mtime.

 -p              Show a progress meter using the pv program if installed
 -k              Keeps original file
 -v              Verbose, shows info on degree of compression and file
                 number if more than one file is being converted
 -o              Overwrites existing result file, otherwise stop with error msg
 -1 .. -9        Degree of compression, -1 fastest .. -9 best
 -e              With 2xz (or z2z -t xz) passes -e to xz
                 (-9e = extreme compression and extremly slow and memory hungry)

 -L rate         With -p. Slow down, ex:  -L 200K  means 200 kilobytes per second
 -D sec          With -p. Only turn on progress meter (pv) after x seconds
 -i sec          With -p. Info update rate
 -l              With -p. Line mode
 -I              With -p. Show ETA as time of arrival as well as time left
 -q              With -p. Quiet. Useful with -L to limit rate, but no output

The options -L -D -i -l -I -q implicitly turns on -p and -q for pv unless -p
(with or without -q is used). Those options are passed on to pv. See: C<man pv>

Examples:

Slowly turn .gz files into probably smaller .xz files while keeping times and ownerskip of files.
The -L 100K (or lower) slows down the compression and cpu usage (i.e. to not start a laptop fan)

 2xz -pvL 100K big_files*.gz 
 2xz -pvkL 100K big_files*.gz  #same but -k keep the original .gz files
 2xz -9pv big_files*.xz        #convert already .xz files with maybe tighter compression (level 9)

=head3 due

Like C<du> command but views space used by file extentions instead of dirs. Options:

 due [-options] [dirs] [files]
 due -?          todo: show this help
 due -h          View bytes "human readable", i.e. C<8.72 MB> instead of C<9145662 b> (bytes)
 due -k | -m     View bytes in kilobytes | megabytes (1024 | 1048576)
 due -K          Like -k but uses 1000 instead of 1024
 due -z          View two extentions if .z .Z .gz .bz2 .rz or .xz (.tar.gz, not just .gz)
 due -M          Also show min, medium and max date (mtime) of files, give an idea of their age
 due -C          Like -M, but create time instead (ctime)
 due -A          Like -M, but access time instead (atime)
 due -P          Also show 10, 50 (medium) and 90 percentile of file date
 due -MP         Both -M and -P, shows min, 10p, 50p, 90p and max
 due -a          Sort output alphabetically by extention (default order is by size)
 due -c          Sort output by number of files
 due -i          Ignore case, .GZ and .gz is the same, output in lower case
 due -t          Adds time of day to -M and -P output
 due -e 'regex'  Exclude files (full path) matching regex. Ex: due -e '\.git'
 TODO: due -l    TODO: Exclude hardlinks (dont count "same" file more than once, "man du")
 TODO: -S        TODO: exclude for sparse files (like 'du')
 ls -l | due     Parses output of ls -l, find -ls, tar tvf for size+filename and reports
 find | due      List of filenames from stdin produces same as just command 'due'
 ls | due        Reports on just files in current dir without recursing into subdirs

=head3 finddup

Finds duplicate files. Does this in three steps to speed this up in case of
many large files:

=over 4

=item step 1: collect files of the same size as files of different size can never be duplicates (share the same content)

=item step 2: among those found in the previous step, find files with the same first 8 kilobytes (or the same n bytes if -P n is used as option)

=item step 3: among those found in the previos step, find those files who share the same md5sum of the whole files. Those are deemed to be duplicates.

=back

 finddup [-d -s -h] paths/ files/* ...  #reports (+deletes with -d) duplicate files
                                        #-s for symlinkings dups, -h for hardlink
 finddup <files>        # print duplicate files, <files> might be filenames and directories
 finddup -a <files>     # print duplicate files, also print the first file
 finddup -d <files>     # delete duplicate files, use -v to also print them before deletion
 finddup -s <files>     # make symbolic links of duplicate files
 finddup -h <files>     # make hard links of duplicate files
 finddup -v ...         # verbose, print before -d, -s or -h
 finddup -n -d <files>  # dry run: show rm commands without actually running them
 finddup -n -s <files>  # dry run: show ln commands to make symlinks of duplicate files TODO: need fix!
 finddup -n -h <files>  # dry run: show ln commands to make hard links of duplicate files
 finddup -q ...         # quiet
 finddup -k o           # keep oldest with -d -s -h, consider the newer files to be the duplicates
 finddup -k n           # keep newest with -d -s -h, consider the older files to be the duplicates
 finddup -k O           # same as -k o, just use access time instead of modify time
 finddup -k N           # same as -k n, just use access time instead of modify time
 finddup -k s | l       # keep file with shortest | longest basename (filename), i.e. ...(1).txt
 finddup -k a | z       # keep file (basename) alphanumerically sorted first | last
 finddup -e <h|s>+      # TODO: exclude hardlinks|softlinks from being found
 finddup -0 ...         # use ascii 0 instead of the normal \n, for xargs -0
 finddup -P n           # use n bytes from start of file in 1st md5 check (default 8192)
 finddup -m method      # TODO: method is all, md5 or sha256, default is md5
                        # sha256 is slower but safer, different files can be
                        # found to share the same MD5, but as of yet in 2020
                        # no such collisions are known for SHA256
 finddup -L rate        # TODO: uses `pv -L` to rate limit in (full?) file scans
 finddup -S sec         # TODO: sleep seconds between each full file scan
 finddup -3 | -2 | -1   # check up to step 1, 2 or 3 (default 3)
 finddup -p             # view progress in last and slowest of the three steps
 finddup -z             # TODO: skip zero sized files
 finddup                # TODO: without args, show this help

Default ordering of files without C<-k n> or C<-k o> is the order they
are mentioned on the command line. For directory args the order might be
random: use C<< dir/* >> to avoid that (but then dot files are not included).

Examples:

 finddup . | due -h  # see disk space that can be freed by deleting duplicates or by turning them into soft or hard links
 finddup -d .        # delete duplicates
 finddup -v -d dir/  # delete and view duplicates in dir/
 finddup -d *jpg     # delete duplicates among *jpg files in current dir
 finddup -0ko . | xargs -0 rm -i
                     #answer y/n to delete each file or not, 0 for problematic filenames, ko=keep oldest

=cut

#hm http://manpages.ubuntu.com/manpages/trusty/man1/rdfind.1.html  apt install rdfind      # rdfind - finds duplicate files

sub install_tools {install_acme_command_tools()}
sub install_acme_command_tools {
  my $dir=(grep -d$_, @_, '/usr/local/bin', '/usr/bin')[0];
  for( qw( conv due xcat freq finddup ccmd wipe rttop  z2z 2gz 2gzip 2bz2 2bzip2 2xz resubst zsize) ){
    unlink("$dir/$_");
    writefile("$dir/$_", "#!$^X\nuse Acme::Tools;\nAcme::Tools::cmd_$_(\@ARGV);\n");
    sys("/bin/chmod +x $dir/$_"); #hm umask
    print "Wrote executable $dir/$_\n";
  }
}
sub cmd_conv { print conv(@ARGV)."\n"  }
our @Due_fake_stdin;
#TODO: output from tar tvf and ls and find -ls
sub cmd_due {
  my %o;
  my @argv=opts("zkKmhciMCAPate:lE:t",\%o,@_);
  require File::Find;
  no warnings 'uninitialized';
  die"$0: -l not implemented yet\n"                if $o{l}; #man du: default is not to count hardlinks more than once, with -l it does
  die"$0: -h, -k or -m can not be used together\n" if $o{h}+$o{k}+$o{m}>1;
  die"$0: -c and -a can not be used together\n"    if $o{a}+$o{c}>1;
  die"$0: -k and -m can not be used together\n"    if $o{k}+$o{m}>1;
  die"$0: -M, -C, -A can not be used together\n"   if $o{M}+$o{C}+$o{A}>1;
  my(%c,%b,$cnt,$bts,%xtime);
  my $zext=$o{z}?'(\.(z|Z|gz|bz2|xz|rz|kr|lrz|rz))?':'';
  $o{E}||=11;
  my $r=qr/(\.[^\.\/]{1,$o{E}}$zext)$/i;
  my $qrexcl=exists$o{e}?qr/$o{e}/:0;
  #TODO: ought to work: tar cf - .|tar tvf -|due
  my $x=$o{M}?9:$o{C}?10:$o{A}?8:9;
  if(-p STDIN or @Due_fake_stdin){
    die "due: can not combine STDIN and args\n" if @argv;
    my $stdin=join"",map"$_\n",@Due_fake_stdin; #test
    open(local *STDIN, '<', \$stdin) or die "ERR: $! $?\n" if $stdin;
    my $rl=qr/(^| )\-[rwx\-sS]{9}\s+(?:\d )?(?:[\w\-]+(?:\/|\s+)[\w\-]+)\s+(\d+)\s+.*?([^\/]*\.[\w,\-]+)?$/;
    my $MorP=$o{M}||$o{C}||$o{A}||$o{P}?"due: -M, -C, -A and -P not yet implemented for STDIN unless list of filenames only\n":0;
    while(<STDIN>){
      chomp;
      next if /\/$/;
      my($f,$sz,$xtime)=(/$rl/?($3,$2):-f$_?($_,(stat)[7,$x]):next);
      #   1576142    240 -rw-r--r--   1 root     root       242153 april  4  2016 /opt/wine-staging/share/wine/wine.inf
      my $ext=$f=~$r?$1:'';
      $ext=lc($ext) if $o{i};
      $cnt++;    $c{$ext}++;
      $bts+=$sz; $b{$ext}+=$sz;
      defined $xtime and $xtime{$ext}.=",$xtime" or die $MorP if $MorP;
    }
  }
  else { #hm DRY
    @argv=('.') if !@argv;
    File::Find::find({follow=>0, wanted =>
      sub {
        return if !-f$_;
        return if $qrexcl and defined $File::Find::name and $File::Find::name=~$qrexcl;
        my($sz,$xtime)=(stat($_))[7,$x];
        my $ext=m/$r/?$1:'';
        $ext=lc($ext) if $o{i};
        $cnt++;    $c{$ext}++;
        $bts+=$sz; $b{$ext}+=$sz;
        $xtime{$ext}.=",$xtime" if $o{M} || $o{C} || $o{A} || $o{P};
	1;
      } },@argv);
  }
  my($f,$s)=$o{k}?("%14.2f kb",sub{$_[0]/1024})
           :$o{K}?("%14.2f Kb",sub{$_[0]/1000})
           :$o{m}?("%14.2f mb",sub{$_[0]/1024**2})
           :$o{h}?("%14s",     sub{bytes_readable($_[0])})
           :      ("%14d b",   sub{$_[0]});
  my @e=$o{a}?(sort(keys%c))
       :$o{c}?(sort{$c{$a}<=>$c{$b} or $a cmp $b}keys%c)
       :      (sort{$b{$a}<=>$b{$b} or $a cmp $b}keys%c);
  my $perc=!$o{M}&&!$o{C}&&!$o{A}&&!$o{P}?sub{""}:
    sub{
      my @p=$o{P}?(10,50,90):(50);
      my @m=@_>0 ? do {grep$_, split",", $xtime{$_[0]}}
                 : do {grep$_, map {split","} values %xtime};
      my @r=percentile(\@p,@m);
      @r=(min(@m),@r,max(@m)) if $o{M}||$o{C}||$o{A};
      @r=map int($_), @r;
      my $fmt=$o{t}?'YYYY/MM/DD-MM:MI:SS':'YYYY/MM/DD';
      @r=map tms($_,$fmt), @r;
      "  ".join(" ",@r);
  };
  my $width=max( 10, grep $_, map length($_), @e );
  @e=@e[-10..-1] if $o{t} and @e>10; #-t tail
  printf("%-*s %8d $f %7.2f%%%s\n",$width,$_,$c{$_},&$s($b{$_}),100*$b{$_}/$bts,&$perc($_)) for @e;
  printf("%-*s %8d $f %7.2f%%%s\n",$width,"Sum",$cnt,&$s($bts),100,&$perc());
}
sub cmd_resubst {
  my %o;
  my $zo="123456789e";
  my @argv=opts("f:t:vno:gi$zo",\%o,@_);
  if(exists$o{t}){ $o{t}=~s,\\,\$, } else { $o{t}='' }
  my($i,$tc,$tbfr,$tbto)=(0,0,0,0);
  for my $file (@argv){
      my $zopt=join" ",map"-$_",grep$o{$_},split//,$zo;
      my $oext=$o{o}?$o{o}:$file=~/\.(gz|bz2|xz)$/i?$1:'';
      my $open_out_pre=$oext?"|".openstr_prog({qw/gz gzip bz2 bzip2 xz xz/}->{lc($oext)})." $zopt":'';
      my $open_out="$open_out_pre > $file.tmp$$";
      my $open_in=openstr($file);
      #      die srlz(\%o,'o','',1);
      open my $I, $open_in  or croak"ERR: open $open_in failed. $! $?\n";
      open my $O, $open_out or croak"ERR: open $open_out failed. $! $?\n";
      my $c=0;
      my $mod=join"",grep$o{$_},qw(g i);
      eval"while(<\$I>){ \$c+=s/\$o{f}/$o{t}/$mod;print \$O \$_ }";
      $tc+=$c;
      close($I);close($O);
      chall($file,"$file.tmp$$") or croak"ERR: chall $file\n" if !$o{n};
      my($bfr,$bto)=(-s$file,-s"$file.tmp$$");
      unlink $file or croak"ERR: cant rm $file\n";
      my $newfile=$o{o}?repl($file,qr/\.(gz|bz2|xz)$/i,".$oext"):$file;
      rename("$file.tmp$$",$newfile) or croak"ERR: rename $file.tmp$$ -> $newfile failed\n";
      if($o{v}){
	my $pr=$bfr?100*$bto/$bfr:0;
	printf "%*d/%d %*s %7d =>%8d b (%2d%%) %s\n",
	  length(0+@argv), ++$i, 0+@argv, -15, "$tc/$c", $bfr, $bto, $pr, $file;
	$tbfr+=$bfr;
	$tbto+=$bto;
      }
  }
  if($o{v} and @argv>1){
      printf "Replaces: %d  Bytes before: %d  After: %d   Change: %.1f%%\n",
        $tc, $tbfr, $tbto, $tbfr?100*($tbto-$tbfr)/$tbfr:0
  }
  $tc;
}
sub cmd_xcat {
  for my $fn (@_){
    my $os=openstr($fn);
    open my $FH, $os or warn "xcat: cannot open $os ($!)\n" and next;
    #binmode($FH);#hm?
    print while <$FH>;
    close($FH);
  }
}
sub cmd_freq {
  my%o; #my @argv=opts("H",\%o,@_);
  if($ARGV[0] eq '-H'){$o{H}++;shift@ARGV}
  my(@f,$i);
  map $f[$_]++, unpack("C*",$_) while <>; #todo: fix "out of memory" (for large files without \n)
  my @b=grep$f[$_],0..255;
  my $c=$^O eq 'linux'?`tput cols`||75:75; $c=min(int(($c+10)/(18+10)),0+@b);
  my $s=" " x 10; map{print join($s,($_)x$c),"\n"}("BYTE  CHAR   COUNT","---- ----- -------"); #len 18
  my %m=(145,"DOS-æ",155,"DOS-ø",134,"DOS-å",146,"DOS-Æ",157,"DOS-Ø",143,"DOS-Å",127,'DEL  ',map{($_," ")}0..31);
  my $fmt=$o{H}?"%02X   %5s%8d":"%4d %5s%8d";
  printf($fmt.(++$i%$c?$s:"\n"),$_,$m{$_}||chr,$f[$_]) for @b; print"\n";
  my @no; @no&&$no[-1][-1]+1==$_?push(@{$no[-1]},$_):push(@no,[$_]) for grep!$f[$_],0..255;
  my $info=@no?"No bytes of: ".join(",",map @$_>1?"$$_[0]-$$_[-1]":$$_[0],@no)
              :"All bytes 0-255 are found";
  $info=~s/\d+/sprintf"%02X",$&/ge if $o{H};
  print"$info\n";  
}
sub cmd_deldup {
  cmd_finddup('-d',@_);
}
sub cmd_finddup {
  # http://www.commandlinefu.com/commands/view/3555/find-duplicate-files-based-on-size-first-then-md5-hash
  # die "todo: finddup not ready yet"
  my %o;
  my @argv=opts("ak:dhsnqv0P:FRp123z",\%o,@_); $o{P}=1024*8 if!defined$o{P}; $o{k}='' if!defined$o{k};
  croak"ERR: cannot combine -a with -d, -s or -h" if $o{a} and $o{d}||$o{s}||$o{h};
  croak"ERR: cannot combine -1, -2 or -3" if 1<grep$o{$_},1..3;
  require File::Find;
  @argv=map{
      my @f;
      if(-d$_){ File::Find::find({follow=>0,wanted=>sub{return if !-f$_;push@f,$File::Find::name;1}},$_) }
      else    { @f=($_) }
      @f;
  }@argv;
  @argv=grep -s$_, @argv if $o{z};
  my %md5sum;
 #my $md5sum=sub{$md5sum{$_[0]}//=md5sum($_[0])}; #memoize //= is v5.10 and later
  my $md5sum=sub{$md5sum{$_[0]}=md5sum($_[0]) if!defined$md5sum{$_[0]};$md5sum{$_[0]}}; #memoize
  my $md5sum_1st_part=sub{
      open my $fh, "<", $_[0] or die "ERR: Could not read $_[0]";
      binmode($fh);
      my $buf; read($fh,$buf,$o{P});
      close($fh);
      md5sum(\$buf);
  };
  my @checks=( #todo: stat()[0,1] (or[0,1,7]?) and diff filename => no need for md5, is hardlink! just linux?
      sub{-s$_[0]},
      sub{-s$_[0]<=$o{P}?md5sum($_[0]):&$md5sum_1st_part($_[0])},
      sub{md5sum($_[0])}
  );
  splice@checks,$o{1}?1:$o{2}?2:3;
  my $i=0;
  my %s=map{($_=>++$i)}@argv; #sort
  my %f=map{($_=>[$_])}@argv; #also weeds out dupl params
  for my $c (@checks){
    my @f=map @{$f{$_}}, sort keys %f;
    if($o{p} and $c eq $checks[-1]){ #view progress for last check, todo: eta() is wacky here! everywhere?
      my $sum=@f?sum(map -s$_,@f):0;
      my($corg,$cnt,$cntmb,$mb)=($c,0,0,$sum/1e6);
      $c=sub{
	  $cntmb+=(-s$_[0])/1e6;
	  my $eol=++$cnt==@f?"\n":"\r";
	  print STDERR sprintf("%d/%d files checked (%d%%), %d/%d MB (%d%%), ETA in %d sec       $eol",
			       $cnt, 0+@f, 100*$cnt/@f, $cntmb, $mb, 100*$cntmb/$mb,
			       curb(nvl(eta($cnt,0+@f),time)-time(),0,1e7));
	  &$corg(@_)
      };
    }
    my %n; push @{$n{&$c($_)}}, $_ for @f;
    delete @n{grep@{$n{$_}}<2,keys%n};
    %f=%n;
  }
  return %f if $o{F};
  my@r=sort{$s{$$a[0]}<=>$s{$$b[0]}}values%f;
  my $si={qw(o 9 n 9 O 8 N 8)}->{$o{k}}; #stat index: 9=mtime, 8=atime
  my $sort=lc$o{k} eq 'o' ? sub{sprintf"%011d%9d",     (stat($_[0]))[$si]     ,$s{$_[0]}}
          :lc$o{k} eq 'n' ? sub{sprintf"%011d%9d",1e11-(stat($_[0]))[$si]     ,$s{$_[0]}}
          :  $o{k} eq 's' ? sub{sprintf"%011d%9d",     length(basename($_[0])),$s{$_[0]}}
          :  $o{k} eq 'l' ? sub{sprintf"%011d%9d",1e11-length(basename($_[0])),$s{$_[0]}}
          :  $o{k} eq 'a' ? sub{sprintf"%-1000s%9d", basename($_[0]),          $s{$_[0]}}
          :  $o{k} eq 'z' ? sub{sprintf"%-1000s%9d", basename($_[0]),      9e8-$s{$_[0]}}
          :                 sub{sprintf     "%9d",                             $s{$_[0]}};
  if($o{k} eq 'z'){  @$_=map$$_[1],sort{$$b[0]cmp$$a[0]}map[&$sort($_),$_],@$_ for @r }
  else            {  @$_=map$$_[1],sort{$$a[0]cmp$$b[0]}map[&$sort($_),$_],@$_ for @r }

  my %of; #dup of
  for my $r (@r){
      $of{$_}=$$r[0] for @$r[1..$#$r];
  }
  my $nl=$o{0}?"\x00":"\n";
  my $print=sub{$o{q} or print $_[0]};
  my $do=sub{ $o{v} && &$print("$_[0]$nl"); qx($_[0]) };
  my $go=sub{ $o{n} ? &$print("$_[0]$nl") : &$do($_[0]) };
  &$print(join$nl,map join("",map"$_$nl",@$_),@r) and return if $o{a};
  @r=map@$_[1..$#$_],@r;
  return @r if $o{R}; #hm
  unlink@r                              if $o{d}||$o{s}||$o{h} and !$o{n}; #delete duplicates
  map &$go(qq(rm "$_")             ),@r if $o{d}&& $o{n}; #delete duplicates, dryrun
  map &$go(qq(ln    "$of{$_}" "$_")),@r if $o{h}; #replace duplicates with hardlink
  map &$go(qq(ln -s "$of{$_}" "$_")),@r if $o{s}; #replace duplicates with symlink,
                                                  #todo: BUG! abc/def/file -> ghi/file should be abc/def/file -> ../../ghi/file
  return if $o{q} or $o{n};    #quiet or dryrun
  &$print("$_$nl") for @r;
}
#http://stackoverflow.com/questions/11900239/can-i-cache-the-output-of-a-command-on-linux-from-cli
our $Ccmd_cache_dir='/tmp/acme-tools-ccmd-cache';
our $Ccmd_cache_expire=15*60;  #default 15 minutes
sub cmd_ccmd {
  require Digest::MD5;
  my $cmd=join" ",@_;
  my $d="$Ccmd_cache_dir/".username();
  makedir($d);
  my $md5=Digest::MD5::md5_hex($cmd);
  my($fno,$fne)=map"$d/cmd.$md5.std$_","out","err";
  my $too_old=sub{time()-(stat(shift))[9] >= $Ccmd_cache_expire};
  unlink grep &$too_old($_), <$d/*.std???>;
  sys("($cmd) > $fno 2> $fne") if !-e$fno or &$too_old($fno);
  print STDOUT "".readfile($fno);
  print STDERR "".readfile($fne);
}

#todo:   wipe -n 4 filer*   #virker ikke! tror det er args() eller opts() som ikke virker
sub cmd_wipe  {
  my %o;
  my @argv=opts("n:k0123456789p",\%o,@_);
  die if 1<grep exists$o{$_},'n',0..9;
  $o{$_} and $o{n}=$_ for 0..9;
  wipe($_,$o{n},$o{k},$o{p}) for @argv;
}

sub which { my $prog=shift; -x "$_/$prog" and return "$_/$prog" for split /:/, $ENV{PATH} }

sub cmd_2gz    {cmd_z2z("-t","gz", @_)}
sub cmd_2gzip  {cmd_z2z("-t","gz", @_)}
sub cmd_2bz2   {cmd_z2z("-t","bz2",@_)}
sub cmd_2bzip2 {cmd_z2z("-t","bz2",@_)}
sub cmd_2xz    {cmd_z2z("-t","xz", @_)}
#todo: sub cmd_7z
#todo: .tgz same as .tar.gz (but not .tbz2/.txz)
#todo:
#  2xz -9pvkL 100K big_fat_file.tar.gz  # -L100K for slow compress (ie dont start laptop fan)
#  pv: -L: integer argument expected
#  gzip: stdin: unexpected end of file
#    1/2   ETA:-0.0000260s 0.0%      900493585 b =>          32 b webdok.20200508.tar.xz
#    2 files compressed in 0.076 seconds from 900493585 to 32 bytes  (-900493553 bytes) 0.0% of original
#  filen borte!

sub cmd_z2z {
  my %o;
  my $pvopts="L:D:i:lIq";
  my @argv=opts("pt:kvhon123456789es:$pvopts",\%o,@_);
  my $t=repl(lc$o{t},qw/gzip gz bzip2 bz2/);
  die "due: unknown compression type $o{t}, known are gz, bz2 and xz" if $t!~/^(gz|bz2|xz)$/;
  $o{p}=$o{q}=1 if!defined$o{p} and grep$pvopts=~/$_/,keys%o; # pvopts implies -p -q (quiet pv if -L++ wo -p)
  delete $o{e} if $o{e} and $o{t} ne 'xz' and warn "-e available only for type xz\n";
  my $sum=sum(map -s$_,@argv);
  print "Converting ".@argv." files, total ".bytes_readable($sum)."\n" if $o{v} and @argv>1;
  my $cat='cat';
  if($o{p}){ if(which('pv')){ $cat='pv' } else { warn repl(<<"",qr/^\s+/) } }
    due: pv for -p not found, install with sudo yum install pv, sudo apt-get install pv or similar

  $o{$_} and $o{$_}=" " for qw(l q); #still true, but no cmd arg for:
  $o{I} and $o{I}="-pterb";
  exists$o{$_} and $cat=~s,pv,pv -$_ $o{$_}, for $pvopts=~/(\w)/g; #warn "cat: $cat\n";

  my $sumnew=0;
  my $start=time_fp();
  my($i,$bsf)=(0,0);#bytes so far
  $Eta{'z2z'}=[];eta('z2z',0,$sum);
  #@argv=map$$_[1],sort{$$a[0]cmp$$b[0]}map{[$opt{
  for(@argv){
    my $new=$_; $new=~s/(\.(gz|bz2|xz))?$/.$t/i or die;
    my $ext=defined($2)?lc($2):'';
    my $same=/^$new$/; $new.=".tmp" if $same; die if $o{k} and $same;
    next if !-e$_ and warn"$_ do not exists\n";
    next if !-r$_ and warn"$_ is not readable\n";
    next if -e$new and !$o{o} and warn"$new already exists, skipping (use -o to overwrite)\n";
    my $unz={qw/gz gunzip bz2 bunzip2 xz unxz/}->{$ext}||'';
    #todo: my $cntfile="/tmp/acme-tools-z2z-wc-c.$$";
    #todo: my $cnt="tee >(wc -c>$cntfile)" if $ENV{SHELL}=~/bash/ and $o{v}; #hm dash vs bash
    my $z=  {qw/gz gzip   bz2 bzip2   xz xz/}->{$t};
    $z.=" -$_" for grep$o{$_},1..9,'e';
    $z.=" -$_ $o{$_}" for grep exists$o{$_},'L';
    my $cmd=qq($cat "$_"|$unz|$z>"$new");
     #todo: "$cat $_|$unz|$cnt|$z>$new";
    #cat /tmp/kontroll-linux.xz|unxz|tee >(wc -c>/tmp/p)|gzip|wc -c;cat /tmp/p
    $cmd=~s,\|+,|,g; #print "cmd: $cmd\n";
    sys($cmd);
    chall($_,$new) or croak("$0 cannot chmod|chown|touch $new") if !$o{n};
    my($szold,$sznew)=map{-s$_}($_,$new);
    $bsf+=-s$_;
    unlink $_ if !$o{k};
    rename($new, replace($new,qr/.tmp$/)) or die if $same;
    if($o{v}){
      $sumnew+=$sznew;
      my $pr=sprintf"%0.1f%%",$szold?100*$sznew/$szold:0;
      #todo: my $szuncmp=-s$cntfile&&time()-(stat($cntfile))[9]<10 ? qx(cat $cntfile) : '';
      #todo: $o{h} ? printf("%6.1f%%  %9s => %9s => %9s %s\n",      $pr,(map bytes_readable($_),$szold,$szuncmp,$sznew),$_)
      #todo:       : printf("%6.1f%% %11d b  => %11d b => %11 b  %s\n",$pr,$szold,$szuncmp,$sznew,$_)
      my $str= $o{h}
      ? sprintf("%-7s %9s => %9s",       $pr,(map bytes_readable($_),$szold,$sznew))
      : sprintf("%-7s %11d b => %11d b", $pr,$szold,$sznew);
      if(@argv>1){
	$i++;
	$str=$i<@argv
            ? "  ETA:".sprintf("%-8s",sec_readable(eta('z2z',$bsf,$sum)-time_fp()))." $str"
	    : "   TA: 0s $str"
	  if $sum>1e6;
        $str="$i/".@argv." $str";
      }
      print "$str $new\n";
    }
  }
  if($o{v} and @argv>1){
      my $bytes=$o{h}?'':'bytes ';
      my $str=
        sprintf "%d files compressed in %.3f seconds from %s to %s $bytes (%s bytes) %.1f%% of original\n",
	  0+@argv,
	  time_fp()-$start,
	  (map{$o{h}?bytes_readable($_):$_}($sum,$sumnew,$sumnew-$sum)),
	  100*$sumnew/$sum;
      $str=~s,\((\d),(+$1,;
      print $str;
  }
}

=head2 args

Parses command line options and arguments:

 my %opt;
 my @argv=Acme::Tools::args('i:nJ123',\%opt,@ARGV);   #returns remaining command line elements after C<-o ptions> are parsed into C<%opt>.

Uses C<Getopt::Std::getopts()>. First arg names the different one char
options and an optional C<:> behind the letter or digit marks that the
switch takes an argument.

=cut

sub args {
    my $switches=shift;
    my $hashref=shift;
    my $re_sw='^([a-z0-9]:?)+$';
    croak "ERR: args: first arg $switches dont match $re_sw\n" if $switches !~ /$re_sw/i;
    croak "ERR: second arg to args() not hashref\n" if ref($hashref) ne 'HASH';
    local @ARGV=@_;
    require Getopt::Std;
    Getopt::Std::getopts($switches => $hashref);
    (@ARGV);
}

sub opts {
    my($def, $hashref, @a)=@_;
    @a=@ARGV if @_<=2;
    my %def=map{/(\w)(:?)/;($1=>$2?2:1)}$def=~/(\w:?)/g;
    my $o1=join"",grep$def{$_}==1,sort keys%def;
    my $o= join"",                sort keys%def;
    my @r;
    while(@a){
	my $a=shift(@a);
	if($a=~/^-([$o1])([$o].*)$/){
	    unshift@a,"-$1","-$2";
	}
	elsif($a=~/^-(\w)(.*)$/){
	    my $d=$def{$1}//0;
	    push@{$$hashref{$1}},$d==1 && length($2) ? croak"opt -$1 has no arg (is $2 here)"
		                :$d==1               ? 1
				:$d==2 && length($2) ? $2
				:$d==2               ? shift(@a)
				:croak"unknown opt -$1";
	}
	elsif($a eq '--'){
	    last;
	}
	else {
	    push @r, $a;
	}
    }
    $_=join",",@$_ for values %$hashref;
    (@r,@a)
}

#cat Tools.pm|perl -I. /usr/local/bin/zsize -tp
#cat Tools.pm|perl -I. /usr/local/bin/zsize -tp -
#cat Tools.pm|perl -I. /usr/local/bin/zsize -tp Tools.pm
sub cmd_zsize {
  my %o;
  my @argv=opts("heEpts",\%o,@_);
  my $stdin=!@argv || join(",",@argv) eq '-';
  @argv=("/tmp/acme-tools.$$.stdin") if $stdin;
  writefile($argv[0],join("",<STDIN>)) if $stdin;
  my @prog=grep qx(which $_), qw(gzip bzip2 xz zstd brotli);
  for my $f (@argv){
      my $sf=-s$f;
      print "--- $f does not exists\n" and next if !-e$f;
      print "--- $f is not a file\n" and next if !-f$f;
      print "--- $f ($sf b) is not readable\n" and next if !-r$f;
      print "--- $sf b  ".bytes_readable($sf)."  ".($stdin?"-":$f)."\n";
      next if !$sf;
      my(@t,@s);
      for my $prog (@prog){
          next if !qx(which $prog);
          my @l=1..9;
          push @l,map"e$_",1..9 if $prog eq 'xz' and $o{e};
          @l=map"e$_",1..9      if $prog eq 'xz' and $o{E};
          @l=map 10+$_,@l       if $prog eq 'zstd';
          @l=map"q $_",3..11    if $prog eq 'brotli';
          printf "%-6s",$prog;
          push @t, $prog, [] if $o{t};
          push @s, $prog, [] if $o{p} and $o{s};
          for my $l (@l){ #level
              my $t=time_fp();
              my $b=qx(cat $f|$prog -$l|wc -c);
              push@{$t[-1]},time_fp()-$t if $o{t};
              push@{$s[-1]},$b           if $o{p} and $o{s};
              $o{p} ? printf("%9.1f%% ",100*$b/$sf)
             :$o{h} ? printf("%10s ",bytes_readable($b))
             :        printf("%10d ",$b);
          }
          print "\n";
      }
      while(@s){
          printf "%-6s",shift@s;
          $o{h}?printf("%10s ",bytes_readable($_)):printf("%10d ",$_) for @{shift@s}; print "\n";
      }
      while(@t){
          printf "%-6s",shift@t;
          printf "%9.3fs ",$_ for @{shift@t}; print "\n";
      }
  }
  unlink $argv[0] if $stdin;
}

sub cmd_rttop   { die "rttop: not implemented here yet.\n" }
sub cmd_whichpm { die "whichpm: not implemented here yet.\n" } #-a (all, inkl VERSION og ls -l)
sub cmd_catal   { die "catal: not implemented here yet.\n" } #-a (all, inkl VERSION og ls -l)
#todo: cmd_tabdiff (fra sonyk)
#todo: cmd_catlog (ala catal med /etc/catlog.conf, default er access_log)

=head1 DATABASE STUFF - NOT IMPLEMENTED YET

Uses L<DBI>. Comming soon...

  $Dbh
  dlogin
  dlogout
  drow
  drows
  drowc
  drowsc
  dcols
  dpk
  dsel
  ddo
  dins
  dupd
  ddel
  dcommit
  drollback

=cut

#my$dummy=<<'SOON';
sub dtype {
  my $connstr=shift;
  return 'SQLite' if $connstr=~/(\.sqlite|sqlite:.*\.db)$/i;
  return 'Oracle' if $connstr=~/\@/;
  return 'Pg'     if 1==2;
  die;
}

our($Dbh,@Dbh,%Sth);
our %Dbattr=(RaiseError => 1,
	     AutoCommit => 0,
	     FetchHashKeyName => 'NAME_lc'
    ); #defaults
sub dlogin {
  my $connstr=shift();
  my %attr=(%Dbattr,@_);
  my $type=dtype($connstr);
  my($dsn,$u,$p)=('','','');
  if($type eq 'SQLite'){
      $dsn=$connstr;
      $attr{sqlite_see_if_its_a_number}=1; #hm $DBD::SQLite::VERSION gt '1.32_02'
      #later: $dbh->{sqlite_see_if_its_a_number}=1; #hm better? if $DBD::SQLite::VERSION gt '1.32_02'
  }
  elsif($type eq 'Oracle'){
    ($u,$p,$dsn)=($connstr=~m,(.+?)(/.+?)?\@(.+),);
  }
  elsif($type eq 'Pg'){
    croak "todo: Pg support";
  }
  else{
    croak "dblogin: unknown database type for connection string $connstr\n";
  }
  $dsn="dbi:$type:$dsn";
  push @Dbh, $Dbh if $Dbh; #local is better?
  require DBI;
  $Dbh=DBI->connect($dsn,$u,$p,\%attr); #connect_cached?
}
sub dlogout {
  $Dbh->disconnect;
  $Dbh=pop@Dbh if @Dbh;
}
sub drow {
  #my($q,@b)=_dattrarg(@_);
  my($q,@b)=@_;
  #my $sth=do{$Sth{$Dbh,$q} ||= $Dbh->prepare_cached($q)};
  my $sth=$Dbh->prepare_cached($q);
  $sth->execute(@b);
  my @r=$sth->fetchrow_array;
  $sth->finish if $$Dbh{Driver}{Name} eq 'SQLite';
  #$dbh->selectrow_array($statement);
  @r==1 ? $r[0] : @r;
}
sub drows {
    my($sel,@bind)=@_;
    $sel=~s/^\w+$/select * from $&/;
    wantarray ? drowsh($sel,@bind)
              : drowsa($sel,@bind) ;
}
sub drowsh {
    my($sel,@bind)=@_;
    my $sth=$Dbh->prepare_cached($sel);
    $sth->execute(@bind);
    my @n=map"\u$_",@{$sth->{'NAME_lc'}};
    my @rows;
    while(my @r=$sth->fetchrow_array){
	my %r; @r{@n}=@r;
	push@rows,\%r;
    }
    @rows
}
sub drowc {
}
sub drowsc {
}
sub dcols {
}
sub dpk {
}
sub dsel {
}
#todo: implement CREATE X IF NOT EXISTS and DROP Y IF EXISTS for oracle like in sqlite+pg
sub ddo {
  my @arg=_dattrarg(@_);
  #warn serialize(\@arg,'arg','',1);
  $Dbh->do(@arg); #hm cache?
}
sub dins {
    my $tbl=shift;
    return if !@_;
    my @col=sort(keys%{$_[0]});
    my $cols=join',',@col;
    my $qms=join',',map'?',@col;
    my $sth=$Dbh->prepare_cached("insert into $tbl ($cols) values ($qms)");
    $sth->execute(@$_{@col}) for @_;
}
sub dupd {
}
sub ddel {
}
sub dcommit { $Dbh->commit }
sub drollback { $Dbh->rollback }

sub _dattrarg {
  my @arg=@_;
  splice @arg,1,0, ref($arg[-1]) eq 'HASH' ? pop(@arg) : {};
  @arg;
}

=head2 self_update

Update Acme::Tools to newest version quick and dirty:

 function pmview(){ ls -ld `perl -M$1 -le'$m=shift;$mi=$m;$mi=~s,::,/,g;print $INC{"$mi.pm"};warn"Version ".${$m."::VERSION"}."\n"' $1`;}

 pmview Acme::Tools                                     #view date and version before
 sudo perl -MAcme::Tools -e Acme::Tools::self_update    #update to newest version
 pmview Acme::Tools                                     #view date and version after

Does C<cd> to where Acme/Tools.pm are and then wget -N https://raw.githubusercontent.com/kjetillll/Acme-Tools/master/Tools.pm

TODO: cmd_acme_tools_self_update, accept --no-check-certificate to use on curl

=cut

our $Wget;
our $Self_update_url='https://raw.githubusercontent.com/kjetillll/Acme-Tools/master/Tools.pm'; #todo: change site
sub self_update {
  #in($^O,'linux','cygwin') or die"ERROR: self_update works on linux and cygwin only";
  $Wget||=(grep -x$_,map"$_/wget",'/usr/bin','/bin','/usr/local/bin','.')[0]; #hm --no-check-certificate
  -x$Wget or die"ERROR: wget ($Wget) executable not found\n";
  my $d=dirname(__FILE__);
  sys("cd $d; ls -l Tools.pm; md5sum Tools.pm");
  sys("cd $d; $Wget -N ".($ARGV[0]||$Self_update_url));
  sys("cd $d; ls -l Tools.pm; md5sum Tools.pm");
}

1;

package Acme::Tools::BloomFilter;
use 5.008; use strict; use warnings; use Carp;
sub new      { my($class,@p)=@_; my $self=Acme::Tools::bfinit(@p); bless $self, $class }
sub add      { &Acme::Tools::bfadd      }
sub addbf    { &Acme::Tools::bfaddbf    }
sub check    { &Acme::Tools::bfcheck    }
sub grep     { &Acme::Tools::bfgrep     }
sub grepnot  { &Acme::Tools::bfgrepnot  }
sub delete   { &Acme::Tools::bfdelete   }
sub store    { &Acme::Tools::bfstore    }
sub retrieve { &Acme::Tools::bfretrieve }
sub clone    { &Acme::Tools::bfclone    }
sub sum      { &Acme::Tools::bfsum      }
1;

# Ny versjon:
# - git clone https://github.com/kjetillll/Acme-Tools.git
# - git fetch
# - git checkout v0.28  #or whatever the remote branch name is, check for "remote" in output
# - c-s todo
# - endre $VERSION
# - endre Release history under HISTORY
# - endre årstall under =head1 COPYRIGHT
# - oppd default valutakurser inkl datoen
# - emacs Changes
# - emacs README versjon + aarstall
# - diff -byW200 <(grep -a ^sub Acme-Tools-0.22/Tools.pm|sort) <(grep -a ^sub Tools.pm|sort)|less
# - emacs MANIFEST legg til ev nye t/*.t
# - perl            Makefile.PL && make test
# - /usr/bin/perl   Makefile.PL && make test
# - perlbrew exec "perl Makefile.PL && time make test"
# - perlbrew exec "perl Makefile.PL && make test" | grep -P '^(perl-|All tests successful)'
# - perlbrew use perl-5.10.1; perl Makefile.PL && make test; perlbrew off
# - test evt i cygwin og mingw-perl
# - pod2html Tools.pm > Tools.html && chromium-browser Tools.html
# - pod2html Tools.pm > Tools.html && firefox          Tools.html
# - https://metacpan.org/pod/Acme::Tools
# - http://cpants.cpanauthors.org/dist/Acme-Tools   #kvalitee
# - perl Makefile.PL && make test && make dist
# - cp -p *tar.gz /htdocs/
# - #ci -l -mversjon -d `cat MANIFEST` #no
# - git add `cat MANIFEST`
# - git status
# - git commit -am versjon
# - git push                    #eller:
# - git push origin master      #eller:
# - git push -u origin v0.28
# - http://pause.perl.org/
# - tegnsett/utf8-kroell
# - https://rt.cpan.org/Dist/Display.html?Queue=Acme-Tools
# - grep '//=' Tools.pm t/*.t  #v5.10 and later
# http://en.wikipedia.org/wiki/Birthday_problem#Approximations

# memoize_expire()           http://perldoc.perl.org/Memoize/Expire.html
# memoize_file_expire()
# memoize_limit_size() #lru
# memoize_file_limit_size()
# memoize_memcached         http://search.cpan.org/~dtrischuk/Memoize-Memcached-0.03/lib/Memoize/Memcached.pm
# hint on http://perl.jonallen.info/writing/articles/install-perl-modules-without-root

# sub mycrc32 {  #http://billauer.co.il/blog/2011/05/perl-crc32-crc-xs-module/  eller String::CRC32::crc32 som er 100 x raskere enn Digest::CRC::crc32
#  my ($input, $init_value, $polynomial) = @_;
#  $init_value = 0 unless (defined $init_value);
#  $polynomial = 0xedb88320 unless (defined $polynomial);
#  my @lookup_table;
#  for (my $i=0; $i<256; $i++) {
#    my $x = $i;
#    for (my $j=0; $j<8; $j++) {
#      if ($x & 1) {
#        $x = ($x >> 1) ^ $polynomial;
#      } else {
#        $x = $x >> 1;
#      }
#    }
#    push @lookup_table, $x;
#  }
#  my $crc = $init_value ^ 0xffffffff;
#  foreach my $x (unpack ('C*', $input)) {
#    $crc = (($crc >> 8) & 0xffffff) ^ $lookup_table[ ($crc ^ $x) & 0xff ];
#  }
#  $crc = $crc ^ 0xffffffff;
#  return $crc;
# }
#
# $maybe_valid_utf8 =~                   # https://stackoverflow.com/questions/11709410/regex-to-detect-invalid-utf-8-string
# m/\A(
#     [\x09\x0A\x0D\x20-\x7E]            # ASCII, or rather: [\x00-\x7F]
#   | [\xC2-\xDF][\x80-\xBF]             # non-overlong 2-byte
#   |  \xE0[\xA0-\xBF][\x80-\xBF]        # excluding overlongs
#   | [\xE1-\xEC\xEE\xEF][\x80-\xBF]{2}  # straight 3-byte
#   |  \xED[\x80-\x9F][\x80-\xBF]        # excluding surrogates
#   |  \xF0[\x90-\xBF][\x80-\xBF]{2}     # planes 1-3
#   | [\xF1-\xF3][\x80-\xBF]{3}          # planes 4-15
#   |  \xF4[\x80-\x8F][\x80-\xBF]{2}     # plane 16
#  )*\z/x;

=head1 HISTORY

Release history

 0.28  TODO       tablestring_box, graph_scc, opts, huffman,
                  huffman_pack, huffman_unpack, push_srand, pop_srand
                  random_exp, random_poisson,++ ...more..., examin make indep of make? Build.pm?

 0.27  Feb 2020   Small fixes for some platforms

 0.26  Jan 2020   Convert subs: base bin2dec bin2hex bin2oct dec2bin dec2hex dec2oct
                  hex2bin hex2dec hex2oct oct2bin oct2dec oct2hex
                  Array subs: joinr perm permute permute_continue pile sortby subarrays
                  Other subs: btw in_iprange ipnum_ok iprange_ok opts s2t

 0.24  Feb 2019   fixed fails on perl 5.16 and older

 0.23  Jan 2019   Subs: logn, egrep, which. More UTF-8 "oriented" (lower, upper, ...)
                  Commands: zsize, finddup, due (improved), conv (improved, [MGT]?Wh
                  and many more units), due -M for stdin of filenames.

 0.22  Feb 2018   Subs: subarr, sim, sim_perm, aoh2sql. command: resubst

 0.21  Mar 2017   Improved nicenum() and its tests

 0.20  Mar 2017   Subs: a2h cnttbl h2a log10 log2 nicenum rstddev sec_readable
                  throttle timems refa refaa refah refh refha refhh refs
                  eachr globr keysr popr pushr shiftr splicer unshiftr valuesr
                  Commands: 2bz2 2gz 2xz z2z

 0.172 Dec 2015   Subs: curb openstr pwgen sleepms sleepnm srlz tms username
                   self_update install_acme_command_tools
                  Commands: conv due freq wipe xcat (see "Commands")

 0.16  Feb 2015   bigr curb cpad isnum parta parth read_conf resolve_equation
                  roman2int trim. Improved: conv (numbers currency) range ("derivatives")

 0.15  Nov 2014   Improved doc
 0.14  Nov 2014   New subs, improved tests and doc
 0.13  Oct 2010   Non-linux test issue, resolve. improved: bloom filter, tests, doc
 0.12  Oct 2010   Improved tests, doc, bloom filter, random_gauss, bytes_readable
 0.11  Dec 2008   Improved doc
 0.10  Dec 2008

=head1 SEE ALSO

L<https://github.com/kjetillll/Acme-Tools>

=head1 AUTHOR

Kjetil Skotheim, E<lt>kjetil.skotheim@gmail.comE<gt>

=head1 COPYRIGHT

2008-2021, Kjetil Skotheim

=head1 LICENSE

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut
