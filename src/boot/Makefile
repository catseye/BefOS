# Makefile for BefOS boot block.

ASM?=yasm
OBJDIR?=../../obj

all: $(OBJDIR)/beboot.com

$(OBJDIR)/beboot.com: beboot.s ../inc/befos.inc
	$(ASM) -f bin -o $@ -l beboot.lst beboot.s

clean:
	rm -f $(OBJDIR)/*.com *.lst

cleandist:
	echo 'OK'

test:
	echo 'OK'
