# Top-level Makefile for all of BefOS
# $Id: Makefile 62 2006-02-05 04:39:58Z catseye $

# This is so wrong.  We need to amalgamate this
# into a single Makefile someday.

# the 'cd ..' is required to get out of obj/
SRCDIR=../src
DISKDIR=../disk

all:
	cd $(SRCDIR)/tools && make all
	cd $(SRCDIR)/kernel && make all
	cd $(SRCDIR)/inc && make all
	cd $(SRCDIR)/apps && make all
	cd $(SRCDIR)/page && make all
	cd $(SRCDIR)/boot && make all
	cd $(DISKDIR) && make all

clean:
	cd $(SRCDIR)/tools && make clean
	cd $(SRCDIR)/kernel && make clean
	cd $(SRCDIR)/inc && make clean
	cd $(SRCDIR)/apps && make clean
	cd $(SRCDIR)/page && make clean
	cd $(SRCDIR)/boot && make clean
	cd $(DISKDIR) && make clean

test: all
	cd $(DISKDIR) && make test
