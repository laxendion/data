#!/usr/bin/perl

use MARC::Batch;


my $batch = MARC::Batch->new('USMARC', './koha.mrc');

$i = 0;

while(my $record = $batch->next()){

#	my @fields = $record->fields();
	
#print $record->as_formatted() . "\n";

$i++;

}

print "data = $i\n"; 
