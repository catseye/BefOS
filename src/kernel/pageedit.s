;--- BEGIN ---------------------------------------------------;

;--- CONSTANTS -----------------------------------------------;

;--- DATA ----------------------------------------------------;

SEGMENT	.data

;--- BSS -----------------------------------------------------;

SEGMENT	.bss

;--- CODE ----------------------------------------------------;

SEGMENT	.text


		; ax may be destroyed
EditModeOnly:	test	[flags], byte FLAG_EDIT
		jnz	.Goodness
		call	BadLight
		pop	ax
.Goodness:	ret


		; ax may be destroyed
NotInEditMode:	test	[flags], byte FLAG_EDIT
		jz	.Goodness
		call	BadLight
		pop	ax
.Goodness:	ret



ToggleHighBit:	call	EditModeOnly
		mov	bx, [bufptr]
		mov	cl, [cbuffer + bx]
		xor	cl, 80h
		mov	[cbuffer + bx], cl
		jmp	ShowByte


		; Enter into EditMode
EditMode:	or	[flags], byte FLAG_EDIT
		jmp	EditLight

		; Exit EditMode
NoEditMode:	and	[flags], byte ~FLAG_EDIT
		jmp	NoEditLight


		; IncByte
		; al,cl,di=DESTROYED
IncByte:	mov	al, 1
		jmp	DeltaByte


		; DecByte
		; al,cl,di=DESTROYED
DecByte:	mov	al, -1
		; FALLTHROUGH
		; DeltaByte
		; al=delta
		; cl,di=DESTROYED
DeltaByte:	call	EditModeOnly
		mov	di, [bufptr]
		mov	cl, [cbuffer + di]
		add	cl, al
		jmp	ShowByte


ShowByte:	call	WriteByte
		jmp	UpdateCurByte


;--- END -----------------------------------------------------;
