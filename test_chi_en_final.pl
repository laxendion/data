#!/usr/bin/perl

use List::MoreUtils qw / uniq / ;
#use String::Util 'trim';

$a = "為了提升惡意程式防護技術、降低競爭敵意，微軟擴大與其他防毒廠商、第三方測試單位的威脅資料共享 


防毒軟體廠商與微軟之間關係不再緊張，微軟惡意軟體防護中心的資深專案經理Holly Stewart表示，藉由擴大分享自身所收集到的威脅資料，他們鼓勵整個防惡意程式的生態系，應該要能展現出更大差異性。 

眾所週知，微軟在近十年內，已經透過併購其他廠商，以及自身的發展，將防護惡意程式的防護能力培養起來，並且推出相關的產品，或逐步內建在其軟體產品內。 

對於這樣的發展，當然許多防毒軟體廠商不樂見，因此，先前他們紛紛將微軟視為競爭對手。2013年起，微軟表示，這些防毒軟體廠商的敵意已經降低，原因就在於，微軟在2012年開始將他們所收集的樣本和遠端監測惡意程式活動資訊當中，較為通用、普及的部份，分享給幾家主要的防毒軟體廠商合作夥伴，以及負責測試惡意程式防護軟體偵測率的第三方單位。今年起，微軟更擴大分享資料的範圍，例如100家以上的合作廠商，以及AV-Test、AV Comparatives、ICSA、PCSL等驗證防毒軟體能力的組織。 

基於這些原因，微軟表示，他們在防護惡意程式上所扮演的角色，也有所轉變。 

免費防毒才是相關軟體廠商的競爭者 
過去幾年，微軟與防毒軟體廠商之間的關係變得相當緊繃，因為他們開始免費提供防毒軟體給用戶，甚至到了Windows 8，直接內建了防毒功能，多數人都很關切這樣發展下去，是否會重演過去瀏覽器平臺市占率大逆轉的狀況（Windows 95之後，微軟OS開始內建IE瀏覽器，結果導致其他瀏覽器平臺無法公平競爭，甚至退出市場）。 

2006年起，微軟開始為Windows XP和Server 2003作業系統，推出了可防間諜軟體的Windows Defender，到了Windows Vista之後更是直接內建。2007年時，微軟推出了需付費購買的Windows Live OneCare整合式防毒軟體，但過沒幾年，又改推Windows合法授權用戶可免費下載使用的Security Essentials，可支援Windows XP、Vista、7、Server 2003與Server 2008等作業系統版本。雖然最後看起來並沒有撼動既有防毒軟體的影響力，但始終是相關性質軟體廠商所不能忽視的競爭對手。 

這樣的緊張關係到了Windows 8上市後更明顯，因為當中內建的Windows Defender，不只是防間諜軟體，已悄悄地提供防毒功能。 

當微軟提供免費防毒軟體，以及Windows 8內建防毒功能後，使用者是否不再使用其他防毒軟體？實際上，這麼做對市占比例改變的衝擊效應已經發生，但重點並不只是微軟越來越主動提供防毒產品或功能，而是有許多使用者更願意接受免費防毒軟體。 

根據OPSWAT公司對全球與北美防毒市場的2012年底的分析報告，市占最高前五名的產品中，絕大多數都是免費防毒軟體。 

發展惡意程式防護技術遭重挫，微軟不得不改變策略 
微軟惡意軟體防護中心的資深專案經理Holly Stewart表示，微軟所扮演的角色正在轉變，她說微軟所提供的標準保護機制，將促使防毒軟體廠商提供的價值必須能夠超越微軟，才能在市場上生存下來。 

