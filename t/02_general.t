# make test
# perl Makefile.PL; make; perl -Iblib/lib t/02_general.t

BEGIN{require 't/common.pl'}
use Test::More tests => 152;
use Digest::MD5 qw(md5_hex);

my @empty;
#-- min, max
ok(min(1,2,3,undef,4)==1, 'min');
ok(max(undef,1,4,3,4)==4, 'max');
ok(not defined min());
ok(not defined max());
ok(not defined min(@empty));
ok(not defined max(@empty));

#-- mins, maxs
ok(mins('2','4','10') eq '10', 'mins');
ok(maxs(2,4,10) == 4, 'maxs');

#--sum
ok(sum(2)==2);
ok(sum(2,2)==4);
ok(sum(2,-2)==0);
ok(sum(1..1000)==500500);
ok(!defined sum(),              'def sum');
ok(!defined sum(@empty),        'def sum');
ok(!defined(sum(undef,undef)),  'def sum');
ok(sum(undef,2)==2,             'def sum');
ok(sum(3,undef)==3,             'def sum');

#--avg, geomavg
ok(avg(2,4,9)==5,               'avg 2 4 9 is 5');
ok(avg([2,4,9])==5,             'avg 2 4 9 is 5');
ok(avg(2,4,9,undef)==5,         'avg ignore undef');
ok(0==0+grep{abs(geomavg($_,$_)-$_)>1e-8}range(3,10000,13));
ok(abs(geomavg(2,3,4,5)-3.30975091964687)<1e-11);
ok(abs(geomavg(10,100,1000,10000,100000)-1000)<1e-8);
ok(!defined(avg(undef)));

#--stddev
ok(stddev(12,13,14)>0);
ok(between(stddev(map { avg(map rand(),1..100) } 1..100), 0.02, 0.04));
ok(!defined(stddev()));
for((1,10,100)){ my @a=map rand(),1..$_; ok(stddev(@a) == stddev(\@a),'stddev: not ref vs ref') }
#print map"$_\n", sort {$a<=>$b} map stddev(map { avg(map rand(),1..100) } 1..100), 1..1000;

#--median
ok(median(2,3,4,5,6)==4);
ok(median(2,3,4,5)==3.5);
ok(median(2)==2);
ok(median(reverse(1..10000))==5000.5);
ok(median( 1, 4, 6, 7, 8, 9, 22, 24, 39, 49, 555, 992 ) == 15.5 );
ok(not defined median(undef));

#--percentile
ok(percentile(25, 1, 4, 6, 7, 8, 9, 22, 24, 39, 49, 555, 992 ) == 6.25);
ok(percentile(75, 1, 4, 6, 7, 8, 9, 22, 24, 39, 49, 555, 992 ) == 46.5);
ok(join(", ",percentile([0,1,25,50,75,99,100], 1,4,6,7,8,9,22,24,39,49,555,992))
	    eq '-2, -1.61, 6.25, 15.5, 46.5, 1372.19, 1429');


#--nvl
ok(not defined nvl());
ok(not defined nvl(undef));
ok(not defined nvl(undef,undef));
ok(not defined nvl(undef,undef,undef,undef));
ok(nvl(2.0)==2);
ok(nvl("3e0")==3);
ok(nvl(undef,4)==4);
ok(nvl(undef,undef,5)==5);
ok(nvl(undef,undef,undef,6)==6);
ok(nvl(undef,undef,undef,undef,7)==7);

#--replace
ok( replace("water","ater","ine") eq 'wine' );
ok( replace("water","ater")       eq 'w');
ok( replace("water","at","eath")  eq 'weather');
ok( replace("water","wa","ju",
                    "te","ic",
                    "x","y",
                    'r$',"e")     eq 'juice' );
ok( replace('JACK and JUE','J','BL') eq 'BLACK and BLUE' );
ok( replace('JACK and JUE','J')      eq 'ACK and UE' );
ok( replace('a2b3c4',qr/\d/) eq 'abc');
ok( replace('a2b3c4','\d') eq 'abc');
ok( replace('a2b3c4',qr{[^a-z]},'.') eq 'a.b.c.');
ok( replace('a2b3c4','[^a-z]','.') eq 'a.b.c.');
my $str="test";
replace(\$str,'e','ee','s','S');
ok( $str eq 'teeSt' );
ok( replace("abc","a","b","b","c") eq "ccc" ); #not bcc

