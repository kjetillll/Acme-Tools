# make test
# perl Makefile.PL; make; perl -Iblib/lib t/26_openstr.t

BEGIN{require 't/common.pl'}
use Test::More tests => 8;
sub ookk {
    if($^O ne 'linux'){ok(1);return}
    my($s,$f)=@_;
    my $o=openstr($s);
    $o=~s,/\S+/,,g;
    ok($o eq $f, "$s --> $f  (is $o)");
}
ookk( "fil.txt", "fil.txt" );
ookk( "fil.gz", "zcat fil.gz |" );
ookk( "fil.bz2", "bzcat fil.bz2 |" );
ookk( "fil.xz", "xzcat fil.xz |" );
ookk( ">fil.txt", ">fil.txt" );
ookk( ">fil.gz", "| gzip>fil.gz" );
ookk( " > fil.bz2", "| bzip2 > fil.bz2" );
ookk( "  >   fil.xz", "| xz  >   fil.xz" );
