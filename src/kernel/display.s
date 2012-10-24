;--- CONSTANTS -----------------------------------------------;

;--- DATA ----------------------------------------------------;

SEGMENT	.data

;--- CODE ----------------------------------------------------;

SEGMENT	.text


		;;--------------------------------------------;
		;; Show an 8-bit unsigned value onscreen, as
		;; an integer in hexadecimal.
		;; ah: attributes -> GARBAGE
		;; al: * -> GARBAGE
		;; bl: number to display -> GARBAGE
		;; di: location on screen -> INCREMENTED
		;; cl: * -> GARBAGE
DisplayByte:	mov	al, bl
		mov	cl, 4
		shr	al, cl
		call	NybbleToHex
		mov	[es:di], ax
		inc	di
		inc	di

		mov	al, bl
		call	NybbleToHex
		mov	[es:di], ax
		inc	di
		inc	di

		ret


		;;--------------------------------------------;
		;; Show a 16-bit unsigned value onscreen, as
		;; an integer in hexadecimal.
		;; ah: attributes -> GARBAGE
		;; al: * -> GARBAGE
		;; bx: number to display -> GARBAGE
		;; di: location on screen -> INCREMENTED
		;; cl: * -> GARBAGE
		;; dx: * -> GARBAGE
DisplayShort:	mov	dx, bx
		mov	bl, bh
		call	DisplayByte
		mov	bx, dx
		jmp	DisplayByte


DebugIt:	mov	es, [vbase]
		xor	di, di
		mov	word [es:di], 00301h
		jmp	DebugIt


		;;--------------------------------------------;
		;; Draw a solid bar on the screen.
		;; ah: attributes -> GARBAGE
		;; al: character -> GARBAGE
		;; di: location on screen -> INCREMENTED
		;; cx: length of bar -> GARBAGE
DrawBar:	mov	[es:di], ax
		inc	di
		inc	di
		dec	cx
		jnz	DrawBar
		ret

;--- END -----------------------------------------------------;
