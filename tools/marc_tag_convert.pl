#!/usr/bin/perl -w
use MARC::Batch;
use MARC::Field;

	my $file_name = $ARGV[0];
	my $convert_tab_file = $ARGV[1];
	my %mapping;
	my %orig_tag;
	my %orig_data;
	my %merge_data;
	my %new_data;
	my %added_tag_count;
	my %new_tag_count;
	
	open F, "< $convert_tab_file" or die "Can't open $file_name : $!";
	
	while (my $tag_map=<F>) {
	    my ($k, $v) = split/,/,$tag_map;
	    $mapping{$k}=$v;
	#    warn "$k->$mapping{$k}\n";
	}

	foreach my $map (keys(%mapping)){
	    my @tag = split/\+/,$map;
	    foreach (@tag) {
	        my $tag = substr($_,0,3);
	        my $subtag = substr($_,3,1);
	#       warn "$tag, $subtag\n";
	        my $key="$tag,$subtag";
	        $orig_tag{$key} = $map;
	    }
	}
	
	
	my $batch = MARC::Batch->new('USMARC',$file_name);
	$batch->strict_off();
	$batch->warnings_off();
	my $rid = 0;
	my $nrid = 0;
	while ( my $record = $batch->next() ) {
	
	    my @field = $record->fields();
	    my $i = 0;
	    foreach my $field (@field){
	        foreach my $tag_str (keys(%orig_tag)){
	       
	            my($tag, $subtag) = split/,/,$tag_str;
	            if (($field->tag() eq $tag) && ($field->subfield($subtag))){
	
	                my $key = "$rid,$i,$tag_str";
	#warn $rid.",".$i.",".$tag_str;
	                $orig_data{$key} = $field->subfield($subtag);
	            }
	        }
	        $i++;
	    }
	    $rid++;
	}
	
	#    foreach my $key (keys(%orig_data)){
	#       warn "orig_data".$key." = ".$orig_data{$key};
	#    }
	
	    foreach my $kmap (keys(%mapping)){
	        foreach my $key (keys(%orig_data)) {
	            my($or_id, $or_i, $or_tag, $or_subtag) = split/,/,$key;
	            my $key_with_map = "$or_id,$or_i,$kmap";
	            my @tag = split/\+/,$kmap;
	            if ($#tag > 0) {
	                foreach (@tag) {
	                    my $k_tag = substr($_,0,3);
	                    my $k_subtag = substr($_,3,1);
	                    my $key_with_map = "$or_id,$or_i,$kmap";
	                    if (($k_tag eq $or_tag) && ($k_subtag eq $or_subtag)) {
	                        $merge_data{$key_with_map} .= $orig_data{"$or_id,$or_i,$k_tag,$k_subtag"}." ";
	#warn "merge process ".$_.$key_with_map.$merge_data{$key_with_map};
	                        last;
	                    }
	                }
	            } else {
	                my $k_tag = substr($kmap,0,3);
	                my $k_subtag = substr($kmap,3,1);
	                if ($kmap eq "$or_tag$or_subtag") {
	                    $merge_data{$key_with_map} = $orig_data{"$or_id,$or_i,$k_tag,$k_subtag"};
	                }
	            }
	        }
	    }
	
	   
	#    foreach my $key (keys(%merge_data)){
	#       warn "merge_data".$key." = ".$merge_data{$key};
	#    }
	
	    foreach my $key (keys(%merge_data)) {
	        my($merge_rid, $merge_i, $merge_tagsubtag) = split/,/,$key;
	        my $newtag_subtag = $mapping{$merge_tagsubtag};
	        my $newtag = substr($newtag_subtag,0,3);
	        my $newsubtag = substr($newtag_subtag,3,1);
	        my $new_key = "$merge_rid,$merge_i,$newtag";
	        $new_data{$new_key} .= "$newsubtag\=$merge_data{$key},";
	    }
	
	    foreach my $key (keys(%new_data)){
	        my ($n_rid, $n_data_i, $n_data_tag) = split/,/,$key;
	        $new_tag_count{"$n_rid,$n_data_tag"}++;
	        warn "new_data".$key." = ".$new_data{$key};
	    }
	
	my $batch2 = MARC::Batch->new('USMARC',$file_name);
	$batch2->strict_off();
	$batch2->warnings_off();
	while ( my $record = $batch2->next() ) {
	        foreach my $new_data_key (keys(%new_data)) {
	        my ($new_rid, $new_data_i, $new_data_tag) = split/,/,$new_data_key;
	        if ($new_rid eq $nrid){
	warn "ID:".$nrid." fid ".$new_data_i;
	            my $tag_field = $record->field($new_data_tag);
	            if (substr($new_data{$new_data_key}, -1,1) eq ',' ) {
	                $new_data{$new_data_key} = substr ($new_data{$new_data_key}, 0, -1);
	            }
	
	            if (($tag_field) && ($added_tag_count{"$new_rid,$new_data_tag"} eq $new_tag_count{"$new_rid,$new_data_tag"})){
	                my @sub_value = split/,/,$new_data{$new_data_key};
	                foreach my $value (@sub_value){
	warn "exist tag = ".$new_data_tag;
	                    my($code, $value) = split/\=/,$value;
	                    $tag_field->add_subfields($code => $value);
	                }
	       
	            } else {
	warn "new tag = ".$new_data_tag;
	                my %sub_data;
	                my @sub_value = split/,/,$new_data{$new_data_key};
	                foreach (@sub_value){
	                    my($code, $value) = split/\=/,$_;
	                    $sub_data{$code} = $value;
	                }
	                my $newfield = MARC::Field->new(
	                    $new_data_tag, '', '', %sub_data);
	                $record->insert_fields_ordered($newfield);
	                $added_tag_count{"$new_rid,$new_data_tag"}++;
	            }
	        }
	        }
	

	    ## print marc.
	    print $record->as_usmarc();
	    $nrid++;
	}
