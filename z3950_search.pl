#!/usr/bin/perl

# This is a completely new Z3950 clients search using async ZOOM -TG 02/11/06
# Copyright 2000-2002 Katipo Communications
#
# This file is part of Koha.
#
# Koha is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# Koha is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with Koha; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

use strict;
#use warnings; FIXME - Bug 2505
use CGI;

use C4::Auth;
use C4::Output;
use C4::Biblio;
use C4::Context;
use C4::Breeding;
use C4::Koha;
use C4::Charset;
use ZOOM;
#use Encode qw/encode decode/; 
use Encode;
use Encode::HanExtra;

my $input        = new CGI;
my $dbh          = C4::Context->dbh;
my $error         = $input->param('error');
my $biblionumber  = $input->param('biblionumber') || 0;
my $frameworkcode = $input->param('frameworkcode');
my $title         = $input->param('title');
my $author        = $input->param('author');
my $isbn          = $input->param('isbn');
my $issn          = $input->param('issn');
my $lccn          = $input->param('lccn');
my $lccall        = $input->param('lccall');
my $subject       = $input->param('subject');
my $dewey         = $input->param('dewey');
my $controlnumber	= $input->param('controlnumber');
my $stdid			= $input->param('stdid');
my $srchany			= $input->param('srchany');
my $random        = $input->param('random') || rand(1000000000); # this var is not useful anymore just kept for rel2_2 compatibility
my $op            = $input->param('op');
my $numberpending;
my $attr = '';
my $term;
my $host;
my $server;
my $database;
my $port;
my $marcdata;
my @encoding;
my @results;
my $count;
my $record;
my $oldbiblio;
my $errmsg;
my @serverloop = ();
my @serverhost;
my @servername;
my @breeding_loop = ();

my $DEBUG = 0;    # if set to 1, many debug message are send on syslog.

my ( $template, $loggedinuser, $cookie ) = get_template_and_user({
        template_name   => "cataloguing/z3950_search.tmpl",
        query           => $input,
        type            => "intranet",
        authnotrequired => 1,
        flagsrequired   => { catalogue => 1 },
        debug           => 1,
});

$template->param( frameworkcode => $frameworkcode, );

