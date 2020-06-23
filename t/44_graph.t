# make && perl -Iblib/lib t/48_graph.t
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests => 80;

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

# sub graph_toposort ?