# perl Makefile.PL; make; perl -Iblib/lib t/04_resolve.t
BEGIN{require 't/common.pl'}
use Test::More tests => 14;

deb "Resolve: ".resolve(sub{my($x)=(@_); $x**2 - 4*$x -1},20,2)."\n";
deb "Resolve: ".resolve(sub{my($x)=@_; $x**log($x)-$x},0,3)."\n";
deb "Resolve: ".resolve(sub{$_[0]})." iters=$Acme::Tools::Resolve_iterations\n";
my $e;

ok(resolve(sub{my($x)=@_; $x**2 - 4*$x -21})     == -3   ,'first solution');
ok(($e=resolve {my($x)=@_; $x**2 - 4*$x -21})    == -3   ,"first solution wo sub (=$e)");
ok(resolve(sub{$_**2 - 4*$_ -21},0,3)            == 7    ,'second solution, start 3');
ok(resolve(sub{my($x)=@_; $x**2 - 4*$x -21},0,2) == 7    ,'second solution, start 2');
ok(do{my$r=resolve {$_**2 - 4*$_ -21} 0,2;$r==7}         ,'second solution, start 2, wo sub+_');
ok((resolve {$_**2 - 4*$_ -21} 0,2)              == 7    ,'second solution, start 2, wo sub+_');
ok((resolve sub{$_**2 - 4*$_ -21},0,2)           == 7    ,'second solution, start 2, wo sub+_');
ok($Resolve_iterations                           >  1    ,"iterations=$Resolve_iterations");
ok($Resolve_last_estimate                        == 7    ,"last_estimate=$Resolve_last_estimate (should be 7)");
ok(log($e=resolve(sub{my($x)=@_; $x**log($x)-$x},0,2.7)) == 1,"e=$e");
eval{  resolve(sub{1}) };
ok($@=~/Div by zero/);
ok(!defined $Resolve_iterations);
ok(!defined $Resolve_last_estimate);
eval{resolve(sub{my($x)=@_; sleep_fp(0.01); $x**2 - 4*$x -21},0,2,undef,undef,0.1)};
#deb "err: $Resolve_last_estimate, $Resolve_iterations, $@\n";
ok($@=~/Could not resolve, perhaps too little time given/);
