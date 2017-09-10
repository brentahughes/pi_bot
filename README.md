![Pi Bot](https://raw.githubusercontent.com/bah2830/pi_bot/master/resources/web_content/img/pi_bot_x36.png)

[![Build Status](https://travis-ci.org/bah2830/pi_bot.svg?branch=master)](https://travis-ci.org/bah2830/pi_bot)

# pi_bot
Remote controlled and autonomous bot written in golang using the EMBD framework

![Screenshot_1](https://raw.githubusercontent.com/bah2830/pi_bot/master/images/screenshot_overview.png)

## Connecting

Thanks to the awesome work by roboberry in [auto-wifi](http://www.raspberryconnect.com/network/item/331-raspberry-pi-auto-wifi-hotspot-switch-no-internet-routing) PiBot is able to offer automatic ad hoc wifi connections if no known wifi is available.

### How it works
During bootup if no wifi networks are known it will automatically create an adhoc network with an SSID of Pi_Bot and passphrase pibothotspot. Once connected PiBot will be available on 10.0.0.5

If you want you can ssh to the pi on 10.0.0.5 and edit /etc/wpa_supplicant/wpa_supplicant.conf with a known wifi in the area and reboot.


## Debugging on remote raspberry pi

### Setup Raspberry PI
In order to make the makefile work correctly a ssh public key must be added to the pi for authentication.

### Deploy
Build arm binary, copy to remote host, and execute it.
```
make remote_debug
```

### Kill
Stop the bot on the remote host
```
make remote_kill
```


## Building and Wiring

### Wiring
![wiring](https://raw.githubusercontent.com/bah2830/pi_bot/master/images/wire_diagram.png)


### Shopping List
Part | Amount
---- | ------
IR Proximity Sensor | 4
DC Motor with Tire | 4
Raspberry Pi Zero | 1
L298N Motor Controller | 1
Micro USB | 1
