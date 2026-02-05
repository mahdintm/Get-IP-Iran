# GlobalIP-Device-Lists by Mahdi
# Country: IR
/ip firewall address-list remove [/ip firewall address-list find list=IR]
/ip firewall address-list
:do { add address=5.52.0.0/16 list=IR} on-error={}
:do { add address=37.32.0.0/12 list=IR} on-error={}
/ipv6 firewall address-list remove [/ipv6 firewall address-list find list=IR]
/ipv6 firewall address-list
:do { add address=2a00:9e00::/29 list=IR} on-error={}
