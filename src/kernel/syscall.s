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



BindFunc:	nop

; es:si -> null-terminated string, naming the desired function
; returns bx = BefOS function pointer

; 1 treeptr x = root;

		; mov	bx, offset root

; 2 if x == NULL abort

.Loop:		cmp	bx, 0
		jne	.SallyForth
		mov	bx, Unimp
		ret

.SallyForth:	

; 3 mov di, x->key

		mov	di, [bx + 6]

; 4 strcmp es:si, ds:di

		mov	al, [es:si]
		mov	dl, [ds:di]
		cmp	al, dl
		ja	.Right
		; ...

; 5 if si < di, x = x->left, goto 2

		mov	bx, [bx]
		jmp	.Loop

; 6 if si > di, x = x->right, goto 2

.Right:		mov	bx, [bx + 2]
		jmp	.Loop

; return x->functionptr

		mov	bx, [bx + 2]
		ret

;--- END -----------------------------------------------------;
