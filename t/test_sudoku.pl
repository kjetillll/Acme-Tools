use v5.14;
use Time::HiRes qw(time);
use List::Util  qw(any all uniq first);
use Storable    qw(dclone);
use Acme::Tools qw(srlz time_fp readdirectory readfile);
use DBI;

my %test = (
    github => {
        input =>'17.  ...  .42
                 .3.  ...  .5.
                 ...  .9.  ...

                 ..3  962  1..
                 ...  ...  ...
                 ..2  137  5..

                 3.1  4.9  8.7
                 6..  .8.  ..3
                 4..  ...  ..5',
        result=>'179  358  642
                 234  716  958
                 865  294  731

                 583  962  174
                 716  845  329
                 942  137  586

                 351  429  867
                 627  581  493
                 498  673  215'
    },
    sqlite_example => { #https://sqlite.org/lang_with.html
        input => '53..7....6..195....98....6.8...6...34..8.3..17...2...6.6....28....419..5....8..79',
        result=> '534678912672195348198342567859761423426853791713924856961537284287419635345286179'},
    youtube_Ui1hrp7rovw => { #https://www.youtube.com/watch?v=Ui1hrp7rovw and
                             #https://sudokupad.app/7gJb9G8fRt also
      input => '...1.2... .6.....7. ..8...9..
                4.......3 .5...7... 2...8...1
                ..9...8.5 .7.....6. ...3.4...',
      result=> '9341726585 61948372 728635914
                4172695838 53417296 296583741
                1497268353 72851469 685394127',
    },
    # youtube_EwD7nGK6Elc => { #https://www.youtube.com/watch?v=EwD7nGK6Elc  multiple solutions
    #   input => '9..6....................... 3.6...................9...3 .....38................6...',
    #  #input => '95.6....................... 3.6...................9...3 .....38................6...',
    #  #input => '9516....................... 3.6...................9...3 .....38................6...',
    #   guard=>sub{ $_[0]=~/^.{4}(\d).{8}(\d).(\d)(\d).{8}(\d)/ or return 1;
    # 		  #die"<$_[0]>   <$1>   <$2>   <$3>   <$4>   <$5>";
    # 		  $1+$2==3 and $3+$4+$5==9 },
    #   result=> '',
    # },
    youtube_m9Xaa4GXs9I => { #https://www.youtube.com/watch?v=m9Xaa4GXs9I
      input => '6.5..479. .8.....64 .7.9..5.8 9.4....86 7.......5 .58...... ..6..8..7 ...15.... ....2..4.',
      result=> '605004790 080000064 070900508 904000086 700000005 058000000 006008007 000150000 000020040',
    },
    sudoku_com_easy  => { #https://sudoku.com/easy/
      input => '1563.42..9..18..7.8...6.145 .83.965.7..4.......197.38.4 4..5.17627........3....7..9',
      result=> '156374298942185673837962145 283496517574218936619753824 498531762725649381361827459',
    },
    sudoku_com_hard  => { #https://sudoku.com/hard/
      input => '6.8...1..7......98.......6. .86...42.3..6.7..5..9254..3 .15..6..9.6.345......8.1...',
      result=> '658479132743162598291538764 586913427324687915179254683 815726349962345871437891256',
    },
    sudoku_com_expert  => { #https://sudoku.com/expert/
      input => '.78...96....46..786.1.8.... ..51..48.....5..9.86..2.5.3 784...251.1.5.2....5.......',
      result=> '478213965532469178691785324 925137486143658792867924513 784396251316572849259841637',
    },
    sudoku_com_evil  => { #https://sudoku.com/evil/
      input => '..9..5.2.24.7....1..6.4.... .6.......41..3..5....9..3.. ..2...........8..753..9..1.',
      result=> '379185624248763591156249783 963452178417836259825971346 782314965691528437534697812',
    },
    sudoku_com_extreme  => { #https://sudoku.com/extreme/
      input => '..1..5...8..4........2..1.9 .5......3.4.....25768...... ..4.8..6........7.....675..',
      result=> '421695837897431256635278149 152749683349816725768352491 574183962916524378283967514',
    },
    websudoku_com_hard_35742904 => { # https://www.websudoku.com/?level=3&set_id=35742904
      input => '.8.9...4.1..7..85.........3 ..3.2...58.2...4.65...1.9.. 3.........68..9..2.4...8.9.',
      result=> '687935241134762859925184763 493826175812597436576413928 359271684768349512241658397',
    },
    websudoku_com_evil_6375679867 => { #https://www.websudoku.com/?level=4&set_id=6375679867
      input => '85.2.......953.8.1.7.1..... ......7..62.....95..8...... .....1.8.1.3.729.......5.67',
      result=> '851247639249536871376189542 935624718624718395718953426 597461283163872954482395167',
    },
    websudoku_com_evil_3640514182 => { #https://www.websudoku.com/?level=4&set_id=3640514182
      input => '7....1....85.......937..... 27..8.4..8...4...6..6.2..93 .....261.......58....9....7',
      result=> '762451938185293764493768125 279386451831549276546127893 354872619917634582628915347',
    },
    websudoku_com_evil_6670389185 => { #https://www.websudoku.com/?level=4&set_id=6670389185
      input => '.6...3....2.1..8.59......3. 4.2.5......3.8.4......7.2.9 .3......12.8..6.7....5...9.',
      result=> '165823947324197865987465132 492651783573289416816374259 639748521258916374741532698',
    },
    hm=> { #blank 0.006 sec
      input => '.................................................................................',
      result=> '987654321654321987321987654896745213745213896213896745579468132468132579132579468',
    },
    #se ogsaa https://www.youtube.com/watch?v=bK1z1Ps0wzc&t=1267s for haskell
);

