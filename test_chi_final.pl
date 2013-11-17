#!/usr/bin/perl

use List::MoreUtils qw / uniq / ;

$a = "記者邱明玉／台北報導

行政院長江宜樺今（8）日第六度赴立法院進行施政報告，由於仍未獲朝野共識，最後還是無法如願上台，立法院長王金平表示，他提議行政院長江宜樺可以延緩兩週施政報告，行政部門原則同意，但還是要經過國民黨團召開黨團大會再討論，王金平並在上午近11時宣布散會。

經過一個上午的朝野協商，王金平最後宣布，因為各黨團對於行政院長施政報告質詢議程仍未獲共識，朝野黨團協商結論就是繼續休息協商，請江院長和各部會首長先行離席，本次會議不進行臨時提案，即行散會。

對於監聽國會風暴，朝野黨團也做成兩點決議：

一. 基於國會自主原則，立法院不宜同意法務部函請協助節費電話實機監錄測試等請求。

二.立法院司法及法制委員會已成立「監聽調閱專案小組」，進行調閱，法務部及相關機關應配合該小組運作，列席報告相關事項及提出書面報告，以利立法院依法行使調閱職權，釐清監聽國會事件真相。";

@b = qw/
／
\？
，
、
。
！
：
「
」
『
』
；
—
\（
\）
…
\.
\n
\s+
/;

foreach(@b) {
  $a =~ s/$_//g;
  $a =~ s/(\d)+/$1  /g;
}

#print $a . "\n";

@word = ();
%keyword = ();
$max = 0;

# 2 gram

for($i = 0; $i < length($a); $i = $i+3) {

	$temp = substr($a, $i ,6);

	push @word, $temp;

	if($a =~ /$temp/g){
		
		$keyword{$temp}++;

	}

 
	if($keyword{$temp} > $max) {

		$max = $keyword{$temp};

	}
 
}


@unarray =();

	foreach( keys %keyword ) {

		if($keyword{$_} == $max) {

			push @unarray, $_;

		}

	}


$freq = 1;
@t1array = ();
%h1array = ();

$maxtwo = 0;

# megre into 2 gram

for($i = 0; $i <= $#word; $i++) {


	if( ($keyword{$word[$i]} > $freq ) && ( $keyword{$word[$i+1]} > $freq ) ) {

		$temp = substr($word[$i+1], (length($word[$i+1])-3 ), 3);
		$newkey = $word[$i] . $temp;

		push @t1array, $newkey;

		if($a =~ /$newkey/g) {
		
			$h1array{$newkey}++;

		}

		if( $h1array{$newkey} > $maxtwo) {

		  $maxtwo = $h1array{$newkey};

		}


	} else {

		push @t1array, "x";

	}

}


push @t1array, 'x';


@max2 = ();

for($i = 0; $i <= $#t1array ; $i++){


	if($t1array[$i] ne "x") {

		if ($h1array{$t1array[$i]} == $maxtwo) {
			
			push @max2 , $t1array[$i];

		}

	}
}


@f = ();

while(scalar @t1array){

$t1 = shift(@t1array);
$t2 = shift(@t1array);

	if($t1 eq '') {

	  @t1array = ();

	} elsif($t1 ne 'x') {

		if($t2 ne 'x'){

			if( ($h1array{$t1} > $freq) && ($h1array{$t2} > $freq)) {

				$temp = substr($t2, (length($t2)-3), 3);
				$new = $t1 . $temp;

				# no loop so use while match all string 
		
				while($a =~ /$new/g) {
	
					$h1array{$new}++;
									
				}

				unshift @t1array, $new;

			}

		} elsif($t2 eq 'x') {

			push @f, $t1;

		}

	} elsif($t1 eq 'x' ) {

		if($t2 ne 'x') {

		 unshift @t1array, $t2;

		}

	}

}


# long string  

foreach (uniq(@f)) {

	print $_ . " ";

}


print "\n";

# three

%hthree = ();

foreach(uniq(@max2)) {
	
	$hthree{$_} = 0;	
}

@three = ();

foreach (uniq(@f)) {

	foreach $maxkey( uniq(@max2)) {

		if($_ =~ /$maxkey/g) {

			$hthree{$maxkey}++;

		} 

	}

}

# two


%h1two = ();

foreach(uniq(@unarray)){

  $h1two{$_} = 0;

}

foreach (uniq(@f)) {

	foreach $maxkey (uniq(@unarray)) {

		if($_ =~ /$maxkey/ ) {

			$h1two{$maxkey}++;

		}
	}

}


#three


foreach ( keys %hthree) {

	if($hthree{$_} == 0 ) {

		print "$_($maxtwo) ";

	}

}

	