#--decode, decode_num
my $test=123;
ok( decode($test, 123,3, 214,4, $test)           == 3 );
ok( decode($test, 122=>3, 214=>7, $test)         == 123 );
ok( not defined decode($test, '123.0'=>3, 214=>7) );                # prints nothing (undef)
ok( decode($test, 123.0=>3, 214=>7)           == 3 );
ok( decode_num($test, 121=>3, 221=>7, '123.0','b') eq 'b' );

#--between
my $n=7;
ok( between($n, 1,10) );
ok( between(undef, 1,10) eq '');
ok( between($n, 10,1) );
ok( between(5,5,5) );

#--distinct
ok( join(", ", distinct(4,9,30,4,"abc",30,"abc")) eq '30, 4, 9, abc' );

#--in, in_num
ok( in(  5,   1,2,3,4,6)         == 0 );
ok( in(  4,   1,2,3,4,6)         == 1 );
ok( in( 'a',  'A','B','C','aa')  == 0 );
ok( in( 'a',  'A','B','C','a')   == 1 );
ok( in( undef,'A','B','C','a')   == 0 );
ok( in( undef,'A','B','C',undef) == 1 );        # undef eq undef
ok( in(5000,  '5e3')      == 0 );
ok( in_num(5000, 1..4999,'5e3')   == 1 );

#--uniq
my @t=(7,2,3,3,4,2,1,4,5,3,"x","xx","x",02,"07");
ok( join( " ", uniq @t ) eq '7 2 3 4 1 5 x xx 07' );

#--union
ok( join( ",", union([1,2,3],[2,3,3,4,4]) ) eq '1,2,3,4' );

#--minus
ok( join( " ", minus( ["five", "FIVE", 1, 2, 3.0, 4], [4, 3, "FIVE"] ) ) eq 'five 1 2' );

#--intersect
ok( join(" ", intersect( ["five", 1, 2, 3.0, 4], [4, 2+1, "five"] )) eq '4 3 five' );

#--not_intersect
ok( join( " ", not_intersect( ["five", 1, 2, 3.0, 4], [4, 2+1, "five"] )) eq '1 2' );

#--subhash
my %pop = ( Norway=>4800000, Sweeden=>8900000, Finland=>5000000,
            Denmark=>5100000, Iceland=>260000, India => 1e9 );
ok_ref({subhash(\%pop,qw/Norway Sweeden Denmark/)},
       {Denmark=>5100000,Norway=>4800000,Sweeden=>8900000}, 'subhash');

#--hashtrans
my%h = ( 1 => {a=>33,b=>55},
         2 => {a=>11,b=>22},
         3 => {a=>88,b=>99} );
ok_ref( {hashtrans(\%h)},
        {a=>{1=>33,2=>11,3=>88},
         b=>{1=>55,2=>22,3=>99}}, 'hashtrans' );

#--ipaddr, ipnum
my $ipnum=ipnum('www.uio.no'); # !defined implies no network
my $ipaddr=defined$ipnum?ipaddr($ipnum):undef;
ok( !defined $ipnum || $ipnum=~/^(\d+\.?){4}$/, 'ipnum');
if(defined $ipaddr){
  ok( ipaddr($ipnum) eq 'www.uio.no' );
  ok( $Acme::Tools::IPADDR_memo{$ipnum} eq 'www.uio.no' );
  ok( $Acme::Tools::IPNUM_memo{'www.uio.no'} eq $ipnum );
}
else{ ok(1,'skip: no network') for 1..3 }

#--webparams, urlenc, urldec
my $s=join"",map random([qw/hip hop and you dont stop/]), 1..1000;
my %in=("\n&pi=3.14+0\n\n"=>gzip($s x 5),123=>123321);
my %out=webparams(join("&",map{urlenc($_)."=".urlenc($in{$_})}sort keys%in));
ok_ref( \%in, \%out, 'webparams 1' );
ok_ref( $a={webparams("b=123&a=1&b=122&a=3&a=2%20")},{a=>'1,3,2 ',b=>'123,122'}, 'webparams 2' );

