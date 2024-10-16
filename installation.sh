#! /bin/sh

PACKAGE_MANAGER="apt"
PACKAGE_MANAGER_INSTALL="apt install"

sudo $PACKAGE_MANAGER update
sudo $PACKAGE_MANAGER upgrade
sudo $PACKAGE_MANAGER_INSTALL gcc-avr avr-libc avrdude

