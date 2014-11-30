#!/usr/bin/perl

$dirname = "/root/cmarc/ISO1";

opendir(DIR, $dirname);

while(defined($dir = readdir(DIR))){
	next unless ( $dir =~ /\.ISO$/);
	print $dir . "\n";
}

closedir(DIR); 
