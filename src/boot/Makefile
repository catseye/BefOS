# Makefile for BefOS boot block.
# $Id: Makefile 62 2006-02-05 04:39:58Z catseye $

ASM=nasm
OBJDIR=../../obj

all: $(OBJDIR)/beboot.com

$(OBJDIR)/beboot.com: beboot.s ../inc/befos.inc
	$(ASM) -f bin -o $@ -l beboot.lst beboot.s

clean:
	rm -f $(OBJDIR)/*.com *.lst