#--chall
if($^O eq 'linux'){
  my $f1="/tmp/tmpf1";
  my $f2="/tmp/tmpf2";
  chmod(0777,$f1,$f2) and unlink($f1, $f2);
  open my $fh1,">",$f1 or die$!;
  open my $fh2,">",$f2 or die$!;
  close($fh1);close($fh2); #sleep_fp(0.5);
  chmod(0457,$f1);#chmod(02457,$f1);
  my $chown=chown(666,777,$f1);# or warn " -- Not checking chown, ok if not root\n";
  utime(1e9,1.1e9,$f1);
  my @stat=stat($f1);
  my $chall_ant=chall(\@stat,$f2);
  ok(!$chown || $chall_ant==1, "chall returned $chall_ant");
  for(($f1,$f2)){
    print "$_\n";
    my($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks ) = stat($_);
    ok($mode%010000 == 0457, sprintf("mode=%05o",$mode));
    ok(!$chown || $uid == 666,    "uid=$uid");
    ok(!$chown || $gid == 777,    "gid=$gid");
    ok($atime==1e9,    "atime=$atime");
    ok($mtime==1.1e9,  "mtime=$mtime");
  }
  chmod(0777,$f1,$f2) and unlink($f1, $f2);
}
else {ok(1) for 1..11}   # not linux

#--writefile, readfile
if($^O eq 'linux'){
  my $fn="/tmp/tmptestfile$$";
  unlink($fn);
  my $data="xxx\nyyy\nzzzz" x 10001;
  writefile($fn,$data);
  if(open my $file, "<", $fn){ ok(join("",<$file>) eq $data, 'writefile') }
  else                       { ok(0,"open $fn") }
  ok("".readfile($fn) eq $data, 'readfile');
  ok(join(",",readfile($fn)) eq replace($data,"\n",","), 'readfile lines');
  unlink($fn);
}
else{ok(1) for 1..3}     # not linux

#--range

ok_ref([range(11)],     [0,1,2,3,4,5,6,7,8,9,10], 'range' );
ok_ref([range(2,11)],   [2,3,4,5,6,7,8,9,10],     'range' );
ok_ref([range(11,2,-1)],[11,10,9,8,7,6,5,4,3],    'range' );
ok_ref([range(2,11,3)], [2,5,8],                  'range' );
ok_ref([range(11,2,-3)],[11,8,5],                 'range' );

#--permutations
ok(join("-", map join("",@$_), permutations('a','b')) eq 'ab-ba', 'permutations 1');
ok(join("-", map join("",@$_), permutations('a','b','c')) eq 'abc-acb-bac-bca-cab-cba','permutations 2');

#--trigram
ok( join(", ",trigram("Kjetil Skotheim"))   eq 'Kje, jet, eti, til, il , l S,  Sk, Sko, kot, oth, the, hei, eim',        'trigram');
ok( join(", ",trigram("Kjetil Skotheim", 4)) eq 'Kjet, jeti, etil, til , il S, l Sk,  Sko, Skot, koth, othe, thei, heim','trigram');

#--sliding
ok_ref([sliding(["Reven","rasker","over","isen"],2)],
       [['Reven','rasker'],['rasker','over'],['over','isen']], 'sliding' );

#--chunks
ok_ref( [chunks("Reven rasker over isen",7)],['Reven r','asker o','ver ise','n'] ,            'chunks string' );
ok_ref( [chunks([qw/Og gubben satt i kveldinga og koste seg med skillinga/], 3)],
           [['Og','gubben','satt'],['i','kveldinga','og'],['koste','seg','med'],['skillinga']] , 'chunks array' );

