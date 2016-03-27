# perl Makefile.PL; make; perl -Iblib/lib t/04_resolve.t
BEGIN{require 't/common.pl'}
use Test::More tests => 18;

deb "Resolve: ".resolve(sub{my($x)=(@_); $x**2 - 4*$x -1},20,2)."\n";
deb "Resolve: ".resolve(sub{my($x)=@_; $x**log($x)-$x},0,3)."\n";
deb "Resolve: ".resolve(sub{$_[0]})." iters=$Acme::Tools::Resolve_iterations\n";
my $e;

ok(resolve(sub{my($x)=@_; $x**2 - 4*$x -21})      == -3   ,'first solution');
ok(($e=resolve(sub{my($x)=@_; $x**2 - 4*$x -21})) == -3   ,"first solution wo sub (=$e)");
ok(resolve(sub{$_**2 - 4*$_ -21},0,3)             == 7    ,'second solution, start 3');
ok(resolve(sub{my($x)=@_; $x**2 - 4*$x -21},0,2)  == 7    ,'second solution, start 2');
my $f=sub{ $_**2 - 4*$_ - 21 };
ok(do{my$r=resolve($f,0,2);                     $r== 7}   ,'second solution, start 2, wo sub+_');
ok(resolve($f,0,2)                                == 7    ,'second solution, start 2, wo sub+_');
ok(resolve($f,0,2)                                == 7    ,'second solution, start 2, wo sub+_');
ok($Resolve_iterations                            >  1    ,"iterations=$Resolve_iterations");
ok($Resolve_last_estimate                         == 7    ,"last_estimate=$Resolve_last_estimate (should be 7)");
ok(log($e=resolve(sub{my($x)=@_; $x**log($x)-$x},0,2.7)) == 1,"e=$e");
eval{  resolve(sub{1}) };  # 1=0
ok($@=~/Div by zero/);
ok(!defined $Resolve_iterations);
ok(!defined $Resolve_last_estimate);

my $c;
eval{$e=resolve(sub{$c++; sleep_fp(0.02); $_**2 - 4*$_ -21},0,.02,undef,undef,0.05)};
deb "x=$e, est=$Resolve_last_estimate, iters=$Resolve_iterations, time=$Resolve_time, c=$c -- $@\n";
ok($@=~/Could not resolve, perhaps too little time given/,'ok $@');

ok( ($e=sprintf("%.12f",resolve(sub{3*$_ + $_**4 - 12}))) eq '1.632498783713',$e );
#http://www.quickmath.com/webMathematica3/quickmath/equations/solve/basic.jsp#c=solve_stepssolveequation&v1=3x%2Bx%5E4-12%3D0&v2=x

ok(log($e=resolve(sub{ $_**log($_)-$_},0,2)) == 1,"e=$e");
ok( ($e=resolve(sub{$_**2+7*$_-60},0,1)) == 5,"e=$e, iters=$Resolve_iterations");
ok( ($e=resolve_equation("x^2+7x-60"))   == 5,"e=$e, iters=$Resolve_iterations");


__END__
make;perl -Iblib/lib -MAcme::Tools -le'my$f=sub{3*$_+$_**4-12};print &$f($_=1.6325);print resolve($f,0,1.62,1e-3)'
0.00206525730521889
1.63249878371269
