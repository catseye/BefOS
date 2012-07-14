;--- BEGIN ---------------------------------------------------;

;--- CONSTANTS -----------------------------------------------;

;--- DATA ----------------------------------------------------;

SEGMENT	.data

bufptr:		dw 0000h	; current byte in the current page
lastmove:	dw BufRight	; last direction cursor moved

;--- BSS -----------------------------------------------------;

SEGMENT	.bss

;--- CODE ----------------------------------------------------;

SEGMENT	.text

		;;--------------------------------------------;
		;; Retrieve the value of the currently selected
		;; byte in the page buffer.
		;; cl: * -> byte from buffer
		;; di: * -> GARBAGE
ReadByte:	mov	di, [bufptr]
		mov	cl, [cbuffer + di]
		ret


		;;--------------------------------------------;
		;; Poke a byte into the current position in
		;; the page buffer and display it on screen.
		;; cl: byte to poke ->
		;; si: * -> position on screen
		;; ch: * -> attribute on screen
		;; bx: * -> GARBAGE
WriteByte:	mov	si, [bufptr]
		mov	[cbuffer + si], cl
		mov	bx, si
		shl	bx, 1
		add	bx, [hoffs]
		mov	si, bx
		mov	ch, 71h		; TODO - get from colour buffer
		mov	[es:si], cx
		ret


BufHome:	mov	[bufptr], word 0
		jmp	MoveCursor


Advance:	mov	ax, [lastmove]
		jmp	ax



BufRight:	mov	[lastmove], word BufRight
		;	FALLTHROUGH
BufHopRight:	inc	word [bufptr]
		mov	ax, 2000
		mov	bx, [hoffs]
		shr	bx, 1
		sub	ax, bx
		cmp	[bufptr], ax
		jne	.Return
		mov	[bufptr], word 0
.Return:	jmp	MoveCursor


BufLeft:	mov	[lastmove], word BufLeft
		;	FALLTHROUGH
BufHopLeft:	dec	word [bufptr]
		cmp	word [bufptr], 0ffffh
		jne	.Return
		mov	ax, 2000
		mov	bx, [hoffs]
		shr	bx, 1
		sub	ax, bx
		dec	ax
		mov	[bufptr], ax
.Return:	jmp	MoveCursor


BufUp:		mov	[lastmove], word BufUp
		;	FALLTHROUGH
BufHopUp:	sub	word [bufptr], 80
		cmp	word [bufptr], 0
		jge	.Return
		mov	ax, 2000
		mov	bx, [hoffs]
		shr	bx, 1
		sub	ax, bx
		add	[bufptr], ax
.Return:	jmp	MoveCursor


BufDown:	mov	[lastmove], word BufDown
		;	FALLTHROUGH
BufHopDown:	add	[bufptr], word 80
		mov	ax, 2000
		mov	bx, [hoffs]
		shr	bx, 1
		sub	ax, bx
		cmp	[bufptr], ax
		jl	.Return
		sub	[bufptr], ax
.Return:	jmp	MoveCursor


		; just like BufDown except invokes a scroll if on bottom line.
LineFeed:	add	[bufptr], word 80
		mov	ax, 2000
		mov	bx, [hoffs]
		shr	bx, 1
		sub	ax, bx
		cmp	[bufptr], ax
		jl	.Return
		sub	[bufptr], word 80	; back to where we once belonged

		; get top line of screen = hoffs/160
		mov	ax, bx
		mov	bx, 80
		xor	dx, dx		; Zero high!
		div	bx

		xor	cx, cx
		mov	ch, al

		; scroll area on screen

		mov	ax, 0601h
		mov	bh, 27h		; todo: better attribute... need var
		mov	dx, 184fh	; (79,24)
		int	10h		; scroll it

.Return:	jmp	MoveCursor


LeftMarg:	mov	ax, [bufptr]
		mov	bx, 80
		xor	dx, dx		; Zero high!
		div	bx

		xor	ah, ah
		shl	ax, 4
		mov	bx, ax
		shl	bx, 2
		add	ax, bx

		mov	[bufptr], ax

		jmp	MoveCursor


		; MoveCursor - moves cursor to reflect bufptr.
		;   ax=DESTROYED
		;   bx=DESTROYED
		;   dx=DESTROYED
MoveCursor:	xor	dx, dx
		mov	ax, [bufptr]
		mov	bx, [hoffs]
		shr	bx, 1
		add	ax, bx			; TODO: abstract
		mov	bx, 80
		div	bx

		mov	dh, al

		mov	ah, 02h
		mov	bh, 00h

		int	10h			; cursor gotoxy
		jmp	UpdateCurByte

MoveCrsr:	mov	[bufptr], cx
		jmp	MoveCursor

		;;--------------------------------------------;
		;; Find a given byte in the buffer.
		;; Searches from bufptr backwards.
		;; al: byte to seek ->
		;; bx: * -> position in buffer or $ffff if not found
BufFind:	mov	bx, [bufptr]
.Top:		cmp	[cbuffer + bx], al
		je	.Done
		cmp	bx, 0
		je	.NotFound
		dec	bx
		jmp	.Top
.NotFound:	mov	bx, 0ffffh
.Done:		ret

;--- END -----------------------------------------------------;
