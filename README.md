# MegabyteLinux
MegabyteLinux is a custom linux image and set of scripts based on Floppinux that build a 32-bit Linux liveimage that fits in 1MB of disk space

## Features:

* Linux kernel 6.9 (nice)
* Toybox
* Musl (cause Glibc is massive)
* Syslinux
* 1MB in size
* 8MB ram usage
* TTY (wow)
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

## Running
to run the final image:
```
qemu-system-i386 -hda tinux.img
```
Also included is a precompiled image if you want to check that out:
```
qemu-system-i386 -hda tinux-works.img
```
