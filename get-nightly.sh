#!/bin/bash

# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2025 Emanuel Strobel
# bypassing dreambox direct SDCARD boot options to LibreElec *box.img

URL=https://test.libreelec.tv/13.0/Amlogic/box/

CURRENT_NIGHTLY=`wget -O - ${URL} | grep LibreELEC-AMLGX.aarch64-13.0-nightly-2025 | sed -e 's/.*"><a href="//g' -e 's/">.*//' | awk '{ f=$NF }; END{ print f }'`

NIGHTLY=${URL}${CURRENT_NIGHTLY}

if [ -f ${CURRENT_NIGHTLY} ]; then
    echo "up to date!"
else
    wget ${NIGHTLY}
fi
