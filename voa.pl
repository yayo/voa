
use strict;
use warnings;
use IO::Socket::Socks;

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
      {print($body);
      }
    }
  }
 $sock->close();
}
