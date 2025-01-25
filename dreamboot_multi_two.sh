#!/bin/bash

# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2025 Emanuel Strobel
# bypassing dreambox direct SDCARD boot options to LibreElec *box.img

sudo echo || exit

mkdir LE_BOOT

pigz -dk LibreELEC-AMLGX.a*-box.img.gz

START=`sudo fdisk -l LibreELEC-AMLGX.a*-box.img | grep .img1 | awk -e '{ print $3 }'`
OFFSET=$(expr 512 '*' $START)
LOOPDEV=$(losetup -f)

sudo losetup -o $OFFSET $LOOPDEV LibreELEC-AMLGX.a*-box.img
sudo mount -rw $LOOPDEV LE_BOOT

sudo cp -r ./extboot/autoexec.img LE_BOOT
sudo cp -r ./extboot/u-boot_s922x.bin LE_BOOT/u-boot.ext

BOOT_ARGS=`cat LE_BOOT/uEnv.ini | grep bootargs | sed -e 's/ quiet//'`

BOOT_ARGS="$BOOT_ARGS no_console_suspend debugging"

sudo sed -i 's!@@DTB_NAME@@!meson-g12b-dreambox-two.dtb!' LE_BOOT/uEnv.ini
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

NAME=`ls LibreELEC-AMLGX.a*-box.img | sed -e 's/box.img//'`dreamtwo_multibootloader.img
mv `ls LibreELEC-AMLGX.a*-box.img` $NAME

pigz -9 $NAME
sha256sum $NAME.gz > $NAME.gz.sha256

mkdir target &>/dev/null
mv $NAME.gz target
mv $NAME.gz.sha256 target

exit

