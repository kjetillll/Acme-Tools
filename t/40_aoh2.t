# make;perl -Iblib/lib t/40_aoh2.t
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests => 2;
my @oceania=map{$$_{Continent}=>'OCE';$_} (
  {Area=>undef,   Capital=>'Pago Pago',        Code=>'AS', Name=>'American Samoa',                       Population=>54343}, 
  {Area=>7686850, Capital=>'Canberra',         Code=>'AU', Name=>'Australia',                            Population=>22751014}, 
  {Area=>undef,   Capital=>'West Island',      Code=>'CC', Name=>'Cocos (Keeling) Islands',              Population=>596}, 
  {Area=>240,     Capital=>'Avarua',           Code=>'CK', Name=>'Cook Islands',                         Population=>9838}, 
  {Area=>undef,   Capital=>'Flying Fish Cove', Code=>'CX', Name=>'Christmas Island',                     Population=>1530}, 
  {Area=>18270,   Capital=>'Suva',             Code=>'FJ', Name=>'Fiji',                                 Population=>909389}, 
  {Area=>702,     Capital=>'Palikir',          Code=>'FM', Name=>'Micronesia, Federated States of',      Population=>105216}, 
  {Area=>549,     Capital=>'Hagatna (Agana)',  Code=>'GU', Name=>'Guam',                                 Population=>161785}, 
  {Area=>undef,   Capital=>undef,              Code=>'HM', Name=>'Heard Island and McDonald Islands',    Population=>0}, 
  {Area=>811,     Capital=>'Tarawa',           Code=>'KI', Name=>'Kiribati',                             Population=>105711}, 
  {Area=>181.3,   Capital=>'Majuro',           Code=>'MH', Name=>'Marshall Islands',                     Population=>72191}, 
  {Area=>19060,   Capital=>'Noumea',           Code=>'NC', Name=>'New Caledonia',                        Population=>271615}, 
  {Area=>undef,   Capital=>'Kingston',         Code=>'NF', Name=>'Norfolk Island',                       Population=>2210}, 
  {Area=>21,      Capital=>'Yaren District',   Code=>'NR', Name=>'Nauru',                                Population=>9540}, 
  {Area=>260,     Capital=>'Alofi',            Code=>'NU', Name=>'Niue',                                 Population=>1190}, 
  {Area=>268680,  Capital=>'Wellington',       Code=>'NZ', Name=>'New Zealand',                          Population=>4438393}, 
  {Area=>undef,   Capital=>'Papeete',          Code=>'PF', Name=>'French Polynesia',                     Population=>282703}, 
  {Area=>462840,  Capital=>'Port Moresby',     Code=>'PG', Name=>'Papua New Guinea',                     Population=>6672429}, 
  {Area=>undef,   Capital=>'Adamstown',        Code=>'PN', Name=>'Pitcairn',                             Population=>48}, 
  {Area=>458,     Capital=>'Melekeok',         Code=>'PW', Name=>'Palau',                                Population=>21265}, 
  {Area=>28450,   Capital=>'Honiara',          Code=>'SB', Name=>'Solomon Islands',                      Population=>622469}, 
  {Area=>undef,   Capital=>undef,              Code=>'TK', Name=>'Tokelau',                              Population=>1337}, 
  {Area=>26,      Capital=>'Funafuti',         Code=>'TV', Name=>'Tuvalu',                               Population=>10869}, 
  {Area=>undef,   Capital=>undef,              Code=>'UM', Name=>'United States Minor Outlying Islands', Population=>undef}, 
  {Area=>12200,   Capital=>'Port-Vila',        Code=>'VU', Name=>'Vanuatu',                              Population=>272264}, 
  {Area=>undef,   Capital=>'Mata-Utu',         Code=>'WF', Name=>'Wallis and Futuna',                    Population=>15500}, 
  {Area=>2944,    Capital=>'Apia',             Code=>'WS', Name=>'Samoa (Western)',                      Population=>197773}
);
my $sql1=aoh2sql(\@oceania,{name=>'country',drop=>2});
my $sql2=<<'.';
begin;

drop table if exists country;

create table country (
  Area                           numeric(9,1),
  Capital                        varchar(16),
  Code                           varchar(2) not null,
  Name                           varchar(36) not null,
  Population                     numeric(9)
);

insert into country values (null,'Pago Pago','AS','American Samoa',54343);
insert into country values (7686850,'Canberra','AU','Australia',22751014);
insert into country values (null,'West Island','CC','Cocos (Keeling) Islands',596);
insert into country values (240,'Avarua','CK','Cook Islands',9838);
insert into country values (null,'Flying Fish Cove','CX','Christmas Island',1530);
insert into country values (18270,'Suva','FJ','Fiji',909389);
insert into country values (702,'Palikir','FM','Micronesia, Federated States of',105216);
insert into country values (549,'Hagatna (Agana)','GU','Guam',161785);
insert into country values (null,null,'HM','Heard Island and McDonald Islands',0);
insert into country values (811,'Tarawa','KI','Kiribati',105711);
insert into country values (181.3,'Majuro','MH','Marshall Islands',72191);
insert into country values (19060,'Noumea','NC','New Caledonia',271615);
insert into country values (null,'Kingston','NF','Norfolk Island',2210);
insert into country values (21,'Yaren District','NR','Nauru',9540);
insert into country values (260,'Alofi','NU','Niue',1190);
insert into country values (268680,'Wellington','NZ','New Zealand',4438393);
insert into country values (null,'Papeete','PF','French Polynesia',282703);
insert into country values (462840,'Port Moresby','PG','Papua New Guinea',6672429);
insert into country values (null,'Adamstown','PN','Pitcairn',48);
insert into country values (458,'Melekeok','PW','Palau',21265);
insert into country values (28450,'Honiara','SB','Solomon Islands',622469);
insert into country values (null,null,'TK','Tokelau',1337);
insert into country values (26,'Funafuti','TV','Tuvalu',10869);
insert into country values (null,null,'UM','United States Minor Outlying Islands',null);
insert into country values (12200,'Port-Vila','VU','Vanuatu',272264);
insert into country values (null,'Mata-Utu','WF','Wallis and Futuna',15500);
insert into country values (2944,'Apia','WS','Samoa (Western)',197773);
commit;
.
is( $sql1, $sql2, 'correct' );

eval{ require Spreadsheet::WriteExcel };
if($@){
	ok(1,'Spreadsheet::WriteExcel not installed, skip test for aoh2xls()');
	exit;
}
my $workbook = Spreadsheet::WriteExcel->new('/tmp/40_aoh2.xls');
my $worksheet = $workbook->add_worksheet();
my $format = $workbook->add_format(); # Add a format
$format->set_bold();
$format->set_color('red');
$format->set_align('center');
$col = $row = 0;
$worksheet->write($row, $col, 'Hi Excel!', $format);
$worksheet->write(1,    $col, 'Hi Excel!');
# Write a number and a formula using A1 notation
$worksheet->write('A3', 1.2345);
$worksheet->write('A4', '=SIN(PI()/4)');
ok(1);