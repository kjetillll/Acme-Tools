# make && perl -Iblib/lib t/48_readfile_writefile.t
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests => 9;

my $tmp=tmp();

my $fn="$tmp/tmptestfile$$";
my $data="xxx\nyyy\nzzzz\n" x 1001;
writefile($fn,$data);
if(open my $file, "<", $fn){ ok(join("",<$file>) eq $data, 'writefile') }
else                       { ok(0,"open $fn") }
ok("".readfile($fn) eq $data, 'readfile');
ok(join('',map"$_\n",readfile($fn)) eq $data, 'readfile lines');

SKIP: {
  skip 'test writefile() and readfile() with gzip, only for linux', 2
      unless $^O eq 'linux' and -w$tmp;
  my $sz=-s$fn;
  writefile("$fn.gz",$data);
  my $szgz=-s"$fn.gz";
  ok($szgz/$sz < 0.1,             'writefile gz');  deb "gz ".($szgz/$sz)."\n";
  ok(readfile("$fn.gz") eq $data, 'readfile gz');
}
sub co{"content inside of file $tmp/file_$_[0]" x 1e1}
writefile([map{["$tmp/file_a$_"=>co("a$_")]}0..3]);
writefile({map{("$tmp/file_h$_"=>co("h$_"))}0..3});
my@id="a0".."a3","h0".."h3";
my %rf=readfile({map{("$tmp/file_$_"=>1)}@id});
my @rf=readfile([map"$tmp/file_$_",@id]);
is_deeply(\%rf,{map{("$tmp/file_$_"=>co($_))}@id}, 'readfile hashref');
is_deeply(\@rf,[map ["$tmp/file_$_"=>co($_)],@id], 'readfile arrayref');

my @lines1;readfile("$fn.gz",\@lines1,sub{pop!~/y/});
my @lines2=readfile("$fn.gz",sub{pop!~/y/});
my $exp=[grep!/y/,$data=~/.+/g];
is_deeply(\@lines1,$exp,'readfile w/filter 1');
is_deeply(\@lines2,$exp,'readfile w/filter 2');
