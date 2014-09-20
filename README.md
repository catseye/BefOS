BefOS
=====

This is the reference distribution for BefOS, a toy Befunge-themed OS
written in 8086 assembler in the NASM format.

The contents of this distribution have been placed into the public
domain; see the file `UNLICENSE` for more information.

Note that this README is based on what was originally written for the
BefOS project way back in the 20th century.  Therefore parts of it may
be crufty, outdated, and generally unfashionable.  Probably best to
take it all with a grain of salt.

BefOS - an Operating System for the Linearly Challenged
-------------------------------------------------------

Version 0.9 revision 2012.0827

This work by Chris Pressey of Cat's Eye Technologies
has been placed into the public domain (see UNLICENSE.)

  ,---------------------------------------------------.
  | * WARNING! * CAUTION * PROCEED AT YOUR OWN RISK * |
  |                                                   |
  | *        THIS PRODUCT IS PROVIDED "AS IS"       * |
  |                                                   |
  | * CAT'S EYE TECHNOLOGIES CAN NOT BE HELD LIABLE * |
  | *    FOR ANY DAMAGES RESULTING FROM ITS USE     * |
  `---------------------------------------------------'

What is it?
-----------

BefOS is a toy OS written in 100% 8086 assembler.  It requires the
following hardware (or a decently emulated version thereof):

	Processor:	100% Intel 8086+ Compatible
	BIOS:		100% IBM PC Compatible
	Video:		100% VGA Compatible
	Keyboard:	100% Standard 101/102-Key Compatible
	RAM:		640K base, 8M extended
	Storage:	1.44M floppy drive 0 (A:)

BefOS was originally written in Borland's Turbo Assembler format,
but this version has been translated to use the free assembler
NASM.

Booting into BefOS
------------------

Using Bochs or some other emulator: point the emulated A: drive of
the emulator at the file disk/befos.flp, and boot from the floppy.
The 'test' target in the top-level (and disk/) Makefile will run
Bochs automatically on this floppy image.

Using Windows: run BEKERNEL.COM.  (Note that I'm not sure if this
works anymore in the NASM version; I haven't tried it.  You still
need a blank floppy in drive A:, though.)

For real: install the floppy image (disk/befos.flp) onto a blank,
1.44M floppy disk, using a tool such as 'fdimage.exe' (which is
available at ftp://ftp.freebsd.org/pub/FreeBSD/tools/).  Then
reset your computer and boot off that floppy.

Using BefOS
-----------

Once you've booted into BefOS, you'll see a blue screen with some stuff
on it.

Here is a quick-and-dirty guide to the top line of this display:

	B		the BefOS 'logo.'
	(light)		yellow = working, green = worked, red = failed
	(4 hex digits)	amount of base memory available, in K
	(4 hex digits)	amount of extended memory available, in K
	(green bar)
	(4 hex digits)	link to next cluster of current cluster
	(4 hex digits)	link to previous cluster of current cluster
	(4 hex digits)	link to application cluster of current cluster
	(4 hex digits)	link to colour cluster of current cluster
	(4 hex digits)	link to help cluster of current cluster
	(green bar)
	(16 OEM chars)	description of current cluster
	(green bar)
	(4 hex digits)	value of last keystroke detected
	(2 hex digits)	value of current byte under cursor
	(4 hex digits)	current cluster number, starts at 0

And here are some key bindings: (NYI=Not Yet Implemented):

	PgUp		Up One Cluster 
	PgDn		Down One cluster

	Ctrl-PgUp	Link to Previous Cluster (header)
	Ctrl-PgDn	Link to Next Cluster (header)
	F1		Link to Help Cluster (header)

	Up		Move Pointer Up One Row
	Down		Move Pointer Down One Row
	Left		Move Pointer Left One Column
	Right		Move Pointer Right One Column

	^2 (^@)		Write	 0
	^A to ^Z	Write	 1 - 26
	ESC		Write	27
	^\		Write	28	
	^]		Write	29	
	^6 (^^)		Write	30
	^- (^_)		Write	31	
	Space		Write	32
	!..~		Write	33 - 126
	Ctrl-Bkspc	Write  127

	Alt-L		Load (refresh from disk)
	Alt-R		Run (if AA==ffff, executes machine code)

	F4		Change Properties (Header)
	Alt--		Delete Properties (Header)
	Alt-=		Initialize Properties (Header)

	Alt-M		show More data on screen
	Alt-N		show less data on screeN

	Alt-G		Go to cluster number

NYI*1	Alt-E		Edit: allow writes
	Alt-U		fill cluster Uniformly with current byte
	Alt-C		Copy cluster data & header to clipboard
	Alt-P		Paste cluster data & header from clipboard
	Alt-H		toggle High bit
	Alt-S		Save (commit changes to data & header to disk)

	Alt-Q		Quit (MS-DOS only)
*2	Alt-I		Install cluster from file (MS-DOS only)

*1: writes are always allowed in this version so BE CAREFUL WITH ALT-S.
*2: type the filename into the start of the cluster buffer and
    terminate it with a null (Ctrl-2)

Cluster Format
--------------

Each cluster has a 'header' which is in fact stored in the LAST
48 bytes of the second cluster.  The first 2000 bytes are data.
The header is structured thus:

+------------------------------------------------+
|VVNNPPAACCHHxxxxxxxxxxxxxxxxxxxxDDDDDDDDDDDDDDDD|
+------------------------------------------------+

VV = word indicating header type.

     bef0 indicates standard BefOS header, the only type supported.

NN = word containing the cluster number of the next cluster.

     0000 indicates that there is no next cluster.

PP = word containing the cluster number of the previous cluster.

     0000 indicates that there is no previous cluster.

AA = word containing the cluster number of the first cluster of
     the application for which this is a document.

     0000 indicates that there is no special application for this
     generic document.

     ffff indicates that this IS an application written in
     x86 machine code.

CC = word containing the cluster number of
     this cluster's colour cluster.

     0000 indicates that this cluster is monochrome.

HH = 2 bytes containing the cluster number of
     this cluster's help-cluster.

     0000 indicates that this cluster is helpless.

xxxxxxxxxxxxxxxxxxxx = 20 bytes reserved.

DDDDDDDDDDDDDDDD = 16 bytes ASCII description e.g. "Seismology Now"



------------------------------------------------------------------

But the following is more like what I would like it to be...

------------------------------------------------------------------

First, we say that 1 "screen" is 4096 bytes:
  80x25char + 80x25colour + 96 bytes header.
A "tableau" is a set of 80x25 screens = 2000 * 4K = 8M.
  There is one tableau on the computer which maps to it's extended RAM.

One 1.44M floppy disk can contain six columns = 150 screens.

Header:

+------------------------------------------------+
|VVAAxxxxxxxxxxxxDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD|
|DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD|
+------------------------------------------------+

VV = word indicating header type.

     bef0 indicates standard BefOS header, the only type supported.

AA = word containing the cluster number of the first cluster of
     the application for which this is a document.

     0000 indicates that there is no special application for this
     generic document.

     ffff indicates that this IS an application written in
     x86 machine code.

xxxxxxxxxxxx = 12 bytes reserved.

DD..DD = 80 bytes ASCII description.


Building BefOS
--------------

BefOS can be built on FreeBSD (and probably Linux and Cygwin.)
Just type 'make clean all' from the top level to build it all.

Here is what is in the various directories:

    bin/
        amalgam8      Constructs a boot disk image from BefOS objects
	extract8      Extracts BefOS objects from a boot disk image
	txt2page      Turns a text file into a BefOS object file
	mkbfinc.pl    Used during build to generate list of API calls
    disk/             Contains bootable BefOS boot disk images
    obj/              Contains BefOS objects that will be amalgamated
    src/              Contains source code for BefOS:
        apps/         Source code for the BefOS applications installed
	boot/         Source code for the boot disk's boot block
	inc/          Include files shared by many BefOS object sources
	kernel/       Source file for the core components of BefOS
	page/         Misc files that become BefOS pages on the disk
	tools/        Source code for the util programs put in bin/
	turbo/        The original Turbo Assembler sources for BefOS


Putative TODO list
------------------

*   Clean up the code base
*   Rebrand the thing because I don't like the name BefOS
*   Update the README
*   Document the entry points
*   Abstract "main loop" out of bekernel.s, into editor.s
*   Translate all tools to Python?  Or at least Perl.
*   Switch to unreal mode on boot
*   Allow editing memory pages
    *   "current page" also needs "current device"
    *   can be just the base RAM for now
*   Implement an actual VM for it (likely something rather befungeoid, but
    not Befunge)
    *   Execute from "current exection page"
    *   If "current execution page" is "current displayed page",
        also update cursor while executing
*   Rewrite Editor in the befungeoid VM?
*   Fix syscalls
    *   Really, you should only be able to syscall a Beeble (=Befunge-05)
        instruction
