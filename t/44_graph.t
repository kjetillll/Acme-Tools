# make && perl -Iblib/lib t/44_graph.t
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests => 93;
use Carp;
use Benchmark;

#       A ---> B       ,---  G <--- H
#       ^      |      /      ^      ^
#       |      |      |      |      |
#       |      v      v      |      |
#       D <--- C ---> E ---> F      I
#
# my @graph=( ['A'=>'B'], ['B'=>'C'], ['C'=>'D'], ['D'=>'A'],   ['C'=>'E'],
#             ['E'=>'F'], ['F'=>'G'], ['G'=>'E'],               ['H'=>'G'],  ['I'=>'H'] );

testscc('AB BC CD DA   CE  EF FG GE HG IH',                         'ABCD EFG H I');
testscc('AB BD DC CA BF FH FG GH',                                  'ABCD F G H');
testscc('12 26 16 61 67 71 24 41 64 67 41 35 58 85 59 98 83 38 34', '12467 3589');
testscc('01 12 23 30 45 56 64 67',                                  '0123 456 7');
testscc('BA AF FB BC CG GB FG HC IC DC HI ID DE EI IJ JE',          'ABCFG DEIJ H');
testscc('AB AF EA FE FB FG GC CB BC GH HG HD DH DC',                'AEF BC DGH');
testscc('13 32 21 11 41 42 4C 4D CD BC DB ED DF FE
         AB AE A9 9B 89 8A 67 7A 68 6A 56 58 95 35',                '123 4 56789A BCDEF');
testscc('12 24 41 13 35 54 34 46 67 76 68 A8
         89 9A B9 BC BD DC CG GB GF FC FE ED DE',                   '12345 67 89A BCDEFG');

sub testscc {
  if(@_==3){
    my($graph,$expected)=map[map[/./g],split],@_;
    is(srlz([graph_scc(@$graph)]), srlz($expected), repl("graph_scc: $_[0] => $_[1]",qr/\n\s*/))
  }
  else{ testscc(join(' ',mix(split/\s+/,$_[0])),$_[1],1) for 1..10 }
}

print "----------graph_toposort----------\n";

#example https://en.wikipedia.org/wiki/Topological_sorting

my @DAG=([5 => 11], [7 => 11], [7 => 8], [3 => 8], [3 => 10], [11 => 2], [11 => 9], [11 => 10], [8 => 9]);
my @s=graph_toposort(@DAG);

is_deeply(\@s,[3, 5, 7, 8, 11, 10, 9, 2], 'graph_toposort');
ok(is_toposorted(\@s,@DAG),'is_toposorted');
print join(", ",@s),"\n";

@DAG=map[split/\W+/], split/\s+/,
    'undershorts->pants  pants->belt  shirt->belt  socks->shoes shirt->tie
     tie->jacket belt->jacket undershorts->shoes pants->shoes';
my @order=graph_toposort2(@DAG);
ok(is_toposorted(\@order,@DAG),"graph_toposort2: @order");

@DAG=map[split/\W+/], split/\s+/,
    'm-x m-q m-r n-q n-u n-o o-r o-v o-s p-o p-s p-z q-t r-u r-y s-r
     u-t v-x v-w w-z y-v';
@order=graph_toposort(@DAG);
ok(is_toposorted(\@order,@DAG),"is_toposorted: @order");

srand(7);
my @code="AAA".."ZZZ";
my $redo=0;
for(
    {v=>10, e=>10},
    {v=>30, e=>25},
    {v=>1000, e=>600},
){
    my @v=do{my %v; $v{random(\@code)}++ while $$_{v} > 0+keys%v; sort keys%v};
    my @e=do{my %e;$e{join'->',map random(\@v),1..2}++ while $$_{e} > 0+keys%e; map[split/\W+/],sort keys%e};
    #redo if is_circular_DAG(@e) and print "is_circular: ".srlz(\@e,'e');
    my @o=eval{graph_toposort2(@e)};
    redo if $@ and ++$redo;# and print "is_circular: ".srlz(\@e,'e');
    ok(is_toposorted(\@o,@e),"is_toposorted: v=$$_{v} e=$$_{e} o=".@o."       redo=$redo");
    $redo=0;
   #print srlz(\@v,'v');
    #print srlz(\@e,'e');
    #print srlz(\@o,'o');
    #print "redo: $redo\n";
#    if($$_{v}==1000){
#      timethese(20, {
#      graph_toposort  => sub { @o=graph_toposort(@e) },
#      graph_toposort2 => sub { @o=graph_toposort2(@e) },
#        });
#    }
}
#print srlz(\@DAG,'DAG');
#print srlz(\@order,'order');


sub check_DAG {
  croak "ERROR: input is not a DAG (not array of refs to two elem arrays" if grep ref($_) ne 'ARRAY' || @$_!=2, @_;
}
sub graph_h2h {
  check_DAG(@_);
  my %hash;
  $hash{$$_[0]}{$$_[1]}++ for @_;
  %hash
}

#use List::MoreUtils 'any';
#sub any(&@){ my $block=shift; 0+grep$block,@_ }

sub graph_toposort { #Khan's topological sort algorithm
  check_DAG(@_);
  my @DAG=map{[@$_]}@_; #copy
 #my $incoming=sub{ my$node=shift; any{$node eq $$_[1]} @DAG }; #any
  my $incoming=sub{ my$node=shift; $node eq $$_[1] and return 1 for @DAG; 0 };
  my @l;                          #will contain sorted elem
  my @n=sort(uniq(map @$_,@DAG)); #all nodes
  my @s=grep !&$incoming($_),reverse@n;  #init @s to vertices without incoming edges
  #print "No incoming: ".srlz(\@s,'s');
  while(@s){
      my $n=pop @s;    #shift@s ???                #print"N=".@n." n=$n s=".@s." DAG=".@DAG." l=".@l." ";
      push @l, $n if !in($n,@l);                   #print "l=".@l." ";
      for my $m (map$$_[1],grep $n eq $$_[0],@DAG){  # all from $n, $n -> $m
      @DAG=grep{!($$_[0] eq $n and $$_[1] eq $m)}@DAG; #remove current from copy of input
      push @s, $m if !&$incoming($m);
      }
      #print "s=".@s."\n";
  }
  die "ERROR: sort_DAG, circular? "
      .srlz(\@l,'l')."\n"
      .srlz(\@DAG,'DAG')."\n"
      if @DAG;
  return @l;
}
sub graph_toposort2 { #Khan's topological sort algorithm
    check_DAG(@_);
    my %seen;
    my @n=sort(grep!$seen{$_}++,map@$_,@_); #all uniques nodes sorted
    my %incoming; $incoming{$$_[1]}{$$_[0]}++ for @_;
    my %outgoing; push @{$outgoing{$$_[0]}}, $$_[1] for @_;
    my @s=grep!exists$incoming{$_},reverse@n;
    my(@l,%l_seen);
    while(@s){
    my $n=pop@s;
    push @l, $n if !$l_seen{$n}++;
    push @s, grep {delete$incoming{$_}{$n};!keys%{$incoming{$_}}} @{$outgoing{$n}}
    }
    die "ERROR: circular graph! so no toposort exists" if grep {keys%$_} values%incoming;
    @l
}

sub is_circular_DAG {
  my @DAG=@_;
  my %seen;
  my @node=grep!$seen{$_}++,map@$_,@DAG;
  #die srlz(\@node,'node').@node."\n";
  
  my $i;
  my $circ;$circ=sub{
      die"for lang? ".srlz(\@_,'_') if @_>200;
      return @_ if @_>1 and $_[-1] eq $_[0];
      for(grep$$_[1] ne $_[-1],
      grep $_[-1] eq $$_[0], @DAG){
      my @test=(@_,$$_[1]);
      return @test if &$circ(@test);
      }
      return ()
  };
  
  @circ=&$circ($_) and return @circ for @node;
  ();
}

sub is_toposorted {
    my $list=shift;
    check_DAG(@_);
    my %pos=map{($$list[$_]=>$_)}0..$#$list;
#   any { $pos{$$_[0]} < $pos{$$_[1]} } @_;
    $pos{$$_[0]} < $pos{$$_[1]} and return 1 for @_;
    0
}

sub graph_cycle {
    my %C; $C{ $$_[0] }{ $$_[1] }++ for @_;
    my %v;
    my @try = map [$_], sort keys %C;
    while(@try){
	my @path = @{ shift @try };
	return @path if $path[0] eq $path[-1] and @path > 1;
	push @try, map [@path,$_], sort keys %{ $C{$path[-1]} } if !$v{$path[0],$path[-1]}++;
    }
    ()
}

for( [ [1,2],[2,8],[8,9],[9,2] => [2,8,9,2] ],
     [ [1,2],[2,3],[3,4],[4,5] => []     ],
     [ [3,2],[2,5],[2,1],[1,2] => [1,2,1]   ],
#    [ [3,2],[2,5],[2,4]       => undef     ],
#    [ [0,1],[0,2],[1,2],[2,3] => undef     ],
     [ [3,2],[2,5],[2,4]       => []     ],
     [ [0,1],[0,2],[1,2],[2,3] => []     ],
     [ ['A'=>'B'], ['B'=>'C'], ['C'=>'D'], ['D'=>'A'],  ['C'=>'E'],
       ['E'=>'F'], ['F'=>'G'], ['G'=>'E'], ['H'=>'G'],  ['I'=>'H']
       => ['E'=>'F'=>'G'=>'E'] ]
){
    my $expected = pop@$_;
    my @graph = @$_;
    my @got = graph_cycle(@graph);
    if(! defined $expected){
    	 print srlz(\@got,'got');
    }
    
    ok "@$expected" eq "@got", "graph_cycle: @{[map join('>',@$_), @graph]}   expected: @$expected   got: @got";
}
