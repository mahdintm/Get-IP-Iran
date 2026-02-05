# GlobalIP-Device-Lists by Mahdi
# Country: US
/ip firewall address-list remove [/ip firewall address-list find list=US]
/ip firewall address-list
:do { add address=8.8.8.0/24 list=US} on-error={}
/ipv6 firewall address-list remove [/ipv6 firewall address-list find list=US]
/ipv6 firewall address-list
:do { add address=2001:4860::/32 list=US} on-error={}
