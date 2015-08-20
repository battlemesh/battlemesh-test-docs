config interface 'loopback'
        option ifname 'lo'
        option proto 'static'
        option ipaddr '127.0.0.1'
        option netmask '255.0.0.0'

config globals 'globals'
        option ula_prefix 'fd94:ae62:0c9b::/48'

config interface 'lan'
        option ifname 'eth0.1'
        option force_link '1'
        option proto 'static'
        option ipaddr '172.17.32.1'
        option netmask '255.255.255.0'
        option ip6assign '64'

config interface 'wan'                  
        option ifname 'eth0.2'          
        option proto 'static'           
        option ipaddr '172.17.33.1'      
        option netmask '255.255.255.255'
        #option ip6assign '64' 

config interface 'wlan0'
        option ifname 'wlan0'
        option proto 'static'
        option ipaddr '172.17.34.1'
        option netmask '255.255.255.255'
        #option ip6assign '64'

config interface 'wlan1'              
        option ifname 'wlan1'         
        option proto 'static'         
        option ipaddr '172.17.35.1'   
        option netmask '255.255.255.255'
        #option ip6assign '64'

# --- device specific config here (eg: switch) --- #


config switch
	option name 'switch0'
	option reset '1'
	option enable_vlan '1'

config switch_vlan
	option device 'switch0'
	option vlan '1'
	option ports '0t 2 3 4 5'

config switch_vlan
	option device 'switch0'
	option vlan '2'
	option ports '0t 1'

