#perl Makefile.PL && make && perl -Iblib/lib t/08_functional.t
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests => 10;

sub _sum { reduce{$a+$b}@_ }
sub _min { reduce{$a<$b?$a:$b}@_ }
sub _max { reduce{$a>$b?$a:$b}@_ }
sub _avg { (reduce{$a+$b}@_)/@_ }
sub _pile { my$s=shift; @{(reduce {ref($a)?do{push@$a,[]if@{$$a[-1]}>=$s;push@{$$a[-1]},$b;$a}:[[$b]]} 0,@_)[0]} }

for my $fun (qw(sum min max avg pile)){
  srand(7);
  for(1..2){
    my @list = map rand(), 1..12;
    my $is=/pile/?\&is_deeply:\&is;
    unshift @list, 3 if/pile/;
    eval<<''=~s|is|/pile/?'is_deeply':'is'|er;
    is( &{"_$fun"}(@list),
        &{$fun}(@list),
        "function: _$fun vs $fun" );

  }	
}
