koha-3.16.4 
1.  設定 cgi-bin/koha/admin/preferences.pl?tab=enhanced_content
    AmazonCoverImages , OPACAmazonCoverImages 開啟 
    新增 Getdouban-0.01 抓豆瓣封面
    cpan LWP::Simple JSON
    cd Getdouban-0.01 
    perl Makefile.PL
    make
    make install
2.  豆瓣 opac bootstrap themes   
    zh-Hans-CN
    cp opac-bootstrap-zh-Hans-CN-modules\opac-detail.tt
    cp opac-bootstrap-zh-Hans-CN-modules\opac-results.tt
    到 
    opac/htdocs/opac-tmpl/bootstrap/zh-Hans-CN/modules

    zh-Hans-TW
    cp opac-bootstrap-zh-Hans-TW-modules\opac-detail.tt
    cp opac-bootstrap-zh-Hans-TW-modules\opac-results.tt
    到
    opac/htdocs/opac-tmpl/bootstrap/zh-Hans-TW/modules

    cgi 
    cp cgi-bin/opac-detail.pl
    cp cgi-bin/opac-search.pl
    到
    opac/cgi-bin/opac
3.  豆瓣 staff
    zh-Hans-CN
    cp zh-Hans-CN-modules/catalogue/detail.tt
    cp zh-Hans-CN-modules/catalogue/results.tt
    到
    intranet/htdocs/intranet-tmpl/prog/zh-Hans-CN/modules/catalogue/

    zh-Hans-TW
    cp zh-Hans-TW-modules/detail.tt    
    cp zh-Hans-TW-modules/results.tt
    到
    intranet/htdocs/intranet-tmpl/prog/zh-Hans-TW/modules/catalogue/ 
    
    cgi
    cp staff/prog/cgi-bin/catalogue/detail.pl to staff/prog/cgi-bin/catalogue/
    cp staff/prog/cgi-bin/catalogue/detail.pl to staff/prog/cgi-bin/catalogue/
        
4.  豆瓣 staff cgi 處理 z39.50 轉 gb18030
    安裝 debug Data::Dumper & 轉碼 Encode::HanExtra
    cpan Encode::HanExtra Data::Dumper 

    cp C4/Breeding.pm 
    到
    koha/lib/C4

5.  處理 zebra 查詢 isbn hyphens 問題
    cp C4/Koha.pm
    到
    koha/lib/C4