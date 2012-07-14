#!/bin/sh
# $Id$

# This is chintzy.  But at least it's not a recursive Makefile, right?

TARGET=$1

cd src/tools && make ${TARGET} && cd ../..
cd src/kernel && make ${TARGET} && cd ../..
cd src/inc && make ${TARGET} && cd ../..
cd src/apps && make ${TARGET} && cd ../..
cd src/page && make ${TARGET} && cd ../..
cd src/boot && make ${TARGET} && cd ../..
cd disk && make ${TARGET} && cd ..
