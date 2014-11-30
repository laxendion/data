#!/usr/bin/perl -s
	
use Encode;
use Encode::HanExtra;
use Unicode::String qw(utf8);

	if ($#ARGV != 2){
	    print "$#ARGV Usage:\n\t$0 file_name orig_encode start-end\n\tEX:$0 xxx.mrc big5 1-1000\n";
	    exit;
	}
	
	my $file_name = $ARGV[0];
	my $orig_encode = $ARGV[1];
	my ($marc_start,$marc_end) = split(/-/, $ARGV[2]);
	my $marc_number=1;
	
	open F, "< $file_name" or die "Can't open $file_name : $!";
	while (my $file=<F>) {
	    @marc_record = split(/\x1D/,$file); 
	}
	
	foreach my $marc_record (@marc_record) {
	    if (($marc_number >= $marc_start) && ($marc_number <= $marc_end)){
	        my ($marc, $ret) = cmarc($marc_record);
	        print "$marc";
	        #warn "$ret";
	    }
	    $marc_number++;
	}
	
	sub cmarc {
	        my $reco = shift;
	        my $len = substr ( $reco,13,4);
	        my $l1= substr ($reco,25,($len-25));
	        my $pos = 24;
	        my $base=$len;
	        my $newpos;
	        my $newmarc='';
	        my $newtag='';
	        my $ret='';
	        for ( my $k=0; $k<=(length ($l1)/12)-1 ; $k ++) { 
	                my $mar= substr ( $reco,$pos,12);
	                $pos = $pos+12;
	                my $tag = substr ($mar,0,3);
	                if ($tag eq '200' and $ret eq '') {$ret ='UNIMARC';}
	                else {
	                        if ( $tag eq '245'and $ret eq '') { $ret='MARC21';}
	                }
	
	                my $length =substr ($mar,3,4);
	                my $position = substr($mar,7,5);
	#my $marc = utf8(substr ( $reco,$base,$length));
	                my $marc = encode("utf8", decode($orig_encode,substr ( $reco,$base,$length)));
	                $newtag=$newtag.$tag.newval(4,length ($marc)).newval(5,$newpos);
	                $newmarc=$newmarc.$marc;
	                $newpos = $newpos+newval(4,length ($marc));
	                $base= $base+$length;
	        }
	$newtag=$newtag.substr ($reco,$len-1,1);
	        my $tag= newval(5,(24+length($newtag)+length ($newmarc))).substr($reco,5,7).newval(5,(24+length($newtag))).substr($reco,17,7).$newtag.$newmarc."\x1D";
	        return $tag,$ret;
	}
	
	sub newval {
	        my ($count,$i) = @_;
	        my $newval='';
	        my $l = $count - length ($i);
	        for (my $i=0; $i< $l; $i ++) {
	                $newval=$newval."0";
	        }
	        return $newval.$i;
	
	}
