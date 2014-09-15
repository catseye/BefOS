# Makefile for building the BefOS boot disk image.

CC?=gcc
ASM?=yasm
OBJDIR?=../obj
BINDIR?=../bin
QEMU?=qemu-system-i386

all: befos.flp

befos.flp: $(OBJDIR)/beboot.com \
	   $(OBJDIR)/bekernel.com \
	   $(OBJDIR)/belife.com \
	   $(OBJDIR)/welcome.bin \
	   $(OBJDIR)/tutorial.bin \
	   $(OBJDIR)/legend.bin \
	   $(OBJDIR)/keybind.bin \
	   $(BINDIR)/amalgam8
	$(BINDIR)/amalgam8 befos.flp \
		$(OBJDIR)/beboot.com     0 \
		$(OBJDIR)/bekernel.com   1 \
		$(OBJDIR)/welcome.bin    8 \
		$(OBJDIR)/license.bin    9 \
		$(OBJDIR)/legend.bin    10 \
		$(OBJDIR)/keybind.bin   11 \
		$(OBJDIR)/belife.com    12 \
		$(OBJDIR)/tutorial.bin  13

clean:
	echo 'Use `make cleandist` to delete disk image.'

cleandist:
	rm -f *.flp

test: befos.flp
	$(QEMU) -fda befos.flp
