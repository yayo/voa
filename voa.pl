
# perl voa.pl /mnt/sdcard/external_sd/VOA

use strict;
use warnings;
use POSIX qw(mktime strftime);
use IO::Socket::Socks;

my $timezone=28800;
my %month=('Jan'=>0,'Feb'=>1,'Mar'=>2,'Apr'=>3,'May'=>4,'Jun'=>5,'Jul'=>6,'Aug'=>7,'Sep'=>8,'Oct'=>9,'Nov'=>10,'Dec'=>11);

my $section1="\xEF\xBB\xBF";
$section1.=<<SECTION1;
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />
<html xmlns="http://www.w3.org/1999/xhtml" />
<head>
<title>VOA Special English - 慢速英语</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="robots" content="all" />
<meta name="keywords" content="VOA,美国之音,VOA Special English,慢速英语" />
<meta name="description" content="VOA Special English,慢速英语" />
<link rel="stylesheet" type="text/css" href="/images/style.css" />
</head>
<body>
<div id="logo"><a href="/"><img src="/images/voa.gif" alt="VOA美国之音"></a></div>
<div id="nav"><a title="VOA" href="/"><b>美国之音</b></a> > <a href="/VOA_Special_English/" title="慢速英语">VOA Special English</a> <script type="text/javascript" src="/js/notice.js"></script></div>
<div id="leftMainContainer">
<div id="leftNav">
<div class="leftN_title"><a href="/VOA_Standard_English/">VOA Standard English</a></div>
<ul>
<li><a href="/VOA_Standard_1.html">VOA Standard English <img src=/images/new.gif border=0></a></li> 
<li><a href="/VOA_Standard_1_archiver.html">VOA Standard English Archives </a></li> 
</ul>
<div class="leftN_title"><a href="/VOA_Special_English/">VOA Special English</a></div>
<ul>
<li><a href="/Technology_Report_1.html">Technology Report</a></li>
<li><a href="/This_is_America_1.html">This is America</a></li>
<li><a href="/Agriculture_Report_1.html">Agriculture Report</a></li>
<li><a href="/Science_in_the_News_1.html">Science in the News</a></li>
<li><a href="/Health_Report_1.html">Health Report</a></li>
<li><a href="/Explorations_1.html">Explorations</a></li>
<li><a href="/Education_Report_1.html">Education Report</a></li>
<li><a href="/The_Making_of_a_Nation_1.html">The Making of a Nation</a></li>
<li><a href="/Economics_Report_1.html">Economics Report</a></li>
<li><a href="/American_Mosaic_1.html">American Mosaic</a></li>
<li><a href="/In_the_News_1.html">In the News</a></li>
<li><a href="/American_Stories_1.html">American Stories</a></li>
<li><a href="/Words_And_Their_Stories_1.html">Words And Their Stories</a></li>
<li><a href="/People_in_America_1.html">People in America</a></li>
<li><a href="/VOA_News_1.html">World News</a></li>

</ul>
<div class="leftN_title"><a href="/VOA_English_Learning/">VOA English Learning</a></div>
<ul>
<li><a href="/Bilingual_News_1.html">Bilingual News</a></li>
<li><a href="/Learn_A_Word_1.html">Learn A Word</a></li>
<li><a href="/How_American_English_1.html">How to Say it</a></li>
<li><a href="/Business_Etiquette_1.html">Business Etiquette</a></li>
<li><a href="/Words_And_Idioms_1.html">Words And Idioms</a></li>
<li><a href="/American_English_Mosaic_1.html">American English Mosaic</a></li>
<li><a href="/Popular_American_1.html">Popular American</a></li>
<li><a href="/Sports_English_1.html">Sports English</a></li>
<li><a href="/Go_English_1.html">Go English</a></li>
<li><a href="/Word_Master_1.html">Wordmaster</a></li>
<li><a href="/American_Cafe_1.html">American Cafe</a></li>
<li><a href="/Intermediate_American_English_1.html">Intermediate American Enlish</a></li>
</ul>
</div>

<div id="rightContainer">
<div id="right_List_VOA">
<script type="text/javascript"><!--
google_ad_client = "pub-3585518775245612";
/* 51VOA_List 728x90 */
google_ad_slot = "6619664191";
google_ad_width = 728;
google_ad_height = 90;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>
</div>
<div id="List_Title"><a href="/VOA_Special_English">VOA慢速英语听力最近更新</a></div>
<span id="blist"><ul>
SECTION1
$section1 =~ s/\n/\r\n/g;

my $section2=<<SECTION2;
 </ul></span>
</div><div class="clearing"></div></div>
<div class="clearing"></div>
<div id="footer"><a href="/"><img  src="/images/copyright.gif" alt="VOA美国之音"></a> <div id="count"><script language=javascript src="/js/count.js"></script> </div> </div>
</body></html>
SECTION2
$section2 =~ s/\n/\r\n/g;
$section2=substr($section2,0,length($section2)-2);

my %programs=(
'Technology_Report'=>'tech',
'This_is_America'=>'tia',
'Agriculture_Report'=>'ag',
'Science_in_the_News'=>'sin',
'Health_Report'=>'health',
'Explorations'=>'exp',
'Education_Report'=>'ed',
'The_Making_of_a_Nation'=>'nation',
'Economics_Report'=>'econ',
'American_Mosaic'=>'am',
'In_the_News'=>'itn',
'American_Stories'=>'as',
'Words_And_Their_Stories'=>'ws',
'People_in_America'=>'pia',
'VOA_News'=>'news', # se- -> special_
);

sub sock($)
 {
  #$_ = IO::Socket::Socks->new(ProxyAddr=>'127.0.0.1',ProxyPort=>'9050',ConnectAddr=>$_[0],ConnectPort=>80,SocksDebug=>0);
  $_ = IO::Socket::INET->new(PeerAddr=>$_[0],PeerPort=>80,Proto=>'tcp',Timeout=>1);
  return($_);
 }

sub http($$$$)
 {if(!defined($_[0])||!$_[0]->connected)
   {die('Connection Failed!');
   }
  else
   {print {$_[0]} $_[1].' '.$_[3].' HTTP/1.1'."\n".'Host: '.$_[2]."\n".'Connection: Keep-Alive'."\n\n";
    if(!defined(my $i=readline($_[0])))
     {die('Server Closed Connection!');
     }
    else
     {if($i !~ /^HTTP\/1[.][01] 200 OK\r\n$/)
       {die('Server Status Failed: '.$i);
       }
      else
       {my $Content_Length;
        my $Last_Modified;
        while(defined($_[0]) && ($i=readline($_[0])) && ("\r\n" ne $i) )
         {if($i =~ /^Content-Length: ([0-9]{1,})\r\n$/)
           {$Content_Length=$1;
           }
          elsif($i =~ /^Last-Modified: (?:Sun|Mon|Thu|Wed|Tue|Fri|Sat), ([0-9]{2}) (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec) ([0-9]{4}) ([0-9]{2}):([0-9]{2}):([0-9]{2}) GMT\r\n$/)
           {my $t1=POSIX::mktime($6,$5,$4,$1,$month{$2},$3-1900,0,0,-1)+$timezone;
            my $t2=POSIX::strftime('Last-Modified: %a, %d %b %Y %H:%M:%S GMT'."\r\n",gmtime($t1));
            if($t2 ne $i)
             {die($i.$t2);
             }
            else
             {$Last_Modified=$t1;
             }
           }
         }
        if("\r\n" ne $i)
         {die('Incomplete HTTP Header!');
         }
        else
         {if(!defined($Content_Length))
           {die('Not Found: Content-Length');
           }
          else
           {if(!defined($Last_Modified))
             {die('Not Found: Last-Modified');
             }
            else
             {if('HEAD' eq $_[1])
               {return($Content_Length,$Last_Modified);
               }
              else
               {read($_[0],$i,$Content_Length);
                if(length($i)!=$Content_Length)
                 {die(length($i).'!='.$Content_Length);
                 }
                else
                 {return($i,$Last_Modified);
                 }
               }
             }
           }
         }
       }
     }
   }
 }

