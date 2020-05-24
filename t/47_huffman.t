# make && perl -Iblib/lib t/47_huffman.t

use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests => 12;

my $str='A_DEAD_DAD_CEDED_A_BAD_BABE_A_BEADED_ABACA_BED';

my @test=(
    [A=>50, B=>23, C=>12, D=>5, E=>5, q((A=>0,B=>11,C=>101,D=>1001,E=>1000))],

    [ _=>7, #111
      a=>4, #010
      e=>4, #000
      f=>3, #1101
      h=>2, #1010
      i=>2, #1000
      m=>2, #0111
      n=>2, #0010
      s=>2, #1011
      t=>2, #0110
      l=>1, #11001
      o=>1, #00110
      p=>1, #10011
      r=>1, #11000
      u=>1, #00111
      x=>1, #10010
      q((_=>111,a=>101,e=>100,f=>1101,h=>'0111',i=>'0110',l=>'01001',m=>'0001',n=>'0000',o=>'01000',p=>'01011',r=>'01010',s=>'0011',t=>'0010',u=>11001,x=>11000))
    ],

    #https://en.wikipedia.org/wiki/Huffman_coding#Basic_technique
    #do{my%c;map$c{$_}++,split//,$str;[map+($_=>$c{$_}),sort keys%c]},
    [A=>11,B=>6,C=>2,D=>10,E=>7,_=>10, q((A=>10,B=>1111,C=>1110,D=>'01',E=>110,_=>'00')) ],
);

for(@test){
    my$exp=pop(@$_);
    my@count=@$_;
    my%h=huffman(@count);
    is(repl(srlz(\%h),"\n"),$exp,repl($exp,"\n"));

    my $s; $s.=shift(@count) x shift(@count) while @count; #print "s=$s\n";
    %h=huffman(\$s);
    is(repl(srlz(\%h),"\n"),$exp,repl($exp,"\n"));

    %h=huffman([split//,$s]);
    is(repl(srlz(\%h),"\n"),$exp,repl($exp,"\n"));
}

my($encoded,$hashref)=huffman_pack($str);
#print srlz(\$encoded,'encoded');
#print srlz($hashref,'hashref');
my $str2=huffman_unpack($encoded,$hashref);
substr($str2,length($str))='';
is($str2,$str,"huffman_pack --> huffman_unpack --> $str");

my @r=huffman_unpack($encoded,$hashref,length$str);
$str2=join'',@r;
substr($str2,length($str))='';
is($str2,$str,"huffman_pack --> huffman_unpack --> $str");

my $string = "some silly silly string will sillily be split into silly chars";
my($encoded_binary_string, $encoding_hashref) = huffman_pack($string);
print "string == $string\n";
print "length '$string' == ".length($string)."\n";
print "length encoded_binary_string == ".length($encoded_binary_string)." chars, $Acme::Tools::Huffman_pack_bits bits\n";
print srlz($encoding_hashref,'enc');
my $string2 = huffman_unpack($encoded_binary_string, $encoding_hashref, length$string);
is($string2,$string,'YES!');
