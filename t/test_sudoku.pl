use Acme::Tools qw(srlz time_fp);
use Time::HiRes qw(time);
use DBI;
use List::Util  qw(any all uniq first);
use Storable    qw(dclone);
use v5.14;

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
    sqlite_example => {
        input => '53..7....6..195....98....6.8...6...34..8.3..17...2...6.6....28....419..5....8..79',
        result=> '534678912672195348198342567859761423426853791713924856961537284287419635345286179'},
    youtube_1 => { #https://www.youtube.com/watch?v=Ui1hrp7rovw
      input => '...1.2... .6.....7. ..8...9..
                4.......3 .5...7... 2...8...1
                ..9...8.5 .7.....6. ...3.4...',
      result=> '9341726585 61948372 728635914
                4172695838 53417296 296583741
                1497268353 72851469 685394127',
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
    # sudokupad_app_7gJb9G8fRt=> { #https://sudokupad.app/7gJb9G8fRt == youtube_1 !
    #   input => '...1.2....6.....7...8...9..4.......3.5...7...2...8...1..9...8.5.7.....6....3.4...',
    #   result=> '934172658561948372728635914417269583853417296296583741149726835372851469685394127',
    # },
    hm=> { #
      input => '.................................................................................',
      result=> '987654321654321987321987654896745213745213896213896745579468132468132579132579468',
    },

);

my @RE;
my $err=0;
for my $name ( sort keys %test) {
    #next if $name ne 'hm';
    #next if $name =~ /youtube/;
    my($i,$w)=
        map s/\s//gr,
        @{ $test{$name} }{'input','result'};
    printf "---- name: $name ----\n";
    my $t=time();
    #my $g=sudoku_sqlite($i);
    my $g=sudoku($i);
    #my $g=sudoku_simple($i);
    $err+=$g ne $w;
    printf "input: $i\nwant:  $w\ngot:   $g\ntime:  %.3f seconds\ntest:  %s\n\n", time()-$t, $g eq $w ? "ok" : "err";
#    last;
}
print $err ? "*** ERRORS: $err ***\n" : "All tests ok\n";

our(@RE, @NB, %is_NB);
sub sudoku {
    my $s = shift;
    if(!@RE){ #init
	use integer;
	@NB = map { //; #20 neighbor pos list for each 81 pos
		   [ uniq sort{$a<=>$b} grep $_-$',
		     ( map { $'/9*9+$_-1                       } 1..9 ),
		     ( map { $'%9+($_-1)*9                     } 1..9 ),
		     ( map { $'/3%3*3+$'/27*27+$_+($_-1)/3*6-1 } 1..9 ) ] } 0..80;
	#print srlz(\@NB,'NB','',0)=~s/'//gr;exit;
	for my $i (0..80){ $is_NB{$i,$_} = $is_NB{$_,$i} = 1 for @{ $NB[$i] } }
	for my $z ( 1..9 ){
	    //,$RE[$'*9+$z-1] = qr/^@{[ join'', map $is_NB{$',$_} ? "[^$z]" : ".", 0 .. 80 ]}$/ for 0..80;
	}
    }
    my $dig = sub{ my $s=pop; map { my @nb = @{$NB[$_]}; $s =~ /^.{$_}\d/ ? 0 : [grep {//;all{$'-substr$s,$_,1}@nb} 1..9] } 0..80 };
    my @dig = &$dig($s);
    my @w = ($s);
    my @r;
    while( my $w = pop @w ){
	my $i = index $w, '.';
	push @r, $w and !wantarray and last if $i<0;
	my($pre, $post);
        push @w, map { ($pre//=substr($w,0,$i)) . $_ . ($post//=substr($w,$i+1)) }
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
