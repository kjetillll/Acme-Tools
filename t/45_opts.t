# make;perl -Iblib/lib t/45_opts.t
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests => 18;
sub check_opts {
  my($def,$arin,$ar_exp,$hr_exp,$die)=@_;
  my %o;
  my @a = eval{ opts($def,\%o,@$arin) };
  if($die){
    ok( ref($die) eq 'Regexp' ? ($@=~/$die/) : $@, repl($@,qr( at /.*)) );  #s///r 5.14
  } else {
    is_deeply(\@a, $ar_exp, repl(srlz(\@a,'a'),"\n"));
    is_deeply(\%o, $hr_exp, repl(srlz(\%o,'o'),"\n"));
  }
}
check_opts('ks:',[qw(-k -s str 1 2 3 4)],[1..4],{k=>1,s=>'str'});
check_opts('ks:',[qw(-k -- -s str 1 2 3 4)],['-s','str',1..4],{k=>1});
check_opts('ks:j',[qw(-k -s str -j 1 2 3 4)],[1..4],{k=>1,j=>1,s=>'str'});
check_opts('ks:x',[qw(-k -s str -j 1 2 3 4)],undef,undef,qr/unknown opt -j/);
check_opts('ks:j',[qw(-k -s str -j 1 -s str2 2 3 4)],[1..4],{k=>1,j=>1,s=>'str,str2'});
check_opts('ks:j',[qw(-k -sstr  -j 1 -s str2 2 3 4)],[1..4],{k=>1,j=>1,s=>'str,str2'});
check_opts('ks:j',[qw(-k -sstr  -j1 -s str2 2 3 4)],undef,undef,qr/has no arg/);
check_opts('ks:j',[qw(-kj -sstr 1 -s str2 2 3 4)],[1..4],{k=>1,j=>1,s=>'str,str2'});
check_opts('ks:je',[qw(-kje -sstr 1 -s str2 2 3 4)],[1..4],{e=>1,k=>1,j=>1,s=>'str,str2'});
check_opts('ks:jet:',[qw(-kjetil -sstr 1 -s str2 2 3 4)],[1..4],{e=>1,k=>1,j=>1,s=>'str,str2',t=>'il'});

#45_opts.t fails for v5.16.3 ?
