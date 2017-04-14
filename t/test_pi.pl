use Acme::Tools;
print "$Acme::Tools::PI\n";
my $pi=bigf($PI);

pi_1();

sub pi_1 {
  for(1..6){
    my $t=time_fp();
    my $to=10**$_;
    my $sum=bigf(0);
    my $e;
    $e=(bigf(-1)**$_)/(2*$_+1) and $sum+=$e #and printf"%d%20.15f%20.15f\n",$_,$e,$sum
	for 0..$to;
    my $mypi=4*$sum;
    printf "%10d:  %27.22f %27.22f %27.22f %27.22f %27.22f    %5.2fs\n",
      $to,
      $mypi,
      $pi-$mypi,
      $pi-($mypi - 1/$to**1),
      $pi-($mypi - 1/$to**1 + 1/$to**2),
      $pi-($mypi - 1/$to**1 + 1/$to**2 - 2/$to**3),
     #$pi-($mypi - 1/$to**1 + 1/$to**2 - 2/$to**3 - 2/$to**6),
      time_fp()-$t;
  }
}
