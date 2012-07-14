;--- CONSTANTS -----------------------------------------------;

;--- DATA ----------------------------------------------------;

SEGMENT	.data

;--- CODE ----------------------------------------------------;

SEGMENT	.text

		;;--------------------------------------------;
		;; Convert a nybble to an ASCII hex digit.
		;; al: nybble -> ASCII hex digit
NybbleToHex:	and	al, 0fh
		cmp	al, 10
		jae	.Hex
		add	al, '0'
		ret
.Hex:		add	al, 'a'-10
		ret


		;;--------------------------------------------;
		;; Convert an ASCII hex digit to a nybble.
		;; al: ASCII hex digit -> nybble
HexToNybble:	cmp	al, 'a'
		jae	.LowerHex
		cmp	al, 'A'
		jae	.UpperHex
		cmp	al, '9'
		ja	.Invalid
		sub	al, '0'
		ret
.LowerHex:	cmp	al, 'f'
		ja	.Invalid
		sub	al, 'a'-10
		ret
.UpperHex:	cmp	al, 'F'
		ja	.Invalid
		sub	al, 'A'-10
		ret
.Invalid:	mov	al, 010h
		ret


		;;--------------------------------------------;
		;; Convert a set of four ASCII hex digits to
		;; a short.
		;; ax: * -> resultant short
		;; bx: pointer to first digit -> INCREMENTED
		;; cx: * -> GARBAGE
		;; dx: * -> GARBAGE
ParseHexShort:	xor	ax, ax
		mov	cx, 4
.Loop:		push	ax
		mov	al, [bx]
		call	HexToNybble
		and	al, 0fh		; TODO - do SOMETHING on error!
		mov	dl, al
		pop	ax

		shl	ax, 1
		shl	ax, 1
		shl	ax, 1
		shl	ax, 1
		or	al, dl

		inc	bx
		dec	cx
		cmp	cx, 0
		jne	.Loop
		ret

;--- END -----------------------------------------------------;
