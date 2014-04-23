# Makefile for building the BefOS kernel.

ASM?=yasm
OBJDIR?=../../obj

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

cleandist:
	echo 'OK'

test:
	echo 'OK'