for(readdirectory("t/sudokus/")){
    my($i,$r)=map s/[^.\d]//gr,split/==/,''.readfile($_);
    next if length($i) != 81 and say"Skips file $_ - no 9x9 sudoku found (len=".length($i).")" and next;
    $test{s|.*/||r}={input=>$i,result=>$r};
}

my @RE;
my $err=0;
for my $name ( sort keys %test) {
    my $test=$test{$name};
    #next if $name !~ /m9X/;
    #next if $name !~ /com_easy/;
    next if $name !~ /github/;
    #next if $name ne 'hm';
    #next if $name ne 'youtube_EwD7nGK6Elc';
    my($i,$w)=
        map s/\s//gr,
        @{ $test{$name} }{'input','result'};
    printf "---- name: $name ----\n";
    my $t=time();
    #my $g=sudoku_sqlite($i);
    #my $g=sudoku($i);
    #my $c=0;
    #my @g=sudoku($i);
    # my @g=sudoku($i,
    # 		 ($$test{guard}),
    # 		 sub{say"<<sol $c: $_[0]>>" if substr($_[0],4,1)+substr($_[0],13,1)==3 and ++$c;1}); # if $c<=10 or $c==100;$c<=100});
    #my $g=$g[0];
    my @g;
    my $g=sudoku($i);
    die "i: $i   g: $g\n";
    #my $g=sudoku_simple($i);
    $err+=$g ne $w;
    $$test{runtime}=time()-$t;
    print $$test{info}=sprintf "input: $i\nwant:  $w\ngot:   $g (1 of ".@g.")\ntime:  %.3f seconds\ntest:  %s\n\n", $$test{runtime}, $g eq $w ? "ok" : "err";
    die if not valid_sudoku_result($g);
#    last;
}
$test{'SUM RUNTIME'}{runtime}=eval join'+',map$$_{runtime},values%test;
printf"%-30s %6.3fs\n",$_,$test{$_}{runtime} for sort{$test{$a}{runtime}<=>$test{$b}{runtime}}keys%test;
print $err ? "*** ERRORS: $err ***\n" : "\nAll tests ok\n";

