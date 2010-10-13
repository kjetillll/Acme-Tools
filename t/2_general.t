use strict;
use warnings;

use Test::More tests => 162;
BEGIN { use_ok('Acme::Tools') };

my @empty;

#-- min, max
ok(min(1,2,3,4)==1);
ok(max(1,4,3,4)==4);
ok(not defined min());
ok(not defined max());
ok(not defined min(@empty));
ok(not defined max(@empty));

#--sum
ok(sum(2)==2);
ok(sum(2,2)==4);
ok(sum(2,-2)==0);
ok(sum(1..1000)==500500);
ok(! defined sum(),      'def sum');
ok(! defined sum(@empty),'def sum');
ok(sum(undef)==0,        'def sum');
ok(sum(undef,2)==2);
ok(sum(3,undef)==3);

#--avg, geomavg
ok(avg(2,4,9)==5);
ok(avg(2,4,9,undef)==3.75);
ok(0==0+grep{abs(geomavg($_,$_)-$_)>1e-8}range(3,10000,13));
ok(abs(geomavg(2,3,4,5)-3.30975091964687)<1e-11);
ok(abs(geomavg(10,100,1000,10000,100000)-1000)<1e-8);

#--stddev
ok(between(stddev(map { avg(map rand(),1..100) } 1..100), 0.02, 0.04));
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

#--random, mix
for(                                 #|hmm|#
  [ sub{random([1..5])},         2000, 1.5, 5],
  [ sub{random(["head","tail"])},2000, 1.2, 2],
  [ sub{random(1,6)},            2000, 1.7, 6],
  [ sub{random(2)},              2000, 1.3, 3],
  [ sub{join(",",mix(1..5))},   10000, 2.5, 5*4*3*2*1],
)
{
  my($sub,$times,$limit,$vals)=@$_;
  my %c;$c{&$sub()}++ for 1..$times;
  my @v=sort{$c{$a}<=>$c{$b}}keys%c;
 #print serialize(\%c,'c','',2),serialize(\@v,'v','',2);
  my $factor=$c{$v[-1]}/$c{$v[0]};
  ok($factor < $limit, " $limit > $factor, count=".keys(%c));
  ok($vals==keys%c);
}
#--random_gauss
#my $srg=time_fp;
#my @IQ=map random_gauss(100,15), 1..10000;
my @IQ=random_gauss(100,15,10000);
#print STDERR "\n";
#print STDERR "time     =".(time_fp()-$srg)."\n";
#print STDERR "avg    IQ=".avg(@IQ)."\n";
#print STDERR "stddev IQ=".stddev(@IQ)."\n";
my $perc1sd=100*(grep{$_>100-15   && $_<100+15  }@IQ)/@IQ;
my $percmensa=100*(grep{$_>100+15*2}@IQ)/@IQ;
#print STDERR "percent within one stddev: $perc1sd\n"; # 2 * 34.1 % = 68.2 %
#print STDERR "percent above two stddevs: $percmensa\n"; # 2.2 %
#my $num=1e6;
#my @b; $b[$_/2]++ for random_gauss(100,15, $num);
#$b[$_] && print STDERR sprintf "%3d - %3d %6d %s\n",$_*2,$_*2+1,$b[$_],'=' x ($b[$_]*1000/$num) for 1..200/2;
ok( between($perc1sd,  68.2 - 3,    68.2 + 3) );   #hm, margin too small?
ok( between($percmensa, 2.2 - 0.7,   2.2 + 0.7) ); #hm, margin too small?

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
my $a=123;
ok( decode($a, 123,3, 214,4, $a)           == 3 );
ok( decode($a, 122=>3, 214=>7, $a)         == 123 );
ok( not defined decode($a, '123.0'=>3, 214=>7) );                # prints nothing (undef)
ok( decode($a, 123.0=>3, 214=>7)           == 3 );
ok( decode_num($a, 121=>3, 221=>7, '123.0','b') eq 'b' );

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

#--zip
ok( join( " ", zip( [1,3,5], [2,4,6] ) ) eq '1 2 3 4 5 6' );

#--subhash
my %pop = ( Norway=>4800000, Sweeden=>8900000, Finland=>5000000,
            Denmark=>5100000, Iceland=>260000, India => 1e9 );
ok( serialize({subhash(\%pop,qw/Norway Sweeden Denmark/)},'h')
     eq qq{%h=('Denmark'=>'5100000','Norway'=>'4800000','Sweeden'=>'8900000');\n});

#--hashtrans
my%h = ( 1 => {a=>33,b=>55},
         2 => {a=>11,b=>22},
         3 => {a=>88,b=>99} );
ok( serialize({hashtrans(\%h)},'h')
   eq qq{%h=('a'=>{'1'=>'33','2'=>'11','3'=>'88'},'b'=>{'1'=>'55','2'=>'22','3'=>'99'});\n} );