其他防毒軟體廠商是否認同這種說法，不得而知，但微軟的一些作法，也讓這些廠商降低了敵意，例如微軟對相關業者與測試人員，擴大分享了他們所收集的惡意程式樣本與監控惡意程式活動的資料，而不只是很有限地提供，同時，微軟也鼓勵防毒軟體廠商，應該更積極展現其防護技術超越微軟的價值所在，例如對於APT（Advanced Persistent Threat）的偵測與阻擋，基於這些更密切的合作，微軟本身也能獲益，學到更多改善自身技術的關鍵。 

在惡意程式防護的研發上，Holly Stewart也坦承2012年微軟遭遇到重大挫折──他們所發展的免費防毒軟體Security Essentials沒有通過AV-Test.org組織的測試。於是，除了既有的研究惡意程式族譜與分析用戶提交的惡意程式檔案，微軟惡意程式防護中心在2013年，決定放棄對測試惡意程式樣本的預測技術（Predicting Test Samples），全力發展以惡意程式普遍程度高低為權重的反應技術（Prevalence-Weighted Response）。 

就微軟目前的惡意程式防護產品來說，有Windows Defender、Security Essentials、Windows Intune、System Center Endpoint Protection和Malicious Software Removal Tool（MSRT），也有應用在伺服器、雲端服務環境的Exchange、Hotmail、和Azure。若單看全球Windows 8用戶環境，Holly Stewart認為，目前的防護程度已經頗高，例如不在微軟安全技術防護範圍的電腦只有15％；若從所有微軟平臺來看，處於未保護狀態下的比例是21％，已實施主動與被動防護的比例是5比1，而面對新興威脅來襲，微軟認為用戶端能普遍獲得早期預警保護的，有7成以上。";

@b = qw/
／
\？
#，
、
#。
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
#\.
\n
/;



foreach(@b) {

  $a =~ s/$_//g;

}

@word = ();
%keyword = ();
$max = 0;

# 1 gram

$t = "";

for($i = 0; $i < length($a); $i++) {
	
	$temp = substr($a, $i, 1); 

	# english 

	if(ord($temp) < 127) {

		if( ($temp =~ /\w+/ ) || ($temp =~ /\d+/) || ($temp =~ /\s+/) || ($temp =~/-/) || ($temp =~ /\./)) {

			$t = $t . $temp;


			# 32 -> space
			
			if(ord($temp) == 32) {

				$temp = $t;

				# loop so use if						

				if(ord($temp) != 32) {			
								
					$temp =~ s/\s+//g;					

					if($a =~ /$temp/g) {

						$keyword{$temp}++;
					
					    push @word, $temp;

					}

					$t = "";

				} else {

				}

			} 
	
		}		

	} else {

	 # first > 127

	 $newtemp = "";

	 if( (ord($t) != 0) ) {		  
	   
	   $t =~ s/\s+//g; 

	   $newtemp = $t;

	   # loop use if

		 if($a =~ /$newtemp/g) {
			
			$keyword{$newtemp}++;

			push @word, $newtemp;
				 
	     }


	  $t = "";

	  }	

	  # cjk

	  $newtemp = substr($a, $i ,3);

	  # loop use if

	  
	  if( ($newtemp ne "。") && ($newtemp ne "，") ) {	

		$newtemp =~ s/\s+//g;
		 	
	     if($a =~ /$newtemp/g) {

	       $keyword{$newtemp}++;	

		   push @word, $newtemp;

	     }

	  }	

	     $i = $i + 2;
		 	
	     
	}

}

@newword = ();
%hnewword = ();

for($i = 0 ; $i <= $#word; $i++) {

  if( (ord($word[$i]) < 127) && (ord($word[$i+1]) < 127)) {

    $tempword = $word[$i] . " " . $word[$i+1];

	push @newword, $tempword;

	if($a =~ /$tempword/g) {

	  $hnewword{$tempword}++;

	}

  } else {  	
 
	$tempword = $word[$i] . $word[$i+1];

	push @newword, $tempword; 

    if($a =~ /$tempword/g ) {

	  $hnewword{$tempword}++;

    }
  }		

}