if ( $op ne "do_search" ) {
    my $sth = $dbh->prepare("SELECT id,host,name,checked FROM z3950servers ORDER BY rank, name");
    $sth->execute();
    my $serverloop = $sth->fetchall_arrayref( {} );
    $template->param(
        isbn         => $isbn,
        issn         => $issn,
        lccn         => $lccn,
        lccall       => $lccall,
        title        => $title,
        author       => $author,
        controlnumber=> $controlnumber,
        stdid			=> $stdid,
        srchany		=> $srchany,
        serverloop   => $serverloop,
        opsearch     => "search",
        biblionumber => $biblionumber,
    );
    output_html_with_http_headers $input, $cookie, $template->output;
}
else {
    my @id = $input->param('id');

    if ( not defined @id ) {
        # empty server list -> report and exit
        $template->param( emptyserverlist => 1 );
        output_html_with_http_headers $input, $cookie, $template->output;
        exit;
    }

    my @oConnection;
    my @oResult;
    my @errconn;
    my $s = 0;
    my $query;
    my $nterms;
    if ($isbn || $issn) {
        $term=$isbn if ($isbn);
        $term=$issn if ($issn);
        $query .= " \@or \@attr 1=8 \"$term\" \@attr 1=7 \"$term\" ";
        $nterms++;
    }
    if ($title) {
#        utf8::decode($title);
	my $tmp = encode("gb18030",decode("utf8",$title));
        $query .= " \@attr 1=4 \"$tmp\" ";
        $nterms++;
    }
    if ($author) {
#        utf8::decode($author);
        my $tmp = encode("gb18030",decode("utf8",$author));
        $query .= " \@attr 1=1003 \"$tmp\" ";
        $nterms++;
    }
    if ($dewey) {
        $query .= " \@attr 1=16 \"$dewey\" ";
        $nterms++;
    }
    if ($subject) {
#        utf8::decode($subject);
        my $tmp = encode("gb18030",decode("utf8",$subject));
        $query .= " \@attr 1=21 \"$subject\" ";
        $nterms++;
    }
	if ($lccn) {	
        $query .= " \@attr 1=9 $lccn ";
        $nterms++;
    }
    if ($lccall) {
        $query .= " \@attr 1=16 \@attr 2=3 \@attr 3=1 \@attr 4=1 \@attr 5=1 \@attr 6=1 \"$lccall\" ";
        $nterms++;
    }
    if ($controlnumber) {
        $query .= " \@attr 1=12 \"$controlnumber\" ";
        $nterms++;
    }
    if ($stdid) {
        $query .= " \@attr 1=1007 \"$stdid\" ";
        $nterms++;
    }
    if ($srchany) {
        $query .= " \@attr 1=1016 \"$srchany\" ";
        $nterms++;
    }
for my $i (1..$nterms-1) {
    $query = "\@and " . $query;
}
warn "query ".$query  if $DEBUG;

    foreach my $servid (@id) {
        my $sth = $dbh->prepare("SELECT * FROM z3950servers WHERE id=? ORDER BY rank, name");
        $sth->execute($servid);
        while ( $server = $sth->fetchrow_hashref ) {
            warn "serverinfo ".join(':',%$server) if $DEBUG;
            my $option1      = new ZOOM::Options();
            $option1->option('async' => 1);
            $option1->option('elementSetName', 'F');
            $option1->option('databaseName', $server->{db});
            $option1->option('user',         $server->{userid}  ) if $server->{userid};
            $option1->option('password',     $server->{password}) if $server->{password};
            $option1->option('preferredRecordSyntax', $server->{syntax});
            $option1->option( 'timeout', $server->{timeout} ) if ($server->{timeout});
            $oConnection[$s] = create ZOOM::Connection($option1)
              || $DEBUG
              && warn( "" . $oConnection[$s]->errmsg() );
            warn( "server data", $server->{name}, $server->{port} ) if $DEBUG;
            $oConnection[$s]->connect( $server->{host}, $server->{port} )
              || $DEBUG
              && warn( "" . $oConnection[$s]->errmsg() );
            $serverhost[$s] = $server->{host};
            $servername[$s] = $server->{name};
            $encoding[$s]   = ($server->{encoding}?$server->{encoding}:"iso-5426");
            $s++;
        }    ## while fetch
    }    # foreach
    my $nremaining  = $s;
    my $firstresult = 1;

    for ( my $z = 0 ; $z < $s ; $z++ ) {
        warn "doing the search" if $DEBUG;
        $oResult[$z] = $oConnection[$z]->search_pqf($query)
          || $DEBUG
          && warn( "somthing went wrong: " . $oConnection[$s]->errmsg() );

        # $oResult[$z] = $oConnection[$z]->search_pqf($query);
    }

  AGAIN:
    my $k;
    my $event;
    while ( ( $k = ZOOM::event( \@oConnection ) ) != 0 ) {
        $event = $oConnection[ $k - 1 ]->last_event();
        warn( "connection ", $k - 1, ": event $event (",
            ZOOM::event_str($event), ")\n" )
          if $DEBUG;
        last if $event == ZOOM::Event::ZEND;
    }

    if ( $k != 0 ) {
        $k--;
        warn $serverhost[$k] if $DEBUG;
        my ( $error, $errmsg, $addinfo, $diagset ) =
          $oConnection[$k]->error_x();
        if ($error) {
            if ($error =~ m/^(10000|10007)$/ ) {
                push(@errconn, {'server' => $serverhost[$k], 'error' => $error});
            }
            $DEBUG and warn "$k $serverhost[$k] error $query: $errmsg ($error) $addinfo\n";
        }
        else {
            my $numresults = $oResult[$k]->size();
            my $i;
            my $result = '';
            if ( $numresults > 0 ) {
                for ($i = 0; $i < (($numresults < 20) ? $numresults : 20); $i++) {
                    my $rec = $oResult[$k]->record($i);
                    if ($rec) {
                        my $marcrecord;
			
			# modify
                        #$marcdata   = $rec->raw();

			$marcdata = cmarc($rec->raw());

                        my ($charset_result, $charset_errors);
                        ($marcrecord, $charset_result, $charset_errors) = 
                          MarcToUTF8Record($marcdata, C4::Context->preference('marcflavour'), $encoding[$k]);
####WARNING records coming from Z3950 clients are in various character sets MARC8,UTF8,UNIMARC etc
## In HEAD i change everything to UTF-8
# In rel2_2 i am not sure what encoding is so no character conversion is done here
##Add necessary encoding changes to here -TG
                        my $oldbiblio = TransformMarcToKoha( $dbh, $marcrecord, "" );
                        $oldbiblio->{isbn}   =~ s/ |-|\.//g if $oldbiblio->{isbn};
                        # pad | and ( with spaces to allow line breaks in the HTML
                        $oldbiblio->{isbn} =~ s/\|/ \| /g if $oldbiblio->{isbn};
                        $oldbiblio->{isbn} =~ s/\(/ \(/g if $oldbiblio->{isbn};

                        $oldbiblio->{issn} =~ s/ |-|\.//g if $oldbiblio->{issn};
                        # pad | and ( with spaces to allow line breaks in the HTML
                        $oldbiblio->{issn} =~ s/\|/ \| /g if $oldbiblio->{issn};
                        $oldbiblio->{issn} =~ s/\(/ \(/g if $oldbiblio->{issn};
                          my (
                            $notmarcrecord, $alreadyindb, $alreadyinfarm,
                            $imported,      $breedingid
                          )
                          = ImportBreeding( $marcdata, 2, $serverhost[$k], $encoding[$k], $random, 'z3950' );
                        my %row_data;
                        $row_data{server}       = $servername[$k];
                        $row_data{isbn}         = $oldbiblio->{isbn};
                        $row_data{lccn}         = $oldbiblio->{lccn};
                        $row_data{title}        = $oldbiblio->{title};
                        $row_data{author}       = $oldbiblio->{author};
                        $row_data{date}         = $oldbiblio->{copyrightdate};
                        $row_data{edition}      = $oldbiblio->{editionstatement};
                        $row_data{breedingid}   = $breedingid;
                        $row_data{biblionumber} = $biblionumber;
                        push( @breeding_loop, \%row_data );
		            
                    } else {
                        push(@breeding_loop,{'server'=>$servername[$k],'title'=>join(': ',$oConnection[$k]->error_x()),'breedingid'=>-1,'biblionumber'=>-1});
                    } # $rec
                }
            }    #$numresults
        }
    }    # if $k !=0
    $numberpending = $nremaining - 1;
    $template->param(
        breeding_loop => \@breeding_loop,
        server        => $servername[$k],
        numberpending => $numberpending,
        biblionumber  => $biblionumber,
        errconn       => \@errconn
    );
    
    output_html_with_http_headers $input, $cookie, $template->output if $numberpending == 0;

    #  	print  $template->output  if $firstresult !=1;
    $firstresult++;

  MAYBE_AGAIN:
    if ( --$nremaining > 0 ) {
        goto AGAIN;
    }
}    ## if op=search


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
