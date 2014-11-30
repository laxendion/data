#!/usr/bin/perl 
 
use ZOOM;
use Encode;
use Encode::HanExtra;
 
 #eval {
@aa = qw/
/;


open(FILE, './iso27001_1');

$conn = new ZOOM::Connection("202.197.127.197:210/cnmarc");
$conn->option(preferredRecordSyntax => "usmarc" , 'timeout' => 60);

foreach(@aa) {

eval {

	#print $_ . "\n";

	$sd = "\@attr 1=7 $_";

	$rs =$conn->search_pqf($sd);
	$n = $rs->size();

	print cmarc($rs->record(0)->raw());

	#print "\n";

}

    #sleep(10);
}

close(FILE);
#print cmarc($rs->record(0)->raw());
	 #print cmarc($rs->record(0)->render());
 #};
 
 #if ($@) {
 #  print "Error ", $@->code(), ": ", $@->message(), "\n";
 #}
 
sub cmarc {
   my $reco = shift;
   my $len = substr ($reco,13,4);
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


    my $marc = encode("utf8",decode("gb18030",substr($reco,$base,$length)));

    $newtag=$newtag.$tag.newval(4,length ($marc)).newval(5,$newpos);
    $newmarc=$newmarc.$marc;
    $newpos = $newpos+newval(4,length ($marc));
    $base= $base+$length;

  }

        $newtag=$newtag.substr ($reco,$len-1,1);
        my $tag= newval(5,(24+length($newtag)+length ($newmarc))).substr($reco,5,7).newval(5,(24+length($newtag))).substr($reco,17,7).$newtag.$newmarc."\x1D";

#       return $tag,$ret;
        return $tag;

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