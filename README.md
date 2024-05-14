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

## Build

To build Megabyte Linux, issue the following commands:
```
git clone https://github.com/Wizkid116/MegabyteLinux.git
cd MegabyteLinux
sudo chmod +x build.sh
./build.sh
```
then be patient :)

even on my Thinkpad T480, everything takes only about 3 minutes to compile. 
