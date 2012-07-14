;--- BEGIN ---------------------------------------------------;

;--- CONSTANTS -----------------------------------------------;

;--- DATA ----------------------------------------------------;

SEGMENT	.data

pageno:		dw 0008h	; current page number

;--- BSS -----------------------------------------------------;

SEGMENT	.bss

cbuffer: 	RESB 2000	; page data buffer
cheader:	RESB 48		; page properties buffer
bbuffer: 	RESB 2048	; backup page buffer
obuffer:	RESB 2048	; memory copy of colour buffer

;--- CODE ----------------------------------------------------;

SEGMENT	.text


PageUp:		call	NotInEditMode
		inc	word [pageno]
		cmp	[pageno], word 720	; 720 pages - TODO disk max
		jne	.Return
		mov	[pageno], word 0
.Return:	jmp	LoadPage


PageDown:	call	NotInEditMode
		dec	word [pageno]
		cmp	[pageno], word 0ffffh
		jne	.Return
		mov	[pageno], word 719	; TODO disk max - 1
.Return:	jmp	LoadPage


NextPage:	mov	cx, [cheader+2]
		;	FALLTHROUGH
HyperPage:	cmp	cx, 0			; TODO more thorough limits
		je	.Abort
		jmp	GoPage
.Abort:		jmp	BadLight


PrevPage:	mov	cx, [cheader+4]
		jmp	HyperPage


HelpPage:	mov	cx, [cheader+10]
		jmp	HyperPage


ColourPage:	mov	cx, [cheader+8]
		jmp	HyperPage


		; DisplayPage - display in-memory page buffer on-screen
		; ax,si,di=DESTROYED
DisplayPage:	mov	di, 0
.Draw:		mov	ax, di
		shl	ax, 1
		mov	si, ax			; si = di * 2
		mov	ah, [obuffer + di]
		mov	al, [cbuffer + di]
		add	si, [hoffs]
		mov	[es:si], ax
		inc	di
		mov	ax, 4000
		cmp	si, ax
		jne	.Draw
		jmp	DisplayProperties



		;;--------------------------------------------;
		;; Prompt the user for a page number, and jump
		;; to it (make it current, load and display it.)
		;; ax: * -> GARBAGE
		;; si: * -> GARBAGE
		;; di: * -> GARBAGE
		;; *: * -> GARBAGE
AskGoPage:	call	NotInEditMode
		mov	al, 1
		call	AssertStatusBar

		mov	ah, 03h
		mov	bx, [pageno]
		mov	di, 152
		call	EditShort
		mov	cx, bx
		; FALLTHROUGH

		;;--------------------------------------------;
		;; Jump to the given page.
		;; cx: page to jump to -> GARBAGE
		;; *: * -> GARBAGE
GoPage:		call	NotInEditMode
		cmp	cx, 720			; LoadPage/ReadPage
		jae	.Abort			; should handle limits...
		mov	[pageno], cx
		jmp	LoadPage
.Abort:		call	LoadPage
		jmp	BadLight


		;;--------------------------------------------;
		;; Jump to the page number specified by the
		;; first four ASCII hex digits to the right of
		;; the first * to the left of the cursor (!)
		;; *: * -> GARBAGE
JumpPage:	mov	al, '*'
		call	BufFind
		cmp	bx, 0ffffh
		je	.NotFound
		mov	[bufptr], bx
		call	BufRight

		mov	bx, [bufptr]
		add	bx, cbuffer
		call	ParseHexShort

		mov	cx, ax
		jmp     GoPage

.NotFound:	jmp	BadLight


		;;--------------------------------------------;
		;; Read page from disk into buffer and display it.
		;; *: * -> GARBAGE
LoadPage:	call	WorkLight
		call	NoEditMode

		mov	di, 0
		mov	al, 1ah
.Fill:		mov	[cbuffer + di], byte 0	; clear page buffer.
		mov	[obuffer + di], al	; clear colour buffer
		inc	di
		cmp	di, 2000
		jne	.Fill

		mov	ax, [pageno]
		mov	bx, cbuffer
		call	ReadPage

		cmp	ax, 1
		jne	.Cnt

.Error:		call	BadLight
		jmp	.Status

.Cnt:		mov	ax, [cheader]
		cmp	ax, 0bef0h
		jne	.OK

						; read the colour page.
		mov	ax, [cheader+8]		; colour page number
		mov	bx, obuffer

		cmp	ax, 0
		je	.OK
		call	ReadPage
		cmp	ax, 1
		je	.Error

.OK:		call	OKLight

.Status:	cmp	[hoffs], word 0
		ja	.OKGO
		jmp	DisplayPage

.OKGO:		mov	ah, 03h
		mov	bx, [pageno]		; Display page number onscreen
		mov	di, 152
		call	DisplayShort
		jmp	DisplayPage



		;;--------------------------------------------;
		;; Write page from buffer to disk.
		;; When finished, re-display it.
		;; *: * -> GARBAGE
SavePage:	call	EditModeOnly

		call	NoEditMode
		call	WorkLight

		mov	ax, [pageno]
		mov	bx, cbuffer
		call	WritePage

		cmp	ax, 1
		jne	.OK

		call	BadLight
		jmp	.Cnt

.OK:		call	OKLight
		jmp	DisplayPage
.Cnt:		ret

;--- END -----------------------------------------------------;
