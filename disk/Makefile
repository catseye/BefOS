# Makefile for building the BefOS boot disk image.
# $Id: Makefile 62 2006-02-05 04:39:58Z catseye $

CC=gcc
ASM=nasm
OBJDIR=../obj
BINDIR=../bin

all: befos.flp

befos.flp: $(OBJDIR)/beboot.com \
	   $(OBJDIR)/bekernel.com \
	   $(OBJDIR)/belife.com \
	   $(OBJDIR)/welcome.bin \
	   $(OBJDIR)/legend.bin \
	   $(BINDIR)/amalgam8
	$(BINDIR)/amalgam8 befos.flp \
		$(OBJDIR)/beboot.com     0 \
		$(OBJDIR)/bekernel.com   1 \
		$(OBJDIR)/welcome.bin    8 \
		$(OBJDIR)/legend.bin     9 \
		$(OBJDIR)/belife.com    10 \

clean:
	rm -f *.flp

test: befos.flp
	bochs -q 'boot:a' 'floppya: 1_44=befos.flp, status=inserted'
