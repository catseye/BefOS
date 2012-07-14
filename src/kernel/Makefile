# Makefile for building the BefOS kernel.
# $Id: Makefile 62 2006-02-05 04:39:58Z catseye $

ASM=nasm
OBJDIR=../../obj

all: $(OBJDIR)/bekernel.com

$(OBJDIR)/bekernel.com: bekernel.s \
			memory.s interrupt.s keyboard.s video.s disk.s \
			screen.s digit.s display.s statusbar.s dataedit.s \
			page.s pageedit.s pageprop.s buffedit.s copypaste.s \
			syscall.s interp.s \
			../inc/befos.inc ../inc/befkeys.inc ../inc/beeble.inc
	$(ASM) -f bin -o $@ -l bekernel.lst bekernel.s

clean:
	rm -f $(OBJDIR)/*.com *.lst