$freq = 1;
@t1array = ();
%h1array = ();

# megre into 2 gram

for($i = 0; $i <= $#newword; $i++) {

	if( ($hnewword{$newword[$i]} > $freq ) && ( $hnewword{$newword[$i+1]} > $freq ) ) {

		# final

		$temp = substr($newword[$i+1], (length($newword[$i+1])-1), 1);

		if(ord($temp) < 127) {

			$temp = "";
			$tmp = "";
			$L = 1;
			@en =();

			while(!$temp) {

				$engchr = substr($newword[$i+1], (length($newword[$i+1])-$L), 1);

				$tmp = $tmp . $engchr;			
				
				if(ord($engchr) > 127 ) {  

				  $temp = $newword[$i] . " " . reverse($tmp);

				  push @t1array, $temp;

				  if($a =~ /$temp/g) {
			
					$h1array{$temp}++;	

				  }

				} elsif(ord($engchr) == 32) {

				  $temp = $newword[$i] . reverse($tmp);

				  push @t1array, $temp;

				  if($a =~ /$temp/g) {
					
					$h1array{$temp}++;

				  }

				}


				$L++;				

			}


		} elsif(ord($temp) > 127 ) {

			$temp = substr($newword[$i+1], (length($newword[$i+1])-3), 3);

			$newkey = $newword[$i] . $temp;

			push @t1array, $newkey;

			if($a =~ /$newkey/g) {

				$h1array{$newkey}++;

			}


		}


	} else {

		push @t1array, "x";

	}

}

# final 

push @t1array, 'x';

$twomax =0;

foreach(keys %h1array) {

	if($h1array{$_} > $twomax) {

		$twomax = $h1array{$_};

	}

}

# max twomerge

@twomerge = ();

foreach(keys %h1array) {

	if($h1array{$_} == $twomax) {

		push @twomerge , $_;

	}

}

# max twomerge end

@f = ();

while(scalar @t1array){

$t1 = shift(@t1array);
$t2 = shift(@t1array);

	if($t1 eq '') {

	  @t1array = ();

	} elsif($t1 ne 'x') {

		if($t2 ne 'x'){

			if( ($h1array{$t1} > $freq) && ($h1array{$t2} > $freq)) {

				# final 

				$temp = substr($t2, (length($t2)-1), 1);

				if(ord($temp) < 127){
	
					$temp ="";
					$tmp = "";
					$L = 1;
					@en =();

					while(!$temp){

						$engchr = substr($t2, (length($t2)-$L),1);
						
						$tmp = $tmp . $engchr;
						
						if(ord($engchr) > 127 ) {

							$temp = $t1 . " " . reverse($tmp);

							unshift @t1array, $temp;

							while($a =~ /$temp/g) {

							  $h1array{$temp}++;

							}

						} elsif(ord($engchr) == 32){

							$temp = $t1 . reverse($tmp);

							unshift @t1array, $temp;

							while($a =~ /$temp/g) {

							  $h1array{$temp}++;

							}

						}

						$L++;

					}

				} elsif(ord($temp) > 127) {

					$temp = substr($t2, (length($t2)-3), 3);

					$newkey = $t1 . $temp;

					unshift @t1array, $temp;

					while($a =~ /$newkey/g) {

						$h1array{$newkey}++;

					}

				}

				#

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

foreach(uniq(@f)) {

	if(length($_) > 3){
	
		print $_ . ",";

	}	

}

# two max
	
%twom = ();

foreach(uniq(@twomerge)) {

	$twom{$_} = 0;

}

# match

foreach (uniq(@f)) {

	foreach $maxkey (uniq(@twomerge)) {

		if($_ = /$maxkey/g) {

			$twom{$maxkey}++;

		}

	}

}


print "\n======\n";

foreach(keys %twom) {

	if($twom{$_} == 0) {
		
		print "$_, ";

	}

}
	
print "\n";	
