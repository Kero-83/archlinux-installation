# Arch Linux Installation Guide

## 1- Wifi Connection

- Using `iwctl`

``` bash
iwctl
device list
station wlan0 get-networks
station wlan0 connect wifiName
ping www.google.com
```

## 2- Check if your computer have UEFI or BIOS

- If you have BIOS, Output will look like this

```bash
root@archiso# ls /sys/firmware/efi/efivars
file or directory does not exist
```

## Audio Stuff

```bash
sudo pacman -S bluez bluez-utils blueman pipewire pipewire-pulse pipewire-alsa pipewire-jack pavucontrol
```
