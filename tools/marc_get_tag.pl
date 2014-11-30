#!/usr/bin/perl -w

use MARC::Batch;
use MARC::Record;
use MARC::Field;

if(!defined($ARGV[0])) {
	print "please input file name\n";
	exit;
}

my $file_name = $ARGV[0];
my $batch = MARC::Batch->new('USMARC',$file_name);

$batch->strict_off();
$batch->warnings_off();

my %tags;

while ( my $record = $batch->next() ) {
	my @fields = $record->fields();
	    foreach my $field (@fields){
	        my $tag = $field->tag();
	        my @subtag;
	        #warn "tag = ".$tag;
	        next if ($tag eq '001');
	        next if ($tag eq '008');
	        if (defined($record->field($tag))){
	            @subtag = $record->field($tag)->subfields();
	            foreach (@subtag){
	                $tags{"$tag@{$_}[0]"}++;
	            }
	        }
	    }
	}
	
	foreach (sort { $a <=> $b } keys(%tags)){
	    print "$_ = $tags{$_}\n";
	}
