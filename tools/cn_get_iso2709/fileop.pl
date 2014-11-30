#!/usr/bin/perl

open(FILE, './USMARC_book');

while(<FILE>){

	$_ =~ /020  \@a(\d*)/; 

	$tmp = $1;

	$tmp=~ /(\d*)/;

	print $1 . "\n";

}

close(FILE);
