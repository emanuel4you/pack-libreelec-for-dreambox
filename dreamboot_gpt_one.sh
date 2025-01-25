#!/bin/bash

# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2025 Emanuel Strobel
# bypassing dreambox direct SDCARD boot options to LibreElec *box.img

sudo echo || exit

mkdir LE_BOOT
mkdir LE_ROOT
pigz -dk LibreELEC-AMLGX.a*-box.img.gz

START=`sudo fdisk -l LibreELEC-AMLGX.a*-box.img | grep .img1 | awk -e '{ print $3 }'`
OFFSET=$(expr 512 '*' $START)
LOOPDEV=$(losetup -f)

sudo losetup -o $OFFSET $LOOPDEV LibreELEC-AMLGX.a*-box.img
sudo mount -rw $LOOPDEV LE_BOOT
sudo dosfslabel $LOOPDEV DREAMBOOT

sudo cp -r ./extboot/autoexec_gpt.img LE_BOOT/autoexec.img
sudo cp -r ./extboot/u-boot_s922x.bin LE_BOOT/u-boot.ext

BOOT_ARGS=`cat LE_BOOT/uEnv.ini | grep bootargs | sed -e 's/ quiet//'`

BOOT_ARGS="$BOOT_ARGS no_console_suspend debugging"

sudo sed -i 's!@@DTB_NAME@@!meson-g12b-dreambox-one.dtb!' LE_BOOT/uEnv.ini
sudo sed -i "s!bootargs.*!$BOOT_ARGS!" LE_BOOT/uEnv.ini

echo "uEnv.ini:"
cat  LE_BOOT/uEnv.ini
echo
echo "boot:"
ls LE_BOOT/
echo

sync
sudo umount LE_BOOT
sudo losetup -d $LOOPDEV
rmdir LE_BOOT

START=`sudo fdisk -l LibreELEC-AMLGX.a*-box.img | grep .img2 | awk -e '{ print $2 }'`
OFFSET=$(expr 512 '*' $START)
LOOPDEV=$(losetup -f)

sudo losetup -o $OFFSET $LOOPDEV LibreELEC-AMLGX.a*-box.img
sudo mount -rw $LOOPDEV LE_ROOT

sudo cp -r ./storage/bin LE_ROOT
sudo cp -r ./storage/.config LE_ROOT
sudo cp -r ./storage/.profile LE_ROOT

echo "storage:"
ls -a LE_ROOT/
echo

sync
sudo umount LE_ROOT
sudo losetup -d $LOOPDEV
rmdir LE_ROOT

NAME=`ls LibreELEC-AMLGX.a*-box.img | sed -e 's/box.img//'`dreamone_gpt-multiboot.img
mv `ls LibreELEC-AMLGX.a*-box.img` $NAME

dd if=./extboot/u-boot.bin.encrypt of="${NAME}" conv=fsync,notrunc bs=1 count=440
dd if=./extboot/u-boot.bin.encrypt of="${NAME}" conv=fsync,notrunc bs=512 skip=1 seek=1
pigz -9 $NAME
sha256sum $NAME.gz > $NAME.gz.sha256

mkdir target &>/dev/null
mv $NAME.gz target
mv $NAME.gz.sha256 target

exit
