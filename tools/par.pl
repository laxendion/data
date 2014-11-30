#!/usr/bin/perl 


$dirname = "/root/cmarc/ISO1";

opendir(DIR, $dirname);

while(defined($dir = readdir(DIR))) {
	
	next unless ($dir =~ /\.ISO$/);
	print $dir . ", ";
	open(F , "$dirname/$dir");
	open(MARC , ">>./data.mrc");

	while(<F>){

		$_ =~ /<ISOBIG5>(.+)<\/ISOBIG5>/;

		print $1;

		print MARC "$1";
#	`cat $1 > /root/cmarc/data.mrc`;
	}

	close(MARC);
	close(F);

}

closedir(DIR);
