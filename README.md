# MegabyteLinux
MegabyteLinux is a custom linux image and set of scripts based on Floppinux that build a 32-bit Linux liveimage that fits in 1MB of disk space

## Features

* Linux kernel 6.9.9 (nice)
* Toybox
* Musl (cause Glibc is massive)
* Syslinux
* 8MB ram usage
* TTY (wow)
  
  Final size = 982Kb
## Requirements
To build Megabyte Linux, you need to have the following packages installed(mostly identical to the linux kernel):
* bc
* build-essential
* bison
* fakeroot
* flex
* ncurses-dev
* gcc
* git
* glibc
* libelf-dev
* libssl-dev
* mtools
* qemu #optional, for testing the image
* syslinux
* wget
* xz

## Build

To build the image, issue the following commands:
```
git clone https://github.com/Wizkid116/MegabyteLinux.git
cd MegabyteLinux
sudo chmod +x build.sh
./build.sh
```
then be patient :)

even on my Thinkpad T480, everything takes only about 3 minutes to compile. 

## Run
to run the final image:
```
qemu-system-i386 -hda megabyte.img
```
Also included is a precompiled image if you want to check that out:
```
qemu-system-i386 -hda megabyte-works.img
```

### Donate
If you like my silly little project, then chuck me some Monero:
```
46FgbLQXEFPbsZzzpF1ecQ7BrQc4YXjiF6pNv8sWjfg2Ri9LkPoEWspFxPwu7US19hXMP4mWrEwwzSPQzZaGZ9eM4iRPf82
```