our(@RE, @NB, %is_NB);
sub sudoku {
    my($s,$guard,$feed) = @_;
    state @NB = _sudoku_neighbours();
    if(!@RE){ #init
	#print srlz(\@NB,'NB','',0)=~s/'//gr;exit;
	for my $i (0..80){ $is_NB{$i,$_} = $is_NB{$_,$i} = 1 for @{ $NB[$i] } }
	for my $z ( 1..9 ){
	    //,$RE[$'*9+$z-1] = qr/^@{[ join'', map $is_NB{$',$_} ? "[^$z]" : ".", 0 .. 80 ]}$/ for 0..80;
	}
    }
    my $dig = sub{ my $s=pop; map { my @nb = @{$NB[$_]}; $s =~ /^.{$_}(\d)/ ? $1 : [grep {my$n=$_;all{$n-substr$s,$_,1}@nb} 1..9] } 0..80 };
    my @dig = &$dig($s);
    print "$s\n".srlz(\@dig,'dig')=~s/'//gr;
    #@dig = _naked_pair_trim(@dig);
    my @w = ($s);
    my @r;
    my $round=0;
    while( my $w = pop@w ){
   #while( my $w = $round%1000==0 ? splice(@w,@w>>1,1) : $round%100==0 ? shift(@w) : pop(@w) ){
	$round++;
	say "$round: $w   lenw: ".@w if $round%1e6==0;
	die"$w len ".length($w) if $w!~/^[.1-9]{81}$/;
	#next if length($w)!=81;
	my $i = index $w, '.';
	if($i<0){
	    push @r, $w;
	    #last;
	    last if !wantarray;
	    &$feed($w) or last if $feed;
	    next
	}
	my($pre, $post);
	die "i: $i" if !ref$dig[$i];
        push @w, grep {!$guard or &$guard($_)}
	         map { ($pre//=substr($w,0,$i)) . $_ . ($post//=substr($w,$i+1)) }
	         grep $w =~ $RE[ $i*9+$_-1 ],
	         @{ $dig[$i] };
    }
    wantarray ? @r : pop@r;
}

sub sudoku_simple {
    my $s = shift;
    use integer;
    state @NB = map { //; #20 neighbor pos list for each 81 pos
		   [ uniq sort{$a<=>$b} grep $_-$',
		     ( map { $'/9*9+$_-1                       } 1..9 ),
		     ( map { $'%9+($_-1)*9                     } 1..9 ),
		     ( map { $'/3%3*3+$'/27*27+$_+($_-1)/3*6-1 } 1..9 ) ] } 0..80;
    state @d = reverse '1' .. '9';
    my $i = index $s, '.';
    my($pre, $post, $r) = ( substr($s,0,$i), substr($s,$i+1) );
    $i < 0 ? $s : ( first {
	                my $d = $_;
			all { $d ne substr($s,$_,1) } @{ $NB[$i] }
			and $r = sudoku_simple( $pre.$_.$post, $i, $_ )
                    } @d ) ? $r : ()
}

sub sudoku_0 {
    my $s=shift;
    if(!@RE){ #init
	use integer;
	@NB = map { //; #20 neighbor positions list for each 81 positions
		   [ uniq sort{$a<=>$b} grep $_-$',
		     ( map { $'/9*9+$_-1                       } 1..9 ),
		     ( map { $'%9+($_-1)*9                     } 1..9 ),
		     ( map { $'/3%3*3+$'/27*27+$_+($_-1)/3*6-1 } 1..9 ) ] } 0..80;
	for my $i (0..80){
	    $is_NB{$i,$_} = $is_NB{$_,$i} = 1 for @{ $NB[$i] }
	}
	for my $z ( 1..9 ){
	    for my $i (0..80){
		$RE[$i*9+$z-1] = qr/^@{[ join'', map $is_NB{$i,$_} ? "[^$z]" : ".", 0 .. 80 ]}$/;
	    }
	}
    }

    my @digits = '1' .. '9';
    my($steps,$maxw)=(0,-1);

    my $dig =sub{ my $s=pop; map { my @nb = @{$NB[$_]}; $s =~ /^.{$_}\d/ ? 0 : join'', grep {//;all{$'-substr$s,$_,1}@nb} 1..9 } 0..80 };
    my @dig = &$dig($s);

    # my @i = #map[$_,$dig[$_]],
    # 	sort{0+@{$dig[$a]} <=> 0+@{$dig[$b]} || $a<=>$b } grep substr($s,$_,1) eq '.', 0..80;

    my @i = #map[$_,$dig[$_]],
	sort{length($dig[$a]) <=> length($dig[$b]) || $a<=>$b } grep substr($s,$_,1) eq '.', 0..80;

    #print srlz(\@dig,'dig','',1);#exit;
    #print srlz(\@i,'i','',1);exit;
    #my @w=([$s]);
    my @w=($s);
    my @dig_cache;
    #    my $oo_last;
    my $pos4 = $s=~/^(\d*\.){4}/ ? length($&) : die; #die"pos4: $pos4   s: $s\n";
    my $w4_last='';
    my $redig=0;
    while( @w ){
	#my($w,@o) = @{pop(@w)};
	my $w = pop@w;
	$steps++;
	$maxw = 0+@w if 0+@w > $maxw;
	my $i=index($w,'.');

	my $w4=substr($w,0,$pos4);
       #if($w4 ne $w4_last){
	if(0){
	    $redig++;
	    @dig = &$dig($w4.substr($s,$pos4));
	    $w4_last=$w4;
	}

	#@dig = &$dig($w);
	
	# @dig=map{
	#     my @nb=@{$NB[$_]};
	#     substr($w,$_,1) eq '.' ? [grep{my$d=$_;!any{substr($w,$_,1) eq $d}@nb}1..9] : 0;
	# }0..80;

	#shift@i while substr($w,$i[0],1) ne '.' and @i;
	#my $i=$i[0];

	#my $i = $w=~/\.\d/ ? length($`) : index($w,'.');
	
	#my @i=grep substr($w,$_,1) eq '.',0..80;

        #print "step: $steps   work: $w   ind: $i   wsz: ".@w."\n";
	print "steps: $steps   maxw: $maxw   pos4: $pos4   redig: $redig\n" and return $w if $i<0 or !defined$i;


	if(0){ #experiment
	    my @d=grep $w=~$RE[$i*9+$_-1], $dig[$i]=~/./g;
	    my @nb=@{$NB[$i]};
	    my($pre,$post)=(substr($w,0,$i),substr($w,$i+1));
	    for my $d (@d){
		#ref $$di[$_] and delete $$di[$_]{substr($w,$_,1)} for @nb;
		push @w, [$pre.$d.$post, @dig];
		# my @new=@dig;
		# $new[$_]=~s/$d// for grep$is_NB{$i,$_},0..80;
		# push @w, [$pre.$d.$post, @new];#map $is_NB{$i,$_} ? $dig[$_]=~s/$d//r : $dig[$_], 0..80];
	    }
	    next;
	}
	
	
       #my @d=grep $w=~$RE[$i*9+$_-1], @digits;
       #my @d=grep $w=~$RE[$i*9+$_-1], $dig[$i]=~/./g;
       #next if!@d;
	my($pre,$post)=(substr($w,0,$i),substr($w,$i+1));
       #push @w, map $pre.$_.$post, grep $w=~$RE[$i*9+$_-1], split//,$dig[$i];
        push @w, map $pre.$_.$post, grep $w=~$RE[$i*9+$_-1], @{$dig_cache[$i] //= [$dig[$i]=~/./g]};
	#push @w, map $pre.$_.$post, @d;
    }
    print "steps: $steps   maxw: $maxw   pos4: $pos4   redig: $redig     FANT INGEN\n";
}

sub sudoku_sqlite {$_[0]=~/^[\d\.]{81}$/||die;(DBI->connect('dbi:SQLite:-')->selectrow_array(<<""))[0]}
  WITH RECURSIVE
  input(sudoku) AS ( VALUES('$_[0]') ),
  digits(z, lp) AS (
    VALUES('1', 1)
    UNION ALL SELECT
    CAST(lp+1 AS TEXT), lp+1 FROM digits WHERE lp<9
  ),
  x(s, ind) AS (
    SELECT sudoku, instr(sudoku, '.') FROM input
    UNION ALL
    SELECT
             substr(x.s, 1, x.ind-1) || z || substr(x.s, x.ind+1),
      instr( substr(x.s, 1, x.ind-1) || z || substr(x.s, x.ind+1), '.' )
    FROM x, digits AS z
    WHERE ind>0
      AND NOT EXISTS (
            SELECT 1 FROM digits d
            WHERE z.z = substr( x.s, ((x.ind-1)/9)*9 +  d.lp          , 1 )
               OR z.z = substr( x.s, ((x.ind-1)%9)   + (d.lp-1)*9 + 1 , 1 )
               OR z.z = substr( x.s,(((x.ind-1)/3)%3)*3
                                    +((x.ind-1)/27)*27 + d.lp
                                    +((d.lp -1)/3) * 6                , 1 )
      )
  )
  SELECT s FROM x WHERE ind=0;

sub _sudoku_neighbours {
    use integer;
    map { my$n=$_;#//; #20 neighbor pos list for each 81 pos
	  [ uniq sort{$a<=>$b} grep $_-$n,
	    ( map { $n/9*9+$_-1                       } 1..9 ),
	    ( map { $n%9+($_-1)*9                     } 1..9 ),
	    ( map { $n/3%3*3+$n/27*27+$_+($_-1)/3*6-1 } 1..9 ) ] } 0..80;
}

sub _naked_pair_trim {
    my @dig=@_;
    state @NB = _sudoku_neighbours();
   #print srlz(\@dig,'dig','',1)=~s/'//gr;#exit;
    #print srlz(\@NB,'NB','',1)=~s/'//gr;exit;
    #print srlz($NB[$_],"NB_$_",'',0)=~s/\n//r, "    ".srlz(ref$dig[$_]?$dig[$_]:[$dig[$_]],"dig_$_",'',0) for 0..80;#exit;
    for(0..80){
	next if !ref$dig[$_] or @{$dig[$_]} != 2;
	my $pair = join',',@{$dig[$_]};
	my @nb_same = grep{ref$dig[$_] and join(',',@{$dig[$_]}) eq $pair} @{ $NB[$_] };
	print "$_ has pair $pair and so has: @nb_same\n" #and exit
	    if @nb_same;
    }
    @dig
}

sub valid_sudoku_result {
    my $s = shift;
    state @NB = _sudoku_neighbours();
    die if $s !~ /^[1-9]{81}$/;
    all { my $d = substr($s,$_,1); !any { $d == substr($s,$_,1) } @{ $NB[$_] } } 0 .. 80
}

__END__
perl t/test_sudoku.pl
sudoku_com_easy                 0.002s
sqlite_example                  0.003s
hm                              0.006s
sudoku_com_expert               0.007s
sudoku_com_hard                 0.011s
websudoku_com_evil_3640514182   0.015s
websudoku_com_evil_6670389185   0.021s
websudoku_com_hard_35742904     0.021s
github                          0.072s
sudoku_com_extreme              0.135s
websudoku_com_evil_6375679867   0.172s
sudoku_com_evil                 0.324s
youtube_Ui1hrp7rovw             0.817s
SUM RUNTIME                     1.607s

se også:
- https://raw.githubusercontent.com/jacoby/SudokuSolver/refs/heads/master/solve_sudoku.pl
- https://metacpan.org/pod/Regexp::Sudoku
- https://logic-masters.de/Raetselportal/Raetsel/zeigen.php?id=0000YB
- https://www.google.com/search?q=sudoku+magic+square
