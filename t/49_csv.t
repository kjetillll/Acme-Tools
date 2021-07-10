# make && perl -Iblib/lib t/49_csv.t
use lib '.'; BEGIN{require 't/common.pl'}
use Test::More tests => 6;

my @a=(
   ['Name',qq("Address\n(or something)"),'Age'],
   ['Jerry','Manhattan, NYC',35],
   ['George','Queens, NYC',35],
   ['Cosmo','New Jersey',42]
);

my $csv=csv(@a);

is($csv, <<'');
Name,"""Address
(or something)""",Age
Jerry,"Manhattan, NYC",35
George,"Queens, NYC",35
Cosmo,New Jersey,42

my @a2=uncsv($csv);

is_deeply(\@a2,\@a);

$csv=csv(@a,';');

is($csv, <<'');
Name;"""Address
(or something)""";Age
Jerry;Manhattan, NYC;35
George;Queens, NYC;35
Cosmo;New Jersey;42

@a2=uncsv($csv,';');

is_deeply(\@a2,\@a);

#---- from https://en.wikipedia.org/wiki/Comma-separated_values#Example
my @car=(
[qw(Year Make Model Description Price)],
[1997, 'Ford',  "E350\t ",                                'ac, abs, moon',                      '3000.00'],
[1999, 'Chevy', 'Venture "Extended Edition"',             '',                                   '4900.00'],
[1999, 'Chevy', 'Venture "Extended Edition, Very Large"', undef,                                '5000.00'],
[1996, 'Jeep',  ' Grand Cherokee',                        "MUST SELL!\nair, moon roof, loaded", '4799.00']
);
is(csv(@car),<<'');
Year,Make,Model,Description,Price
1997,Ford,"E350	 ","ac, abs, moon",3000.00
1999,Chevy,"Venture ""Extended Edition""","",4900.00
1999,Chevy,"Venture ""Extended Edition, Very Large""",,5000.00
1996,Jeep," Grand Cherokee","MUST SELL!
air, moon roof, loaded",4799.00

is_deeply([uncsv(csv(@car))],\@car);
