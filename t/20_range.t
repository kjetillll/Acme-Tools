# make test
# perl Makefile.PL; make; perl -Iblib/lib t/20_range.t

BEGIN{require 't/common.pl'}
use Test::More tests => 7;

ok_ref([range(11)],     [0,1,2,3,4,5,6,7,8,9,10], 'range(11)' );
ok_ref([range(2,11)],   [2,3,4,5,6,7,8,9,10],     'range(2,11)' );
ok_ref([range(11,2,-1)],[11,10,9,8,7,6,5,4,3],    'range(11,2,-1)' );
ok_ref([range(2,11,3)], [2,5,8],                  'range(2,11,3)' );
ok_ref([range(11,2,-3)],[11,8,5],                 'range(11,2,-3)' );
ok_ref([range(2,11,1,0.1)],      [2, 3, 4.1, 5.3,  6.6,  8,   9.5       ],'range(2,11,1,0.1)');
ok_ref([range(2,11,1,0.1,-0.01)],[2, 3, 4.1, 5.29, 6.56, 7.9, 9.3, 10.75],'range(2,11,1,0.1,-0.01)');
