#Last update: Wed Sep 17 07:48:50 UTC 2025
/ip firewall address-list remove [/ip firewall address-list find list=Iran]
/ip firewall address-list
:do { add address=10.0.0.0/8 list=Iran} on-error={}
#Last update: Wed Sep 17 07:48:55 UTC 2025
/ipv6 firewall address-list remove [/ipv6 firewall address-list find list=Iran]
/ipv6 firewall address-list
