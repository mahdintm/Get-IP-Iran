#Last update: Thu Feb  5 16:47:10 UTC 2026
/ip firewall address-list remove [/ip firewall address-list find list=Iran]
/ip firewall address-list
:do { add address=10.0.0.0/8 list=Iran} on-error={}
#Last update: Thu Feb  5 16:51:10 UTC 2026
/ipv6 firewall address-list remove [/ipv6 firewall address-list find list=Iran]
/ipv6 firewall address-list
