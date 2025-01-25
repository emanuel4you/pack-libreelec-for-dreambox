#!/bin/bash

# SPDX-License-Identifier: GPL-2.0
# Copyright (C) 2025 Emanuel Strobel
# bypassing dreambox direct SDCARD boot options to LibreElec *box.img

LEBUILD=${HOME}/LibreELEC.tv

LETARGETS=${LEBUILD}/target/

TARGET=`ls ${LETARGETS} | grep box | sed '/.sha256/d' | awk '{ f=$NF }; END{ print f }'`

if [ -f ${TARGET} ]; then
    echo "up to date!"
else
    cp ${LETARGETS}${TARGET} .
fi

exit
