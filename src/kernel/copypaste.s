;--- BEGIN ---------------------------------------------------;

;--- CONSTANTS -----------------------------------------------;

;--- DATA ----------------------------------------------------;

SEGMENT	.data

coybyte:	db 01

;--- BSS -----------------------------------------------------;

SEGMENT	.bss

;--- CODE ----------------------------------------------------;

SEGMENT	.text

		;;--------------------------------------------;
		;; Copy page in memory to clipboard.
		;; ax: * -> GARBAGE
		;; di: * -> GARBAGE
CopyPage:	mov	di, 0
.Copy:		mov	ax, di
		mov	al, [cbuffer + di]
		mov	[bbuffer + di], al
		inc	di
		cmp	di, 2048
		jne	.Copy
		jmp	OKLight


		;;--------------------------------------------;
		;; Copy page in memory to clipboard and erase it.
		;; ax: * -> GARBAGE
		;; di: * -> GARBAGE
CutPage:	call	EditModeOnly
		call	CopyPage
		jmp	FillPage



		;;--------------------------------------------;
		;; Copy clipboard contents to page buffer.
		;; ax: * -> GARBAGE
		;; di: * -> GARBAGE
PastePage:	call	EditModeOnly
		mov	di, 0
.Copy:		mov	ax, di
		mov	al, [bbuffer + di]
		mov	[cbuffer + di], al
		inc	di
		cmp	di, 2048
		jne	.Copy
		jmp	DisplayPage



		;;--------------------------------------------;
		;; Fill page buffer with current byte.
		;; bl: * -> GARBAGE
		;; di: * -> GARBAGE
		;; *: * -> GARBAGE
FillPage:	call	EditModeOnly
		mov	di, [bufptr]
		mov	bl, [cbuffer + di]
		mov	di, 0
.Fill:		mov	[cbuffer + di], bl
		inc	di
		cmp	di, 2000
		jne	.Fill
		jmp	DisplayPage


		;;--------------------------------------------;
		;; Copy current byte from page to clipbyte.
		;; al: * -> GARBAGE
		;; di: * -> GARBAGE
CopyByte:	mov	di, [bufptr]
		mov	al, [cbuffer + di]
		mov	[coybyte], al
		jmp	OKLight


		; PasteByte - copy byte from clipboard to page
		; al,cl,di=DESTROYED
PasteByte:	call	EditModeOnly
		mov	di, [bufptr]
		mov	al, [coybyte]
		mov	[cbuffer + di], al
		mov	cl, al
		jmp	ShowByte

;--- END -----------------------------------------------------;
