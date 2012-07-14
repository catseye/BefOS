DATASEG

baud		dw	08h
comhead		dw	combuf
comtail		dw	combuf

CODESEG

PUBLIC	InitCom
PROC	InitCom

		mov	ax, 0400h	; ext. init COM port
		mov	bx, 0
		mov	cx, 0300h
		add	cx, [word baud]
		mov	dx, 0		; COM1
		int	14h		; init port

		mov	ax, 0500h
		int	14h
		or	bl, 3		; up my DTR & RTS
		mov	ax, 0501h
		int	14h

		and	ax, 8e00h
		cmp	ax, 0
		je	@@Great
		jmp	BadLight
@@Great:	jmp	OKLight

ENDP

PUBLIC	StatCom
PROC	StatCom
		mov	ax, 0300h
		mov	dx, 0
		int	14h		; check port
		mov	cx, ax
		ret
ENDP

PUBLIC	WriteCom
PROC	WriteCom
; cl = char to write
@@OutAgain:	mov	dx, 03f8h + 5
		in	al, dx
		and	al, 020h
		jz	@@OutAgain

		mov	al, cl
		mov	dx, 03f8h
		out	dx, al
ENDP

PUBLIC	ReadCom
PROC	ReadCom
; read cl from combuf.
; returns ch = number of chars (0 or 1.)

		mov	bx, [word comhead]
		cmp	bx, [word comtail]
		je	@@Nothing

		mov	cl, [byte combuf + bx]
		inc	bx
		cmp	bx, 2048
		jne	@@NoWrap
		xor	bx, bx

@@NoWrap:	mov	[word comhead], bx
		mov	ch, 1
		ret

@@Nothing:	xor	cx, cx
		ret
ENDP

PUBLIC	PlugCom
PROC	PlugCom

		call	WorkLight

		mov	cl, 0ch
		call	ReadIntr

		mov	ax, es
		mov	[word comSegment], ax
		mov	[word comOffset], di

		mov	ax, cs
		mov	es, ax
		mov	di, offset ComISR
		mov	cl, 0ch		; com #0 interrupt
		call	WriteIntr

		; the 8259 stuff

		in	al, 021h	; 8259_1 line: read 8259 enable masks
		and	al, 0efh	; clear masked bit, enabling IRQ
		out	021h, al	; spit back out, write new masks

		; the 8250 stuff

		mov	dx, 03f8h + 3	; LineControl
		in	al, dx
		and	al, 07fh	; clear bit 7 "DLAB"
		out	dx, al

		mov	dx, 03f8h + 1	; InterruptEnable
		xor	al, al
		inc	al
		out	dx, al

		; clear Rx, LineStatus, ModemStatus

@@ClearLines:	mov	dx, 03f8h
		in	al, dx
		add	dx, 5
		in	al, dx
		inc	dx
		in	al, dx

		; keep doing so until we get green flag.

		mov	dx, 03f8h + 2	; IntIdent
		in	al, dx
		test	al, 1
		jz	@@ClearLines

		; set bit 3 of ModemControl

		mov	dx, 03f8h + 4	; ModemControl
		in	al, dx
		or	al, 08h
		out	dx, al		; Blastoff!

		call	OKLight

		ret
ENDP

PUBLIC	UnplugCom
PROC	UnplugCom

		call	WorkLight
		mov	ax, [word comSegment]
		cmp	ax, 0
		je	@@Fail
		mov	[word comSegment], 0
		mov	es, ax
		mov	di, [word comOffset]
		mov	cl, 0ch		; com #0 interrupt
		call	WriteIntr
		call	OKLight
		ret
@@Fail:		jmp	BadLight
ENDP

PUBLIC	ComISR
PROC	ComISR
		push	ax
		push	bx
		push	dx
		push	ds

		mov	ax, cs
		mov	ds, ax

		mov	dx, 03f8h
		in	al, dx		; al = char read from port

		mov	bx, [word comtail]
		mov	[byte combuf + bx], al	; store in buffer
		inc	bx

		cmp	bx, 2048
		jne	@@NoWrap

		xor	bx, bx

@@NoWrap:	mov	[word comtail], bx

		; issue end-of-interrupt to 8259.

		mov	al, 020h
		out	020h, al	; 8259_0 line

		pop	ds
		pop	dx
		pop	bx
		pop	ax

		iret
ENDP
