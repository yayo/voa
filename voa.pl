
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

#$part1=substr($part1,0,length($part1)-1);


#my $sock=IO::Socket::Socks->new(ProxyAddr=>'127.0.0.1',ProxyPort=>'9050',ConnectAddr=>'www.51voa.com',ConnectPort=>80,SocksDebug=>0);
my $sock = IO::Socket::INET->new(PeerAddr=>'www.51voa.com',PeerPort=>80,Proto=>'tcp',Timeout=>1);

if(!defined($sock)||!$sock->connected)
 {warn('Connection Failed!');
  exit();
 }
else
{print $sock 'GET /VOA_Special_English/index.html HTTP/1.1'."\n".'Host: www.51voa.com'."\n".'Connection: Close'."\n\n";
 $_=readline($sock);
 if('HTTP/1.1 200 OK'."\r\n" ne $_)
  {warn('Server Status Failed: '.$_);
   exit();
  }
 else
  {my $Content_Length;
   while(defined($sock) && ($_=readline($sock)) && ("\r\n" ne $_) )
    {if($_ =~ /^Content-Length: ([0-9]{1,})\r\n$/)
      {$Content_Length=$1;
      }
    }
   if(!defined($Content_Length))
    {warn('Not Found: Content-Length');
     exit();
    }
   else
    {my $body;
     read($sock,$body,$Content_Length);
     if(length($body)!=$Content_Length)
      {warn(length($body).'!='.$Content_Length);
       exit();
      }
     else
      {
       #print($body);
       #print(length($part1).' '.length($part3));
       if(substr($body,0,length($part1)) ne $part1)
        {warn("PART1");
         exit();
         
        }
       else
        {
         #print('OK');
         $body=substr($body,length($part1));
         print($body);
        }
      }
    }
  }
 $sock->close();
}