#--cart
my @a1 = (1,2);
my @a2 = (10,20,30);
my @a3 = (100,200,300,400);
my $ss = join"", map "*".join(",",@$_), cart(\@a1,\@a2,\@a3);
ok( $ss eq "*1,10,100*1,10,200*1,10,300*1,10,400*1,20,100*1,20,200"
          ."*1,20,300*1,20,400*1,30,100*1,30,200*1,30,300*1,30,400"
          ."*2,10,100*2,10,200*2,10,300*2,10,400*2,20,100*2,20,200"
          ."*2,20,300*2,20,400*2,30,100*2,30,200*2,30,300*2,30,400");
$ss=join"",map "*".join(",",@$_), cart(\@a1,\@a2,\@a3,sub{sum(@$_)%3==0});
ok( $ss eq "*1,10,100*1,10,400*1,20,300*1,30,200*2,10,300*2,20,200*2,30,100*2,30,400", 'cart - array mode');

my @ch=                                         cart(a=>[1..3],b=>[1..2],c=>[1..4]);
my @ca=map{my($a,$b,$c)=@$_;{a=>$a,b=>$b,c=>$c}}cart(   [1..3],   [1..2],   [1..4]);
ok_ref(\@ch,\@ca, 'cart - hash mode');

#--num2code, code2num

ok( num2code(255,2,"0123456789ABCDEF") eq 'FF' );
ok( num2code(14,2,"0123456789ABCDEF")  eq '0E' );
ok( num2code(1234,16,"01") eq '0000010011010010' );
ok( code2num("0000010011010010","01") eq '1234' );
my $chars='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_';
my $code=num2code("241274432",5,$chars);
ok( $code eq 'EOOv0' );

#--gcd
ok( gcd(12, 8) == 4 );
ok( gcd(90, 135, 315) == 45 );
ok( gcd(2*3*3*5, 3*3*3*5, 3*3*5*7) == 45 );

#--lcm
ok( lcm(45,120,75) == 1800 );
#--pivot
 my @table=(
               [1997,"Gina", "Weight", "Summer",66],
               [1997,"Gina", "Height", "Summer",170],
               [1997,"Per",  "Weight", "Summer",75],
               [1997,"Per",  "Height", "Summer",182],
               [1997,"Hilde","Weight", "Summer",62],
               [1997,"Hilde","Height", "Summer",168],
               [1997,"Tone", "Weight", "Summer",70],
 
               [1997,"Gina", "Weight", "Winter",64],
               [1997,"Gina", "Height", "Winter",158],
               [1997,"Per",  "Weight", "Winter",73],
               [1997,"Per",  "Height", "Winter",180],
               [1997,"Hilde","Weight", "Winter",61],
               [1997,"Hilde","Height", "Winter",164],
               [1997,"Tone", "Weight", "Winter",69],
 
               [1998,"Gina", "Weight", "Summer",64],
               [1998,"Gina", "Height", "Summer",171],
               [1998,"Per",  "Weight", "Summer",76],
               [1998,"Per",  "Height", "Summer",182],
               [1998,"Hilde","Weight", "Summer",62],
               [1998,"Hilde","Height", "Summer",168],
               [1998,"Tone", "Weight", "Summer",70],
 
               [1998,"Gina", "Weight", "Winter",64],
               [1998,"Gina", "Height", "Winter",171],
               [1998,"Per",  "Weight", "Winter",74],
               [1998,"Per",  "Height", "Winter",183],
               [1998,"Hilde","Weight", "Winter",62],
               [1998,"Hilde","Height", "Winter",168],
               [1998,"Tone", "Weight", "Winter",71],
             );

my @reportA=pivot(\@table,"Year","Name");
ok(tablestring(\@reportA) eq <<'END', 'pivot A');
Year Name  Height Height Weight Weight
           Summer Winter Summer Winter
---- ----- ------ ------ ------ ------ 
1997 Gina     170    158     66     64
1997 Hilde    168    164     62     61
1997 Per      182    180     75     73
1997 Tone                    70     69
1998 Gina     171    171     64     64
1998 Hilde    168    168     62     62
1998 Per      182    183     76     74
1998 Tone                    70     71
END

my @reportB=pivot([map{$_=[@$_[0,3,2,1,4]]}(@t=@table)],"Year","Season");
ok(tablestring(\@reportB) eq <<'', 'pivot B');
Year Season Height Height Height Weight Weight Weight Weight
            Gina   Hilde  Per    Gina   Hilde  Per    Tone
