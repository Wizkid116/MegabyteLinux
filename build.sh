#!/bin/bash
set -euo pipefail
#removes any files leftover from previous builds
sudo rm -rf filesystem/ bzImage i686-linux-musl-cross linux-6.9.9 megabyte.img rootfs.cpio.xz toybox-0.8.11

#download and extract source code
wget -N https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.9.9.tar.xz
wget -N https://landley.net/toybox/downloads/toybox-0.8.11.tar.gz
wget -N https://landley.net/toybox/downloads/binaries/toolchains/latest/i686-linux-musl-cross.tar.xz
tar xvf linux-*.tar.xz
tar xvf toybox-*.tar.gz
tar xvf i686-linux-musl-cross.tar.xz
#rm linux-*.tar.xz
#rm toybox-*.tar.gz
#rm i686-*.tar.xz

#build Linux
cd linux-*/
cp ../linuxconfig .config
make ARCH=x86 bzImage -j$(nproc)
cp arch/x86/boot/bzImage ../bzImage

#link name of cc to toybox for cross-compilation
cd ../i686-linux-musl-cross
ln -s $(realpath ccc) ../toybox-*/

#build Toybox and copy binaries to filesystem folder
cd ../toybox-*/
cp ../toyboxconfig .config
make LDFLAGS=--static CROSS_COMPILE=../i686-linux-musl-cross/bin/i686-linux-musl- -j$(nproc)
make LDFLAGS=--static CROSS_COMPILE=../i686-linux-musl-cross/bin/i686-linux-musl- install
mv install ../filesystem

#Make the rest of the root directories
cd ../filesystem
mkdir -pv {dev,proc,etc/init.d,sys,tmp}
sudo mknod dev/console c 5 1
sudo mknod dev/null c 1 3

#cringy welcome message
cat >> welcome << EOF
Welcome to Megabyte Linux!
There's not much to do in 1MB of space, so enjoy the view...
EOF

#make the inittab
cat >> etc/inittab << EOF
::sysinit:/etc/init.d/rc
::askfirst:/bin/sh
::restart:/sbin/init
::ctrlaltdel:/sbin/reboot
::shutdown:/bin/umount -a -r
EOF

#make the rc init file and make everything executable
cat >> etc/init.d/rc << EOF
#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys
clear
cat welcome
/bin/sh
EOF
chmod +x etc/init.d/rc
sudo chown -R root:root .

#compress the rootfs
find . | cpio -H newc -o | xz --check=crc32 > ../rootfs.cpio.xz

cd ..
#make syslinux config file
cat >> syslinux.cfg << EOF
DEFAULT linux
LABEL linux
SAY [ BOOTING MEGABYTE LINUX VERSION 0.2 ]
KERNEL bzImage
APPEND initrd=rootfs.cpio.xz
EOF

#build the final image file
dd if=/dev/zero of=megabyte.img bs=1k count=1000
mkdosfs megabyte.img
syslinux --install megabyte.img
sudo mount -o loop megabyte.img /mnt
sudo cp bzImage /mnt
sudo cp rootfs.cpio.xz /mnt
sudo cp syslinux.cfg /mnt
sudo umount /mnt
rm syslinux.cfg
echo "Done!"
echo "To test the final image, use the following command:"
echo "'qemu-system-i386 -hda megabyte.img'"
