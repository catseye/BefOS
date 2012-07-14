; BefOS Kernel BEKERNEL.COM
; v2004.0404
; (c)1999-2004 Cat's-Eye Technologies.  All rights reserved.

;--- NOTES ---------------------------------------------------;

; This image can be a maximum of 30464 bytes in size.

;--- BEGIN ---------------------------------------------------;

%include	"../inc/befos.inc"

BITS		16
ORG		BEFOS_OFF

;--- CONSTANTS -----------------------------------------------;

;--- Key Bindings ---------------------------------------------;

%include	"../inc/befkeys.inc"

;--- DATA ----------------------------------------------------;

SEGMENT	.data

flags:		db	00h
FLAG_EDIT	EQU	01h	; 1 if we are in Edit Mode
FLAG_STRMODE	EQU	08h	; 1 if we are in String Mode

;--- BSS -----------------------------------------------------;

SEGMENT	.bss

temp:		RESW 1
temp2:		RESW 1
templen:	RESW 1
attr:		RESB 1

;--- CODE ----------------------------------------------------;

SEGMENT	.text

Start:		mov	ax, cs		; get our code segment
		mov	ds, ax		; set data segment to our cs
		mov	ss, ax		; set stack segment to our cs
		mov	sp, 0fffeh	; set stack ptr -> top of segment

;--- Initialize Video ----------------------------------------;

		call	DiscoverVidBase
		call	TextVid

;--- Initialize Memory ---------------------------------------;

		call	DiscoverRAM

;--- Splash the Screen ---------------------------------------;

		mov	cl, 2fh
		call	ClrScreen
		call	RefreshStatus
		call	LoadPage
		call	MoveCursor

;--- Install ISRs --------------------------------------------;

		;call	PlugBreak
		;call	PlugPrtSc

;=============================================================;
;=== MAIN LOOP ===============================================;
;=============================================================;

MainLoop:	call	GetKey

		mov	ax, [keyhit]
		cmp	al, 0
		jne	.ASCIIKey
		cmp	ah, 3
		je	.ASCIIKey		; Ctrl-2!
		xor	bx, bx
		mov	bl, ah
		shl	bx, 1
		mov	si, bx
		mov	ax, [keytab + si]
		call	ax
		jmp	MainLoop

.ASCIIKey:	test	[flags], byte FLAG_EDIT
		jz	.NoWrite
		mov	cx, [keyhit]
		call	WriteByte
		call	Advance
		jmp	MainLoop

.NoWrite:	call	BadLight
		jmp	MainLoop

;--- Included Modules ----------------------------------------;

%include "memory.s"
%include "interrupt.s"
%include "video.s"
%include "keyboard.s"
%include "disk.s"
; %include "comm.s"

%include "screen.s"
%include "digit.s"
%include "display.s"
%include "statusbar.s"
%include "dataedit.s"

%include "page.s"
%include "pageprop.s"
%include "pageedit.s"
%include "buffedit.s"
%include "copypaste.s"

%include "syscall.s"
%include "interp.s"

;--- END -----------------------------------------------------;
