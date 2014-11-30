#!/usr/bin/perl -w

use DBI;

$event_SQL_DB="koha";
$event_SQL_HOST="localhost";
$event_SQL_USER="koha";
$event_SQL_PASS="abc100";

$dbh_event = DBI->connect("DBI:mysql:database=$event_SQL_DB;host=$event_SQL_HOST;mysql_multi_results=1", $event_SQL_USER, $event_SQL_PASS);

$dbh_events = DBI->connect("DBI:mysql:database=$event_SQL_DB;host=$event_SQL_HOST;mysql_multi_results=1", $event_SQL_USER, $event_SQL_PASS);

$SQL = "SET NAMES 'utf8'";
$sth_event = $dbh_event->prepare($SQL);
$sth_event->execute;

$SQL = "select biblionumber, biblioitemnumber from biblioitems;";
$sth_event = $dbh_event->prepare($SQL);
$sth_event->execute;

	$i = 1;

while ($row = $sth_event->fetchrow_hashref) {
	
		
		print "id = $row->{biblioitemnumber} , pub = $row->{biblionumber} \n";

		$sth_events = $dbh_events->prepare(qq{insert into items
			(
			itemnumber, biblionumber, biblioitemnumber, barcode, 
			dateaccessioned, homebranch, replacementpricedate, 
			datelastseen, notforloan, damaged, itemlost, wthdrawn,
			holdingbranch, itype , issues			
 			) values (? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,? ,?)});

		$sth_events->execute( 
		$i, $row->{biblionumber}, $row->{biblioitemnumber} , 
		$i, '2010-11-10', 'Lins', '2010-11-07',
		'2010-11-10', '0', '0', '0', '0', 'Lins', 'BK', '1'
		);		

		print "id = $i\n";
		$i++;
				

}

$dbh_events->disconnect;
$dbh_event->disconnect;

