#!/bin/sh

HOTSPOT_SSID=Pi_Bot
HOTSPOT_PASSWORD=pibothotspot

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

apt-get update
apt-get install -y hostapd dnsmasq

systemctl disable hostapd
systemctl disable dnsmasq

cat > /etc/hostapd/hostapd.conf <<EOL
interface=wlan0
driver=nl80211
ssid=${HOTSPOT_SSID}
hw_mode=g
channel=6
wmm_enabled=0
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=${HOTSPOT_PASSWORD}
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOL

sed -i 's/#DAEMON_CONF="/DAEMON_CONF="\/etc\/hostapd\/hostapd.conf"/g' /etc/default/hostapd

cat >> /etc/dnsmasq.conf <<EOL
#AutoHotspot Config
#stop DNSmasq from using resolv.conf
no-resolv
#Interface to use
interface=wlan0
bind-interfaces
dhcp-range=10.0.0.2,10.0.0.20,12h
EOL

sed -i -e 's/auto lo$/auto lo wlan0/g' /etc/network/interfaces


cat >> /etc/systemd/system/autohotspot.service <<EOL
[Unit]
Description=Automatically generates an internet Hotspot when a valid ssid is not in range
After=multi-user.target
[Service]
Type=oneshot
RemainAfterExit=yes
ExecStart=/usr/bin/autohotspot
[Install]
WantedBy=multi-user.target
EOL

systemctl enable autohotspot.service

cat > /usr/bin/autohotspot <<EOL
#!/bin/bash
#version 0.90-N/HS

#You may share this script under the Creative Commons Licience of share alike. www.creativecommons.org
#a reference to RaspberryConnect.com must be included in copies or derivatives of this script.

#Wifi & Hotspot without Internet
#A script to switch between a wifi network and a Hotspot without Internet
#Works at startup or with a seperate timer or manually without a reboot
#Other setup required find out more at
#http://www.raspberryconnect.com

IFSdef=$IFS

#These four lines capture the wifi networks the RPi is setup to use
wpassid=$(awk '/ssid="/{ print $0 }' /etc/wpa_supplicant/wpa_supplicant.conf | awk -F'ssid=' '{ print $2 }' ORS=',' | sed 's/\"/''/g' | sed 's/,$//')
IFS=","
ssids=($wpassid)
IFS=$IFSdef #reset back to defaults


#Note:If you only want to check for certain SSIDs
#Remove the # in in front of ssids=('mySSID1'.... below and put a # infront of all four lines above
# separated by a space, eg ('mySSID1' 'mySSID2')
#ssids=('mySSID1' 'mySSID2' 'mySSID3')

#Enter the Routers Mac Addresses for hidden SSIDs, seperated by spaces ie
#( '11:22:33:44:55:66' 'aa:bb:cc:dd:ee:ff' )
mac=()

ssidsmac=("${ssids[@]}" "${mac[@]}") #combines ssid and MAC for checking


createAdHocNetwork()
{
    ip link set dev wlan0 down
    ip a add 10.0.0.5/24 brd + dev wlan0
    ip link set dev wlan0 up
    systemctl start dnsmasq
    systemctl start hostapd
}

KillHotspot()
{
    echo "Shutting Down Hotspot"
    ip link set dev wlan0 down
    systemctl stop hostapd
    systemctl stop dnsmasq
    ip addr flush dev wlan0
    ip link set dev wlan0 up
}

ChkWifiUp()
{
        sleep 10 #give time for ip to be assigned by router
	if ! wpa_cli status | grep 'ip_address' >/dev/null 2>&1
        then #Failed to connect to wifi (check your wifi settings, password etc)
	       echo 'Wifi failed to connect, falling back to Hotspot'
               wpa_cli terminate >/dev/null 2>&1
	       createAdHocNetwork
	fi
}

#Check to see what SSID's and MAC addresses are in range
ssidChk=('NoSSid')
for ssid in "${ssidsmac[@]}"
do
     if { iw dev wlan0 scan ap-force | grep "$ssid"; } >/dev/null 2>&1
     then
              ssidChk=$ssid
              break
       else
              ssidChk='NoSSid'
     fi
done


#Create Hotspot or connect to valid wifi networks
if [ "$ssidChk" != "NoSSid" ]
then
       echo 'Using SSID:' $ssidChk
       if systemctl status hostapd | grep "(running)" >/dev/null 2>&1
       then #hotspot running and ssid in range
              KillHotspot
              echo "Hotspot Deactivated, Bringing Wifi Up"
              wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf >/dev/null 2>&1
              ChkWifiUp
       elif { wpa_cli status | grep 'ip_address'; } >/dev/null 2>&1
       then #Already connected
              echo "Wifi already connected to network"
       else #ssid exists and no hotspot running connect to wifi network
              echo "Connecting to WiFi Network"
              wpa_supplicant -B -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf >/dev/null 2>&1
              ChkWifiUp
       fi
else #ssid or MAC address not in range
       if systemctl status hostapd | grep "(running)" >/dev/null 2>&1
       then
              echo "Hostspot already active"
       elif { wpa_cli status | grep 'wlan0'; } >/dev/null 2>&1
       then
              echo "Cleaning wifi files and Activating Hotspot"
              wpa_cli terminate >/dev/null 2>&1
              ip addr flush wlan0
              ip link set dev wlan0 down
              rm -r /var/run/wpa_supplicant >/dev/null 2>&1
              createAdHocNetwork
       else #"No SSID, activating Hotspot"
              createAdHocNetwork
       fi
fi
EOL

chmod +x /usr/bin/autohotspot