#!/usr/bin/perl -s

use Encode;
	
#use Encode::HanExtra;
#use Unicode::String qw(utf8);
#use MARC::Record;
#use MARC::Field;

	my $file_name = $ARGV[0];
	my $f = ($ARGV[1])?$ARGV[1]:"utf8";
	my $t = ($ARGV[2])?$ARGV[2]:"utf8";

	open F, "< $file_name" or die "Can't open $file_name : $!";
	my @a='';
	while (my $file=<F>) {
	      @marc_record = split(/\x1D/,$file); 
	}
	
	foreach my $marc_record (@marc_record) {
	        my @field = split(/\x1E/,$marc_record);
	        my $head = $field[0];
	        my $leader = substr($head,0,23);
	        my $record_directory = substr($head,24);
	        my $field_count =length($record_directory)/12;

	        if ($field_count != $#fieild){
#	                warn "fields number($field_count ne $#field) nor correct!";
			skip;
	        } else {
	                my $marc_fields = substr($marc_record,(length($head)+1));
	                my $new_start_pos = 0;
	                for (my $i=0;$i<$field_count;$i++){
	                        $field_head = substr($record_directory,($i*12),12);
	                        my $tag = substr($field_head,0,3); 
	                        my $length = substr($field_head,3,4); 
	                        my $start_pos = substr($field_head,7,5); 
				my $field_data = substr($marc_fields,($start_pos),($length-1));
	                        my @subfield = split(/\x1F/,$field_data); 
	                        $tag = encode("utf8", decode("big5",$tag));
	                        warn "$tag\t";
	                        my $new_length = length(encode($t, decode($f,$field_data)))+1;
	                        foreach (@subfield){
	                                my $data = encode($t, decode($f,$_));
	                                warn "$data ";
	                        }
	                        warn "WARN:: $field_head, $tag, $length, $start_pos\n";
	                        warn "WARN:: $field_head, $tag, $new_length, $new_start_pos\n";
	                        $new_start_pos = $new_start_pos+$new_length;
	                        warn "\n";
	                       
	                }
	        }
	        warn "=======NEXT MARC=======\n";
	}
