#perl -le 'for(2..10000){$s=sqrt;push@p,$_;$i=0;while($p[$i]<=$s){$_%$p[$i++] or pop@p,last}} print join" ",@p[0..999]'


sub primes0 { # positive: up to, negative: count
    my $n=shift;
    my @p;
    if($n>0){
	for(2 .. $n){
	    my($s,$i)=(sqrt,0);
	    push@p,$_;
	    while($p[$i]<=$s){$_%$p[$i++] or pop@p,last}
	}
    }
    else{
	@p=(2,3,5,7,11,13,17,19,23); #9stk
	for($p[-1]+1 .. -$n*20){
	    next unless $_%2 && $_%3 && $_%5 && $_%7 && $_%11 && $_%13 && $_%17 && $_%19 && $_%23; #9stk
	    my($s,$p,$i)=(sqrt,1,9-1);# 9stk -1
	    while( $p[$i] <= $s ){ $_%$p[$i++] or $p=0,last }
	    push @p, $_ if $p;
	    last if -$n<=@p;
	}
	pop @p while @p>-$n;
    }
    @p
}

#PR for solution_2 in https://github.com/PlummersSoftwareLLC/Primes/tree/drag-race/PrimePerl
sub primes { # positive: up to, negative: count
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
	$bits |= 0 x $factor**2  .  $repeat x $times;
    }
    (2,map$_*2+1,grep!substr($bits,1+$_*2,1),1..$n/2-.5);
}

my $n=shift//100;
print join" ",primes($n);
print "\n";

$|=1;
for(1..30){
    my $n=$_;
    #print"$_         \r";
    my $p0=join(",",primes0($n));
    my $p=join(",",primes($n));
    print"n=$n\n$p0\n$p\n\n" if $p0 ne $p;
}
