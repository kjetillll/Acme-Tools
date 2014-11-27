#!/bin/bash
#run as cronscript

#f=$1
f=/htdocs/currency-rates


/bin/echo "#-- Currency rates "`date`" ("`date +%s`")" > $f

/usr/bin/curl -s "http://www.x-rates.com/table/?from=NOK&amount=1.00" | /usr/bin/perl -MAcme::Tools -le '$d=join"",<>;$d=~s,to=([A-Z]{3})(.)>,$2>$1</td><td>,g;@d=ht2t($d,"Alphabetical order");shift@d;print"$$_[1] $$_[4]" for@d' | /usr/bin/sort >> $f

/usr/bin/ci -l -m. -d $f

