# perl Makefile.PL;make;perl -Iblib/lib t/12_ht2t.t
use strict;
use warnings;
sub deb($){print STDERR @_ if $ENV{ATDEBUG}}
use Test::More tests => 3;
BEGIN { use_ok('Acme::Tools') };
my $html=join"",<DATA>;
#$html.=readfile("Norske_kommuner.iso8859-1");
my %ent=(amp => '&', 160 => ' ');
my $entqr=join"|",keys%ent;
$html=~s,&#?($entqr);,$ent{$1},g;
my @t1=ht2t($html,"Tab");
my @t2=ht2t($html,"Table-2");
#my @k=ht2t($html,"Oslo fylke");
ok(  serialize(\@t1,'t1') eq q(@t1=(['123','Abc'],['997','XYZ']);)."\n"                  );
ok(  serialize(\@t2,'t2') eq q(@t2=(['ZYX','SOS'],['SMS','OPP'],['WTF','BMW']);)."\n"    );
#print serialize(\@k,'k','',1);

__DATA__
<html><body>
Table-1
<table>
<tr><td>123</td><td> Abc</td></tr>
<tr><td>997</td><td>XYZ </td></tr>
</table>
Table-2 is here:
<table>
<tr><td>ZYX</td><td>SOS</td></tr>
<tr><td>SMS</td><td>OPP</td></tr>
<tr><td>WTF</td><td>BMW</td></tr>
</table>
