;--- BEGIN ---------------------------------------------------;

;--- CONSTANTS -----------------------------------------------;

;--- DATA ----------------------------------------------------;

SEGMENT	.data

;--- BSS -----------------------------------------------------;

SEGMENT	.bss

;--- CODE ----------------------------------------------------;

SEGMENT	.text

Unimp:		jmp	BadLight

		; SysCall - this is called far only by BefOS applications.
		; ax = destroyed
		; bx = function number
SisCall:	mov	ax, cs
		mov	ds, ax
		call	bx
		retf


RunAsm:		call	NotInEditMode
		mov	ax, [.RunSeg + 3]
		mov	es, ax
		mov	di, 0100h

.RLoop:		mov	ax, [cbuffer - 0100h + di]
		mov	[es:di], ax
		inc	di
		inc	di
		cmp	di, 2048 + 0100h
		jne	.RLoop

.RunSeg:	call	0800h:0100h
		mov	ax, cs
		mov	ds, ax			; reset ds
		call	TextVidBase
		ret

;--- END -----------------------------------------------------;
