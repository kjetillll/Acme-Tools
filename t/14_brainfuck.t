# make test
# or
# perl Makefile.PL; make; perl -Iblib/lib t/14_brainfuck.t

use strict;
use warnings;
use Test::More tests => 4;
BEGIN { use_ok('Acme::Tools') };

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
