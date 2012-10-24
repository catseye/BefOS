;--- BEGIN ---------------------------------------------------;

;--- DATA ----------------------------------------------------;

SEGMENT	.data

diskno:		dw 0000h	; current disk number
sectrk:		dw 18		; sectors per track
bytesec: 	dw 512		; bytes per sector
numhead:	dw 2		; number of heads

;--- CODE ----------------------------------------------------;

SEGMENT	.text

NextDisk:	call	NotInEditMode
		inc	word [diskno]
		cmp	[diskno], word 2	; 2 devices?!?
		jne	.Return
		mov	[diskno], word 0
.Return:	jmp	LoadPage


PrevDisk:	call	NotInEditMode
		dec	word [diskno]
		cmp	[diskno], word 0ffffh
		jne	.Return
		mov	[diskno], word 1
.Return:	jmp	LoadPage



DiskInfo:	mov	ah, 15h
		mov	bx, [bufptr]
		mov	dl, [cbuffer + bx]
		int	13h		; DISK - GET DISK TYPE
		jc	.Error

		push	cx
		push	dx

		mov	ah, 5fh
		pop	bx
		mov	di, 124
		call	DisplayShort
		pop	bx
		call	DisplayShort

		jmp	OKLight

.Error:		jmp	BadLight


		;;--------------------------------------------;
		;; Read a page (four contiguous sectors) from
		;; the current disk (actually disk #0 for now.)
		;; ax: page number -> number of errors
		;; bx: address of 2048-byte buffer -> GARBAGE
		;; cx: * -> GARBAGE
		;; dx: * -> GARBAGE
		;; di: * -> DESTROYED
		;; TODO: DISALLOW ACCESS OUTSIDE BOUNDS OF DISK
ReadPage:	push	es
		mov	cx, ds
		mov	es, cx
		shl	ax, 1
		shl	ax, 1

.Begin:		xor	dx, dx		; Zero high
		div	word [sectrk]	; Calculate track
		mov	cl, dl		; CL = sector
		inc	cl
		xor	dx, dx		; Zero high
		div	word [numhead]	; Compute head
		mov	ch, al		; CH = cylinder
		mov	dh, dl		; DH = head
		xor	dl, dl		; DL = drive 0
		mov	di, 3		; Try three times

.Read1:		mov	ax, 0204h	; Read 4 sectors
		int	13h		; Call BIOS
                jnc     .Read2		; Success
		dec	di		; Reduce count
                jnz     .Read1		; Keep trying
		mov	ax, 1		; DISK ERROR
		jmp	.Exit

.Read2:		xor	ax, ax		; Zero return
.Exit:		pop	es
		ret


		;;--------------------------------------------;
		;; Write a page (four contiguous sectors) to
		;; the current disk (actually disk #0 for now.)
		;; ax: page number -> number of errors
		;; bx: address of 2048-byte buffer -> GARBAGE
		;; cx: * -> GARBAGE
		;; dx: * -> GARBAGE
		;; di: * -> DESTROYED
		;; TODO: DISALLOW ACCESS OUTSIDE BOUNDS OF DISK

WritePage:	push	es
		mov	cx, ds
		mov	es, cx
		shl	ax, 1
		shl	ax, 1

.Begin:		xor	dx, dx		; Zero high
		div	word [sectrk]	; Calculate track
		mov	cl, dl		; CL = sector
		inc	cl		; 1-
		xor	dx, dx		; Zero high
		div	word [numhead]	; Compute head
		mov	ch, al		; CH = cylinder
		mov	dh, dl		; DH = head
		xor	dl, dl		; DL = drive #0
		mov	di, 3		; Try three times

.Write1:	mov	ax, 0304h	; Write 4 sectors
		int	13h		; Call BIOS
                jnc     .Write2		; Success
		dec	di		; Reduce count
                jnz     .Write1		; Keep trying
		mov	ax, 1		; DISK ERROR
		jmp	.Exit

.Write2:	xor	ax, ax		; Zero return
.Exit:		pop	es
		ret

;--- END -----------------------------------------------------;