#--zipb64, zipbin, unzipb64, unzipbin, gzip, gunzip
my $s=join"",map random([qw/hip hop and you dont stop/]), 1..1000;
ok( length(zipb64($s)) / length($s) < 0.5 );
ok( between(length(zipbin($s)) / length(zipb64($s)), 0.7, 0.8));
ok( between(length(zipbin($s)) / length(zipb64($s)), 0.7, 0.8));
ok( length(zipbin($s)) / length($s) < 0.4 );
ok( $s eq unzipb64(zipb64($s)));
ok( $s eq unzipbin(zipbin($s)));
my $d=substr($s,1,1000);
ok( length(zipb64($s,$d)) / length(zipb64($s)) < 0.8 );
my $f;
ok( ($f=length(zipb64($s,$d)) / length(zipb64($s))) < 0.73 , "0.73 > $f");
#for(1..10){
#  my $s=join"",map random([qw/hip hop and you dont stop/]), 1..1000;
#  my $d=substr($s,1,1000);
#  my $f= length(zipbin($s,$d)) / length(zipbin($s));
#  print $f,"\n";
#}

#--gzip, gunzip
$s=join"",map random([qw/hip hop and you do not everever stop/]), 1..10000;
ok(length(gzip($s))/length($s) < 1/5);
ok($s eq gunzip(gzip($s)));
ok($s eq unzipbin(gunzip(gzip(zipbin($s)))));
ok($s eq unzipb64(unzipbin(gunzip(gzip(zipbin(zipb64($s)))))));

print length($s),"\n";
print length(gzip($s)),"\n";
print length(zipbin($s)),"\n";
print length(zipbin($s,$d)),"\n";


#--ipaddr, ipnum
my $ipnum=ipnum('www.uio.no'); # !defined implies no network
my $ipaddr=defined$ipnum?ipaddr($ipnum):undef;
ok( !defined $ipnum || $ipnum=~/^(\d+\.?){4}$/, 'ipnum');
if(defined $ipaddr){
  ok( ipaddr($ipnum) eq 'www.uio.no' );
  ok( $Acme::Tools::IPADDR_memo{$ipnum} eq 'www.uio.no' );
  ok( $Acme::Tools::IPNUM_memo{'www.uio.no'} eq $ipnum );
}
else{ ok(1) for 1..3 }






#--webparams, urlenc, urldec
my %in=("\n&pi=3.14+0\n\n"=>gzip($s x 5),123=>123321);
my %out=webparams(join("&",map{urlenc($_)."=".urlenc($in{$_})}sort keys%in));
ok( serialize(\%in) eq serialize(\%out) );
ok( {webparams("b=123&a=1&b=222&a=2&a=3%20")}->{'a'} eq '1,2,3 ' );

