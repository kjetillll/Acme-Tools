#!/usr/bin/perl
use Acme::Tools;
use List::MoreUtils 'bsearch'; #':all';
use Benchmark qw(:all) ;

my @a = map [$_,$_**1.6+1e4], 1e5..2e5;
#my @a = 1e5..2e5;

my $t=time_fp();

my($h)=(bsearch {$$_[0] cmp 194022} @a);

print time_fp()-$t,"\n";

print srlz(\$h,"h");
my($i,$h1,$h2,$h3);
#sub finn {random(1e5,2e5)}
sub finn {192000}
timethese(2000, {
    'Name1' => sub { my$r=finn();($h1)=(bsearch {$$_[0] <=> $r} @a) },
#   'Name2' => sub { $i=binsearch(finn(),\@a) },
    'Name3' => sub { $i=binsearch([finn()],\@a,undef,sub{$_[0][0]<=>$_[1][0]});$h3=@a[$i] },
	  });

print srlz(\$h1,'h1');
print srlz(\$h3,'h3');
#print "i=$i   h=".srlz(\$h)."\n";

 my @data=(
    map {  {num=>$_,sqrt=>sqrt($_), square=>$_**2}  }
    grep !($_%7), 1..1000000
 );
 my $i = binsearch( {num=>913374}, \@data, undef, sub {$_[0]{num} <=> $_[1]{num}} );
 my $found = defined $i ? $data[$i] : undef;
print "i=$i\n";
print srlz(\$found,'f');

print "Binsearch_steps = $Acme::Tools::Binsearch_steps\n";
