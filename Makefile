SHELL=/bin/bash

.default := all

download:
	wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.9.tar.xz
	wget https://landley.net/toybox/downloads/toybox-0.8.9.tar.gz
	wget https://landley.net/toybox/downloads/binaries/toolchains/latest/i686-linux-musl-cross.tar.xz
	tar xvf linux-*.tar.xz
	tar xvf toybox-*.tar.gz
	tar xvf i686-linux-musl-cross.tar.xz

linux:
	cd linux-*
	cp ../linuxconfig .config
	make ARCH=x86 bzImage -j$(shell nproc)
	cp arch/x86/boot/bzImage ../bzImage

musl-prepare:
	cd ../i686-linux-musl-cross
	ln -s $(shell realpath ccc) ../toybox-*

toybox: 
	cd ../toybox-*
	cp ../toyboxconfig .config
	make LDFLAGS=--static CROSS_COMPILE=../i686-linux-musl-cross/bin/i686-linux-musl- -j5
	make LDFLAGS=--static CROSS_COMPILE=../i686-linux-musl-cross/bin/i686-linux-musl- install
	mv install ../filesystem

filesystem:
	cd ../filesystem
	mkdir -pv {dev,proc,etc/init.d,sys,tmp}
	sudo mknod dev/console c 5 1
	sudo mknod dev/null c 1 3
	cp ../welcome filesystem/
	cp ../inittab filesystem/etc/inittab
	cp ../rc filesystem/etc/init.d/rc
	chmod +x etc/init.d/rc
	sudo chown -R root:root .
	find . | cpio -H newc -o | xz --check=crc32 > ../rootfs.cpio.xz
	cd ..

image:
	dd if=/dev/zero of=megabyte.img bs=1k count=1000
	mkdosfs megabyte.img
	syslinux --install megabyte.img
	sudo mount -o loop megabyte.img /mnt
	sudo cp bzImage /mnt
	sudo cp rootfs.cpio.xz /mnt
	sudo cp syslinux.cfg /mnt
	sudo umount /mnt

build: linux musl-prepare toybox filesystem image

all: download build

clean:
	rm -rf linux-6.9 toybox-0.8.9 i686-linux-musl-cross bzImage \
	rootfs.cpio.xz syslinux.cfg megabyte.img
	sudo rm -rf filesystem