#--ht2t
my $ser;
ok( ($ser=serialize([ht2t("
not this <table> <tr><td>asdf</td><td>asdf</td><td>asdf</td></tr> <tr><td>asdf</td><td>asdf</td><td>asdf</td></tr></table>
but this <table> <tr><td>1234</td><td>as\ndf</td><td>1234</td></tr> <tr><td>asdf</td><td>1234</td><td>as<b>df</b></td></tr></table>
","but")],"t"))
 eq qq{\@t=(['1234 ','as\ndf ','1234  '],['asdf ','1234 ','as df   ']);\n} );
#print "$ser\n";

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

ok( join( ",", range(11) )      eq '0,1,2,3,4,5,6,7,8,9,10', 'range' );
ok( join( ",", range(2,11) )    eq '2,3,4,5,6,7,8,9,10',     'range' );
ok( join( ",", range(11,2,-1) ) eq '11,10,9,8,7,6,5,4,3',    'range' );
ok( join( ",", range(2,11,3) )  eq '2,5,8',                  'range' );
ok( join( ",", range(11,2,-3) ) eq '11,8,5',                 'range' );

#--permutations

ok(join("-", map join(",",@$_), permutations('a','b')) eq 'a,b-b,a', 'permutations 1');
ok(join("-", map join(",",@$_), permutations('a','b','c')) eq 'a,b,c-a,c,b-b,a,c-b,c,a-c,a,b-c,b,a','permutations 2');


#--trigram
ok( join(", ",trigram("Kjetil Skotheim"))   eq 'Kje, jet, eti, til, il , l S,  Sk, Sko, kot, oth, the, hei, eim');
ok( join(", ",trigram("Kjetil Skotheim", 4)) eq 'Kjet, jeti, etil, til , il S, l Sk,  Sko, Skot, koth, othe, thei, heim');

#--cart
my @a1 = (1,2);
my @a2 = (10,20,30);
my @a3 = (100,200,300,400);
my $ss = join"", map "*".join(",",@$_), cart(\@a1,\@a2,\@a3);
ok( $ss eq  "*1,10,100*1,10,200*1,10,300*1,10,400*1,20,100*1,20,200"
          ."*1,20,300*1,20,400*1,30,100*1,30,200*1,30,300*1,30,400"
          ."*2,10,100*2,10,200*2,10,300*2,10,400*2,20,100*2,20,200"
          ."*2,20,300*2,20,400*2,30,100*2,30,200*2,30,300*2,30,400");
$ss=join"",map "*".join(",",@$_), cart(\@a1,\@a2,\@a3,sub{sum(@$_)%3==0});
ok( $ss eq "*1,10,100*1,10,400*1,20,300*1,30,200*2,10,300*2,20,200*2,30,100*2,30,400", 'cart');

#--int2roman
ok( int2roman(1234) eq 'MCCXXXIV', 'int2roman');
ok( int2roman(1971) eq 'MCMLXXI', 'int2roman');

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
               ["1997","Gina", "Weight", "Summer",66],
               ["1997","Gina", "Height", "Summer",170],
               ["1997","Per",  "Weight", "Summer",75],
               ["1997","Per",  "Height", "Summer",182],
               ["1997","Hilde","Weight", "Summer",62],
               ["1997","Hilde","Height", "Summer",168],
               ["1997","Tone", "Weight", "Summer",70],
 
               ["1997","Gina", "Weight", "Winter",64],
               ["1997","Gina", "Height", "Winter",158],
               ["1997","Per",  "Weight", "Winter",73],
               ["1997","Per",  "Height", "Winter",180],
               ["1997","Hilde","Weight", "Winter",61],
               ["1997","Hilde","Height", "Winter",164],
               ["1997","Tone", "Weight", "Winter",69],
 
               ["1998","Gina", "Weight", "Summer",64],
               ["1998","Gina", "Height", "Summer",171],
               ["1998","Per",  "Weight", "Summer",76],
               ["1998","Per",  "Height", "Summer",182],
               ["1998","Hilde","Weight", "Summer",62],
               ["1998","Hilde","Height", "Summer",168],
               ["1998","Tone", "Weight", "Summer",70],
 
               ["1998","Gina", "Weight", "Winter",64],
               ["1998","Gina", "Height", "Winter",171],
               ["1998","Per",  "Weight", "Winter",74],
               ["1998","Per",  "Height", "Winter",183],
               ["1998","Hilde","Weight", "Winter",62],
               ["1998","Hilde","Height", "Winter",168],
               ["1998","Tone", "Weight", "Winter",71],
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
ok(tablestring(\@reportB) eq <<'END', 'pivot B');
Year Season Height Height Height Weight Weight Weight Weight
            Gina   Hilde  Per    Gina   Hilde  Per    Tone
---- ------ ------ ------ ------ ------ ------ ------ ------ 
1997 Summer    170    168    182     66     62     75     70
1997 Winter    158    164    180     64     61     73     69
1998 Summer    171    168    182     64     62     76     70
1998 Winter    171    168    183     64     62     74     71
END

my @reportC=pivot([map{$_=[@$_[1,2,0,3,4]]}(@t=@table)],"Name","Attribute");
ok(tablestring(\@reportC) eq <<'END', 'pivot C');
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
END
my @reportD=pivot([map{$_=[@$_[1,2,0,3,4]]}(@t=@table)],"Name");
ok(tablestring(\@reportD) eq <<'END', 'pivot D');
Name  Height Height Height Height Weight Weight Weight Weight
      1997   1997   1998   1998   1997   1997   1998   1998
      Summer Winter Summer Winter Summer Winter Summer Winter
----- ------ ------ ------ ------ ------ ------ ------ ------ 
Gina     170    158    171    171     66     64     64     64
Hilde    168    164    168    168     62     61     62     62
Per      182    180    182    183     75     73     76     74
Tone                                  70     69     70     71
END

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

#-- upper, lower
ok(upper('a-zæøåäëïöüÿâêîôûãõàèìòùáéíóúýñ' x 3) eq 'A-ZÆØÅÄËÏÖÜÿÂÊÎÔÛÃÕÀÈÌÒÙÁÉÍÓÚÝÑ' x 3, 'upper'); #hmm ÿ
ok(lower('A-ZÆØÅÄËÏÖÜ.ÂÊÎÔÛÃÕÀÈÌÒÙÁÉÍÓÚÝÑ' x 3) eq 'a-zæøåäëïöü.âêîôûãõàèìòùáéíóúýñ' x 3, 'lower'); #hmm .

#-- easter
use Digest::MD5 qw(md5_hex);
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
my $br;
ok(($br=bytes_readable(999)) eq '999 B', "bytes_readable -> $br");
ok(($br=bytes_readable(1000)) eq '0.98 kB', "bytes_readable -> $br");
ok(($br=bytes_readable(1024)) eq '1.00 kB', "bytes_readable -> $br");
ok(($br=bytes_readable(1153433.6)) eq '1.10 MB', "bytes_readable -> $br");
ok(($br=bytes_readable(1181116006.4)) eq '1.10 GB', "bytes_readable -> $br");
ok(($br=bytes_readable(1209462790553.6)) eq '1.10 TB', "bytes_readable -> $br");
ok(($br=bytes_readable(1088516511498.24*1000)) eq '990.00 TB', "bytes_readable -> $br");

