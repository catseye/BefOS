;--- BEGIN ---------------------------------------------------;

;--- CONSTANTS -----------------------------------------------;

;--- DATA ----------------------------------------------------;

SEGMENT	.data

;--- BSS -----------------------------------------------------;

SEGMENT	.bss

;--- CODE ----------------------------------------------------;

SEGMENT	.text

		;;--------------------------------------------;
		;; Displays the properties of the current page
		;; on the status bar, if there is room.
		;; ax: * -> GARBAGE
		;; si: * -> GARBAGE
		;; di: * -> GARBAGE
		;; cx: * -> GARBAGE
DisplayProperties:mov	al, 1
		call	AssertStatusBar

		mov	di, 24			; position on screen
		mov	cx, 58			; length of bar
		mov	ax, 2020h		; attr + char
		call	DrawBar

;		mov	di, 0
;.Green:		mov	ax, di			; TODO: abstract into routine
;		shl	ax, 1
;		mov	si, ax			; si = di * 2
;		mov	ax, 2020h
;		mov	[es:si + 24], ax
;		inc	di
;		cmp	di, 58
;		jne	.Green

		mov	di, 0
		cmp	[cheader], word 0bef0h	; validate header ID.
		je	.Draw
		jmp	MoveCursor
						; TODO: abstract into routine.
.Draw:		mov	ax, di			; show file description.
		shl	ax, 1
		mov	si, ax			; si = di * 2
		mov	ah, 71h
		mov	al, [cheader + 32 + di]
		mov	[es:si + 100], ax
		inc	di
		cmp	di, 16
		jne	.Draw

		mov	ah, 71h
		mov	bx, [cheader+2]
		mov	di, 32
		call	DisplayShort

		mov	ah, 74h
		mov	bx, [cheader+4]
		call	DisplayShort

		mov	ah, 7ah
		mov	bx, [cheader+6]
		call	DisplayShort

		mov	ah, 7bh
		mov	bx, [cheader+8]
		call	DisplayShort

		mov	ah, 70h
		mov	bx, [cheader+10]
		call	DisplayShort

		jmp	MoveCursor



		;;--------------------------------------------;
		;; Edits the properties of the current page
		;; in the status bar, if there is room.
		;; ax: * -> GARBAGE
		;; si: * -> GARBAGE
		;; di: * -> GARBAGE
EditPageProps:	call	EditModeOnly
		mov	al, 1
		call	AssertStatusBar

		cmp	[cheader], word 0bef0h	; first off validate header ID.
		jnz	.Abort
		mov	di, 0
		jmp	.Edit
.Abort:		jmp	BadLight
.Edit:		mov	ah, 71h
		mov	di, 100
		mov	cx, 16
		call	EditString
						; TODO: abstract into routine.
		mov	di, 0
.Save:		mov	ax, di			; read file description.
		shl	ax, 1
		mov	si, ax			; si = di * 2
		mov	ax, [es:si + 100]
		mov	[cheader + 32 + di], al
		inc	di
		cmp	di, 16
		jne	.Save

		mov	ah, 71h
		mov	bx, [cheader+2]
		push	bx
		mov	di, 32
		call	EditShort
		mov	[cheader+2], bx

		mov	ah, 74h
		mov	bx, [cheader+4]
		pop	bx
		call	EditShort
		mov	[cheader+4], bx

		mov	ah, 7ah
		mov	bx, [cheader+6]
		call	EditShort
		mov	[cheader+6], bx

		mov	ah, 7bh
		mov	bx, [cheader+8]
		call	EditShort
		mov	[cheader+8], bx

		mov	ah, 70h
		mov	bx, [cheader+10]
		call	EditShort
		mov	[cheader+10], bx

		jmp	MoveCursor


		;;--------------------------------------------;
		;; Initializes the properties of the page.
		;; Sets the signature to bef0h and zeroes out
		;; the page number links.
		;; ax: * -> GARBAGE
		;; si: * -> GARBAGE
		;; di: * -> GARBAGE
InitPageProps:	call	EditModeOnly
		mov	[cheader], word 0bef0h
		xor	ax, ax
		mov	[cheader+2], ax
		mov	[cheader+4], ax
		mov	[cheader+6], ax
		mov	[cheader+8], ax
		mov	[cheader+10], ax
		jmp	DisplayProperties



		;;--------------------------------------------;
		;; Invalidates the properties of the page.
		;; Sets the signature to 0000h.
		;; ax: * -> GARBAGE
		;; si: * -> GARBAGE
		;; di: * -> GARBAGE
DelPageProps:	call	EditModeOnly
		mov	[cheader], word 0000h	; invalidate the header ID.
		jmp	DisplayProperties

;--- END -----------------------------------------------------;
