#!/usr/bin/perl -s

use DBI;

$event_SQL_DB="koha";
$event_SQL_HOST="localhost";
$event_SQL_USER="koha";
$event_SQL_PASS="abc100";

$dbh_event = DBI->connect("DBI:mysql:database=$event_SQL_DB;host=$event_SQL_HOST;mysql_multi_results=1", $event_SQL_USER, $event_SQL_PASS);

$SQL = "SET NAMES 'utf8'";
$sth_event = $dbh_event->prepare($SQL);
$sth_event->execute;

for($i = 1; $i <= 38652; $i++) {

$SQL = "select biblioitemnumber,  marcxml from biblioitems
where biblioitemnumber = $i;";

$sth_event = $dbh_event->prepare($SQL);
$sth_event->execute;

open(F, "> /root/cmarc/koha_data.xml");

while ($row = $sth_event->fetchrow_hashref) {
	
$row->{marcxml} =~ s/<\/record>/  <datafield tag="995" ind1=" " ind2=" ">
    <subfield code="o">0<\/subfield>
    <subfield code="r">bk<\/subfield>
    <subfield code="f">$i<\/subfield>
    <subfield code="0">0<\/subfield>
    <subfield code="9">2<\/subfield>
    <subfield code="c">Lins<\/subfield>
    <subfield code="1">0<\/subfield>
    <subfield code="a">Lins<\/subfield>
  <\/datafield>
<\/record>/;

	print F "$row->{marcxml}";
}

close(F);

$xmldata = undef;

open(KOHAXML, "< /root/cmarc/koha_data.xml");

while(<KOHAXML>){

	$_ =~ s/'/\\'/g;
	$xmldata = $xmldata . $_;
	
}

close(KOHAXML);

$SQL = "update biblioitems set marcxml = '$xmldata' where biblioitemnumber = $i;";
#print $SQL ;
$sth_event = $dbh_event->prepare($SQL);
$sth_event->execute;

}
$dbh_event->disconnect;
