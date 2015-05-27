# make test
# perl Makefile.PL; make; perl -Iblib/lib t/24_db.t

BEGIN{require 't/common.pl'}
use Test::More tests => 17;

my $f='/tmp/acme-tools.sqlite';
unlink($f);
dblogin($f);
dbdo(<<"");
  create table tst (
    a integer primary key,
    b varchar2,
    c date
  )

dbdo("insert into tst values ".
      join",",
      map "(".join(",",$_,"'xyz'",time_fp()).")",
      1..100);
ok( 100 == dbrow("select sum(1) from tst") );
dblogout();
