koha-3.18
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
    cp opac/htdocs/bootstrap/zh-Hans-CN/modules
    opac-detail.tt
    opac-results.tt
    到 
    opac/htdocs/bootstrap/zh-Hans-CN/modules

    zh-Hans-TW
    cp opac/htdocs/bootstrap/zh-Hans-TW/modules
    opac-detail.tt
    opac-results.tt
    到 
    opac/htdocs/bootstrap/zh-Hans-TW/modules

    cgi 
    cp opac/cgi-bin/opac
    opac-detail.pl
    opac-search.pl
    到
    opac/cgi-bin/opac/
3.  豆瓣 staff
    zh-Hans-CN
    cp intranet/htdocs/intranet-tmpl/prog/zh-Hans-CN/modules/catalogue
    detail.tt
    results.tt
    到
    intranet/htdocs/intranet-tmpl/prog/zh-Hans-CN/modules/catalogue

    zh-Hans-TW
    cp intranet/htdocs/intranet-tmpl/prog/zh-Hans-TW/modules/catalogue
    detail.tt    
    results.tt
    到
    intranet/htdocs/intranet-tmpl/prog/zh-Hans-TW/
    
    cgi
    cp intranet/cgi-bin/catalogue 
    detail.pl
    search.pl
    intranet/cgi-bin/catalogue  
       
4.  處理 z39.50 轉 gb18030
    安裝 debug Data::Dumper & 轉碼 Encode::HanExtra
    cpan Encode::HanExtra Data::Dumper 

    z39.50 server (202.197.127.197 , tcp 210, db cnmarc, sytax UNIMARC, encoding utf8, timeout 60)
    
    cp C4/Breeding.pm 
    到
    koha/lib/C4

5.  處理 zebra 查詢 isbn hyphens 問題
    cp C4/Koha.pm
    到
    koha/lib/C4