---- ------ ------ ------ ------ ------ ------ ------ ------ 
1997 Summer    170    168    182     66     62     75     70
1997 Winter    158    164    180     64     61     73     69
1998 Summer    171    168    182     64     62     76     70
1998 Winter    171    168    183     64     62     74     71

my @reportC=pivot([map{$_=[@$_[1,2,0,3,4]]}(@t=@table)],"Name","Attribute");
ok(tablestring(\@reportC) eq <<'', 'pivot C');
Name  Attribute 1997   1997   1998   1998
                Summer Winter Summer Winter
----- --------- ------ ------ ------ ------ 
Gina  Height       170    158    171    171
Gina  Weight        66     64     64     64
Hilde Height       168    164    168    168
Hilde Weight        62     61     62     62
Per   Height       182    180    182    183
Per   Weight        75     73     76     74
Tone  Weight        70     69     70     71

my @reportD=pivot([map{$_=[@$_[1,2,0,3,4]]}(@t=@table)],"Name");
ok(tablestring(\@reportD) eq <<'', 'pivot D');
Name  Height Height Height Height Weight Weight Weight Weight
      1997   1997   1998   1998   1997   1997   1998   1998
      Summer Winter Summer Winter Summer Winter Summer Winter
----- ------ ------ ------ ------ ------ ------ ------ ------ 
Gina     170    158    171    171     66     64     64     64
Hilde    168    164    168    168     62     61     62     62
Per      182    180    182    183     75     73     76     74
Tone                                  70     69     70     71

#--tablestring

ok( tablestring([[qw/AA BB CCCC/],[123,23,"d"],[12,23,34],[77,88,99],["lin\nes",12,"asdff\nfdsa\naa"],[0,22,"adf"]]) eq <<'END', 'tablestring' );
AA  BB CCCC
--- -- ----- 
123 23 d
12  23 34
77  88 99

lin 12 asdff
es     fdsa
       aa

    22 adf
END

#-- upper, lower (utf8?)
ok(upper('a-z����������������������������' x 3) eq 'A-Z����������������������������' x 3, 'upper'); #hmm �
ok(lower('A-Z��������.�������������������' x 3) eq 'a-z��������.�������������������' x 3, 'lower'); #hmm .

#--trim
ok( trim(" asdf \t\n    123 ") eq "asdf 123",  'trim 1');
ok( trim(" asdf\t\n    123 ") eq "asdf\t123",  'trim 2');
ok( trim(" asdf\n\t    123\n") eq "asdf\n123", 'trim 3');
my($trimstr,@trim)=(' please ', ' please ', ' remove ', ' my ', ' spaces ');
ok( join('',map"<$_>",trim(@trim)) eq '<please><remove><my><spaces>', 'trim array');
trim(\$trimstr);
ok($trimstr eq 'please', 'trim inplace');
trim(\@trim);
ok_ref(\@trim,[qw/please remove my spaces/], 'trim inplace array');

#-- easter
ok( '384f0eefc22c35d412ff01b2088e9e05' eq  md5_hex( join",", map{easter($_)} 1..5000), 'easter');

#--time_fp
ok( time_fp() =~ /^\d+\.\d+$/ , 'time_fp' );

#--sleep_fp
sleep_fp(0.01); #init, require Time::HiRes
my $t=time_fp();
sleep_fp(0.1);
my $diff=abs(time_fp()-$t-0.1);

#-fails on many systems...virtual boxes?
#$^O eq 'linux'
#? ok($diff < 0.03, "sleep_fp, diff=$diff < 0.03")    #off 30% ok
#: ok (1);

#--bytes_readable
my %br=(
   999                    => '999 B',
   1000                   => '1000 B',
   1024                   => '1.00 kB',
   1153433                => '1.10 MB',
   1181116006             => '1.10 GB',
   1209462790553          => '1.10 TB',
   1088516511498          => '0.99 TB'
);
my$br;
ok(($br=bytes_readable($_)) eq $br{$_}, "bytes_readable($_) == $br (should be $br{$_})")
  for sort {$a<=>$b} keys%br;

