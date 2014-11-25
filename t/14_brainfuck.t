# make test
# perl Makefile.PL; make; perl -Iblib/lib t/14_brainfuck.t

BEGIN{require 't/common.pl'}
use Test::More tests => 3;

my @test=(
   '>++++++++[<++++++++>-]<++++++++.>++++++[<++++++>-]<---.',
   'Hi',
   '++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>->>+[<]<-]>>-.>---..++++++.++++++>>.<<--.
    ----.+++++++++.>><<-----.>++++++++++.+++.<+++.>>.++++++++++++++++++.--.+.+++.,.,.,.',
   'Geek oktober 2014xyz',
   '++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>---.+++++++++++..+++.>++.<<++++++++++++++
    .>----------.+++++++++++++.--------------.+.+++++++++.>+  .>.',
   "Hallo Verden!\n",
);

#print brainfuck2perl('>++++++++[<++++++++>-]<++++++++.>++++++[<++++++>-]<---.'),"\n";
#print brainfuck2perl($test[0],"asdf"),"\n\n";

while(@test){
  my($bf,$answer)=splice(@test,0,2);
  ok( brainfuck($bf,"xyz") eq $answer,  "brainfuck: $answer");
}
