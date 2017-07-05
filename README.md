![Pi Bot](https://raw.githubusercontent.com/bah2830/pi_bot/master/resources/web_content/img/pi_bot_x36.png)

[![Build Status](https://travis-ci.org/bah2830/pi_bot.svg?branch=master)](https://travis-ci.org/bah2830/pi_bot)

# pi_bot
Remote controlled and autonomous bot written in golang using the EMBD framework


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
