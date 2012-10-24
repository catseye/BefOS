;--- BEGIN ---------------------------------------------------;

;--- CONSTANTS -----------------------------------------------;

;--- DATA ----------------------------------------------------;

SEGMENT	.data

;--- BSS -----------------------------------------------------;

SEGMENT	.bss

;--- CODE ----------------------------------------------------;

SEGMENT	.text

		;;--------------------------------------------;
		;; Allow user to change a 16-bit value displayed
		;; on-screen as a hexadecimal integer.
		;; ah: attributes -> GARBAGE
		;; al: * -> GARBAGE
		;; bx: number to edit -> edited number
		;; di: location on screen -> INCREMENTED
		;; cx: * -> GARBAGE
		;; dx: * -> GARBAGE
EditShort:	mov	[attr], ah
		mov	[temp2], bx
		mov	[temp], di
		call	DisplayShort

		mov	ax, [temp]
		shr	ax, 1
		mov	[temp], di

.Cur:		xor	dx, dx			; TODO: abstract
		mov	bx, 80
		div	bx
		mov	dh, al
		add	dl, 3			; cursor to right of num
		mov	ah, 02h
		mov	bh, 00h
		int	10h			; cursor gotoxy

						; loop and modify temp2
.Select:	call	GetKey
		cmp	cl, 13
		je	.Done

		mov	al, cl
		call	HexToNybble
		test	al, 10h
		jnz	.Select

.AnyDigit:	shl	word [temp2], 4
		or	[temp2], al

		mov	bx, [temp2]
		mov	ax, [temp]
		sub	ax, 8
		mov	di, ax
		mov	ah, [attr]
		call	DisplayShort

		jmp	.Select

.Done:		mov	di, [temp]		; restore registers
		mov	bx, [temp2]
		ret


		;;--------------------------------------------;
		;; Allow user to change a string on-screen.
		;; ah: attributes -> GARBAGE
		;; al: * -> GARBAGE
		;; bx: * -> GARBAGE
		;; di: location on screen -> ???
		;; cx: length of string -> GARBAGE
		;; dx: * -> GARBAGE
EditString:	mov	[attr], ah
		mov	[temp], di
		mov	[templen], cx

		mov	dx, 0

.Cur:		mov	ax, [temp]
		shr	ax, 1
		add	ax, dx
		mov	[temp2], dx

		xor	dx, dx
		mov	bx, 80
		div	bx
		mov	dh, al
		mov	ah, 02h
		mov	bh, 00h
		int	10h			; cursor gotoxy

						; loop and modify temp2
.Select:	xor	ah, ah			; get a key
		int	16h
		mov	[keyhit], ax

		cmp	ax, 4b00h
		jne	.Next1

		mov	dx, [temp2]
		cmp	dx, 0
		je	.CarryOn
		dec	dx
		jmp	.CarryOn

.Next1:		cmp	ax, 4d00h
		jne	.Next2

		mov	dx, [temp2]
		inc	dx
		jmp	.CarryOn

.Next2:		cmp	al, 13
		je	.Bail

;		mov	bx, ax
;		mov	ah, 07h
;		mov	di, 140
;		call	DisplayShort

		mov	dx, [temp2]
		shl	dx, 1
		mov	di, [temp]
		add	di, dx
		mov	ah, [attr]
		mov	[es:di], ax

		mov	dx, [temp2]
		inc	dx
.CarryOn:	mov	cx, [templen]
		cmp	dx, cx
		je	.Bail

		jmp	.Cur

.Bail:		mov	di, [temp]		; restore registers
		mov	bx, [temp2]
		ret

;--- END -----------------------------------------------------;
