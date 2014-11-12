# perl Makefile.PL;make;perl -Iblib/lib t/12_ht2t.t
BEGIN{require 't/common.pl'}
use Test::More tests => 2;
my $html=join"",<DATA>;
#$html.=readfile("Norske_kommuner.iso8859-1");
my %ent=(amp => '&', 160 => ' ');
my $entqr=join"|",keys%ent;
#$html=~s,&#?($entqr);,$ent{$1},g;
my @t1=ht2t($html,"Tab");
my @t2=ht2t($html,"Table-2");
#my @k=ht2t($html,"Oslo fylke");#print serialize(\@k,'k','',1);
ok_ref( \@t1, [ ['123','Abc&def'],['997','XYZ']],           't1');
ok_ref( \@t2, [ ['ZYX','SOS'],['SMS','OPP'],['WTF','BMW']], 't2');

__DATA__
<html><body>
Table-1
<table>
<tr><td>123</td><td> Abc&amp;def</td></tr>
<tr><td>997</td><td>XYZ </td></tr>
</table>
Table-2 is here:
<table>
<tr><td>ZYX</td><td>SOS</td></tr>
<tr><td>SMS</td><td>OPP</td></tr>
<tr><td>WTF</td><td>BMW</td></tr>
</table>
