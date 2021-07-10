# make test
# perl Makefile.PL && make && perl -Iblib/lib t/24_db.t
use lib '.'; BEGIN{require 't/common.pl'}
use Acme::Tools;
use Test::More tests=>7;
my $dsminver='1.32_02';  #minumum $DBD::SQLite::VERSION
SKIP:{
  skip "DBD::SQLite not installed",      7 if !eval{require DBD::SQLite};
  skip "DBD::SQLite::VERSION $DBD::SQLite::VERSION lt $dsminver",7 if $DBD::SQLite::VERSION le $dsminver;
  $ENV{ATDEBUG} and print "${_}::VERSION = ".eval('$'.$_.'::VERSION')."\n" for qw(Acme::Tools DBI DBD::SQLite);

  my $tmp=tmp();
  my $f="$tmp/acme-tools.sqlite"; unlink $f if -e$f;
  dlogin($f);
  ddo(<<"");
    create table tst (
      a integer primary key,
      b varchar2,
      c date,
      dd --no type
    )

  my $sql="insert into tst values ".
           join",", map "(".join(",", map"'$_'", $_, $_%2?"XYZ":"ABC", 1.1+$_/4, 1.1+$_/4).")", 1..50;
  #$sql=~s,'\),0'),g; #die$sql;
  ddo($sql);
  ddo("insert into tst values (?,?,?,?)", $_, $_%2? 'XYZ' : 'ABC', 1.1+$_/4, 1.1+$_/4) for 51..100;
  my @tst=drows('tst');
  dcommit();
  for( [100,"select sum(1) from tst"],
       [3,"select count(*) from tst where b = ? and c <= ?", 'ABC', 2.99],
       [4,"select count(*) from tst where b = ? and c <= ?", 'XYZ', 2.99],
       [0,"select count(*) from tst where b = ? and dd <= ?", 'XYZ', 2.99],
       [6,"select count(*) from tst where b = ? and 0+dd <= 0+?", 'XYZ', 3.99], #delete on 6
       [undef,"select sum(1) from tst"],
  ){
    my($exp,$s,@b)=@$_;
    my $got=drow($s,@b);
    is($got,$exp,"$s --> $got vs $exp");
    ddo("delete from tst") if $exp==6;
  }
  dins('tst',@tst);
  is(drow("select sum(1) from tst"),100,'100 again');

  dlogout();

  ##print qx( sqlite3 $f .schema );
  #print qx( sqlite3 $f .dump | head -20 );
  #print qx( sqlite3 $f .dump | tail -4 );

} #SKIP: