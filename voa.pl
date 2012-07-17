
# perl voa.pl /mnt/sdcard/external_sd/VOA

use strict;
use warnings;
use IO::Socket::Socks;

my $part1="\xEF\xBB\xBF";
$part1.=<<PART1;
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
PART1
$part1 =~ s/\n/\r\n/g;

my $part2=<<PART2;
 </ul></span>
</div><div class="clearing"></div></div>
<div class="clearing"></div>
<div id="footer"><a href="/"><img  src="/images/copyright.gif" alt="VOA美国之音"></a> <div id="count"><script language=javascript src="/js/count.js"></script> </div> </div>
</body></html>
PART2
$part2 =~ s/\n/\r\n/g;
$part2=substr($part2,0,length($part2)-2);

my %programs=(
'Technology_Report'=>'tech',
'This_is_America'=>'',
'Agriculture_Report'=>'ag',
'Science_in_the_News'=>'',
'Health_Report'=>'health',
'Explorations'=>'',
'Education_Report'=>'ed',
'The_Making_of_a_Nation'=>'',
'Economics_Report'=>'econ',
'American_Mosaic'=>'',
'In_the_News'=>'itn',
'American_Stories'=>'',
'Words_And_Their_Stories'=>'ws',
'People_in_America'=>'',
'VOA_News'=>'',
);

sub sock($)
 {
  #my $sock1 = IO::Socket::Socks->new(ProxyAddr=>'127.0.0.1',ProxyPort=>'9050',ConnectAddr=>$_[0],ConnectPort=>80,SocksDebug=>0);
  my $sock1 = IO::Socket::INET->new(PeerAddr=>$_[0],PeerPort=>80,Proto=>'tcp',Timeout=>1);
  return($sock1);
 }

sub http($$$$)
 {
  if(!defined($_[0])||!$_[0]->connected)
   {die('Connection Failed!');
   }
  else
   {
    print {$_[0]} $_[1].' '.$_[3].' HTTP/1.1'."\n".'Host: '.$_[2]."\n".'Connection: Keep-Alive'."\n\n";
    if(!defined($_=readline($_[0])))
     {die('Server Closed Connection!');
     }
    else
     {
      if($_ !~ /^HTTP\/1[.][01] 200 OK\r\n$/)
       {die('Server Status Failed: '.$_);
       }
      else
       {my $Content_Length;
        while(defined($_[0]) && ($_=readline($_[0])) && ("\r\n" ne $_) )
         {if($_ =~ /^Content-Length: ([0-9]{1,})\r\n$/)
           {$Content_Length=$1;
           }
         }
        if(!defined($Content_Length))
         {die('Not Found: Content-Length');
         }
        else
         {if('HEAD' eq $_[1])
           {
            return($Content_Length);
           }
          else
           {my $body;
            read($_[0],$body,$Content_Length);
            if(length($body)!=$Content_Length)
             {die(length($body).'!='.$Content_Length);
             }
            else
             {
              return($body);
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
  if(defined($body=http($sock1,'GET','www.51voa.com','/VOA_Special_English/index.html')))     
   {$|=1;
    if(substr($body,0,length($part1)) ne $part1)
     {die("PART1");
     }
    else
     {$body=substr($body,length($part1));
      my $i=0;
      my $sock2=sock('down.51voa.com');
      while($body =~ /<li>(.*?)<\/li>/g)
       {
        $i+=4+length($1)+5;
        if($1 !~ /^<a href="\/(.*?)_1[.]html" target="_blank">[[] ([^]]*) []] <\/a> (.*?)<a href="(\/VOA_Special_English\/([0-9A-Za-z_-]{1,}?)[-_]{1,}([0-9]{5}))[.]html" target="_blank">.*?[\s]{1,}\([0-9]{4}-[0-9]{1}-[0-9]{1,2}\)<\/a>$/)
         {die($1);
         }
        else
         {if(!exists($programs{$1}))
           {die($1);
           }
          else
           {my ($v1,$v3,$v4,$v5,$v6)=($1,$3,$4,$5,$6);
            ($_ = $2) =~ s/ /_/g;
            if($v1 ne $_)
             {die($_);
             }
            else
             {my $v2='';
              if($v3=~/lrc[.]gif/)
               {if($v3!~/<a href="\/lrc(\/[0-9]{6}\/se-([^-]{2,6})-[0-9A-Za-z-]{1,})[.]lrc" target=_blank><img src="\/images\/lrc[.]gif" width="27" height="15" border="0"><\/a>/)
                 {die($v3);
                 }
                else
                 {if($2 ne $programs{$v1})
                   {die($v1.' '.$2);
                   }
                  else
                   {$v2=$1;
                   }
                 }
               }
              if($v3!~/yi[.]gif/)
               {$v3='';
               }
              else
               {if($v3!~/<a href="(\/VOA_Special_English\/[0-9A-Za-z_-]{1,}_1[.]html)" target="_blank"><img src="\/images\/yi[.]gif" width="27" height="15" border="0"><\/a>/)
                 {die($v3);
                 }
                else
                 {if($v4.'_1.html' ne $1)
                   {die($v4.' '.$1);
                   }
                  else
                   {
                    $v3=$1;
                   }
                 }
               }
              if('' ne $v2 && '' ne $v3)
               {$v5=$prefix.'/'.$v6.'.'.$v5;
                #print('curl -v -A \'\' -o'.$v5.'.mp3 http://down.51voa.com'.$v2.'.mp3'."\n".'curl -v -A \'\' -o'.$v5.'.lrc http://www.51voa.com/lrc'.$v2.'.lrc'."\n".'curl -v -A \'\' -o'.$v5.'.htm http://www.51voa.com'.$v3."\n");
                my %filetype=( '.mp3'=>[$sock2,'down.51voa.com',$v2.'.mp3'], '.lrc'=>[$sock1,'www.51voa.com','/lrc'.$v2.'.lrc'], '.htm'=>[$sock1,'www.51voa.com',$v3] );
                while(my($k,$v)=each(%filetype))
                 {$v6=$v5.$k;
                  print($v6.' => ');
                  my $size=(-s $v6);
                  if(defined($size))
                   {my $Content_Length=http($$v[0],'HEAD',$$v[1],$$v[2]);
                    if($size != $Content_Length)
                     {die('size('.$v6.')='.$size.' <> size(http://'.$$v[1].$$v[2].')='.$Content_Length);
                     }
                    else
                     {print('Updated'."\n");
                     }
                   }
                  else
                   {$v4=http($$v[0],'GET',$$v[1],$$v[2]);
                    if(!open(FILE,'>',$v6))
                     {die('Can NOT open: '.$v6);
                     }
                    else
                     {
                      print FILE $v4;
                      close(FILE);
                      print('Downloaded'."\n");
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
      if($body ne $part2)
       {die("PART2");
       }
      else
       {print('Completed Successfully!'."\n");
       }
     }
    $sock1->close();
   }
 }