my $prefix=(1==scalar(@ARGV)?$ARGV[0]:'/tmp/VOA');
$prefix =~ s/\/{2,}/\//g  ;
$prefix =~ s/\/*$//;
if(! -d $prefix)
 {die('NO such directory: '.$prefix);
 }
else
 {my $sock1=sock('www.51voa.com');
  my $body;
  if(defined($body=(http($sock1,'GET','www.51voa.com','/VOA_Special_English/index.html'))[0]))     
   {$|=1;
    if(substr($body,0,length($section1)) ne $section1)
     {die('SECTION1 NOT matched!');
     }
    else
     {$body=substr($body,length($section1));
      my $i=0;
      my $sock2=sock('down.51voa.com');
      while($body =~ /<li><a href="\/(Technology_Report|This_is_America|Agriculture_Report|Science_in_the_News|Health_Report|Explorations|Education_Report|The_Making_of_a_Nation|Economics_Report|American_Mosaic|In_the_News|American_Stories|Words_And_Their_Stories|People_in_America|VOA_News)_1[.]html" target="_blank">[[] ([^]]{1,}) []] <\/a> (?:<a href="\/lrc\/([0-9]{6})\/se-([a-z]{2,6})-([^.]{1,})[.]lrc" target=_blank><img src="\/images\/lrc[.]gif" width="27" height="15" border="0"><\/a>){0,1} (?:<a href="\/VOA_Special_English\/([0-9A-Za-z_-]{1,})_1[.]html" target="_blank"><img src="\/images\/yi[.]gif" width="27" height="15" border="0"><\/a> ){0,1}<a href="\/VOA_Special_English\/([0-9A-Za-z_-]{1,}?)([_-]{1,})([0-9]{5})[.]html" target="_blank">([0-9A-Za-z '+,-:;?’“”]{1,})  \([0-9]{4}-[0-9]{1}-([0-9]{1,2})\)<\/a><\/li>/g)
       {$i+=14+length($1)+27+length($2)+8+(defined($3)?24+length($4)+1+length($5)+85:0)+1+(defined($6)?30+length($6)+90:0)+30+length($7)+length($8)+28+length($10)+10+length($11)+10;
        #die(pos($body).' '.$i."\n") if(pos($body)!=$i); # DEBUG1
        @_=($1,$2,$3,$4,$5,$6,$7,$8,$9);
        ($_=$1) =~ s/_/ /g;
        if($_[1] ne $_)
         {die($_.' '.$_[1]);
         }
        else
         {if(defined($_[2]))
           {if($_[3] ne $programs{$_[0]})
             {die($_[0].' '.$_[3]);
             }
            else
             {if(defined($_[5]))
               {if($_[5] ne $_[6].$_[7].$_[8])
                 {die($_[5].' '.$_[6].$_[7].$_[8]);
                 }
                else
                 {$_='/'.$_[2].'/se-'.$_[3].'-'.$_[4];
                  %_=( 'mp3'=>[$sock2,'down.51voa.com',$_.'.mp3'], 'lrc'=>[$sock1,'www.51voa.com','/lrc'.$_.'.lrc'], 'htm'=>[$sock1,'www.51voa.com','/VOA_Special_English/'.$_[5].'_1.html'] );
                  $_[6] =~ s/-/_/g;
                  $_=$prefix.'/'.$_[8].'.'.$_[6];
                  while(my($k,$v)=each(%_))
                   {$k=$_.'.'.$k;
                    print($k);
                    @_=stat($k);
                    my ($size,$mtime)=@_[7,9];
                    if(defined($size)&&defined($mtime))
                     {print(' => ');
                      @_=http($$v[0],'HEAD',$$v[1],$$v[2]);
                      if($size != $_[0])
                       {die('size('.$k.')='.$size.' <> size(http://'.$$v[1].$$v[2].')='.$_[0]);
                       }
                      else
                       {if(1<abs($mtime-$_[1]))
                         {warn('mtime('.$k.')='.$mtime.' <> mtime(http://'.$$v[1].$$v[2].')='.$_[1].' => FIX: touch -d \''.POSIX::strftime('%Y-%m-%d %H:%M:%S',gmtime($_[1])).'\' '.$k."\n");
                          exit();
                          #utime($_[1],$_[1],$k);
                         }
                        else
                         {print('OK'."\n");
                         }
                       }
                     }
                    else
                     {print(' -> ');
                      @_=http($$v[0],'GET',$$v[1],$$v[2]);
                      if(!open($size,'>',$k))
                       {die('Can NOT open: '.$k);
                       }
                      else
                       {print {$size} $_[0];
                        close($size);
                        utime($_[1],$_[1],$k);
                        print('Downloaded'."\n");
                       }
                     }
                   }
                 }
               }
             }
           }
         }
       }
      $sock2->close();
      $body=substr($body,$i);
      if($body ne $section2)
       {die('SECTION2 NOT matched!'); # uncomment DEBUG1
       }
      else
       {print('Completed Successfully!'."\n");
       }
     }
    $sock1->close();
   }
 }
