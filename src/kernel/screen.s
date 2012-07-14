;--- CONSTANTS -----------------------------------------------;

;--- DATA ----------------------------------------------------;

SEGMENT .bss

winbuf:		RESW	4096

SEGMENT	.data

winbufptr:	dw	winbuf

;--- CODE ----------------------------------------------------;

SEGMENT	.text

		;;--------------------------------------------;
		;; Given a row and a column, determine offset.
		;; al: row (0-based) -> GARBAGE
		;; ah: column (0-based) -> GARBAGE
		;; cx: * -> GARBAGE
		;; dx: * -> GARBAGE
		;; di: * -> offset
CalcScreenOffset:mov	cl, ah
		xor	ch, ch
		xor	ah, ah
		xor	dx, dx
		mul	word [bytesperline]
		shl	cx, 1
		add	ax, cx
		mov	di, ax
		ret



		;;--------------------------------------------;
		;; Save a row of the screen to a buffer.
		;; di: ptr to start of screen row -> INCREMENTED
		;; cl: length of row -> 0
		;; ax: * -> GARBAGE
		;; si: * -> GARBAGE
SaveScreenRow:	mov	si, [winbufptr]
.Loop:		mov	ax, [es:di]
		mov	[ds:si], ax
		inc	di
		inc	di
		inc	si
		inc	si
		dec	cl
		jnz	.Loop
		mov	[winbufptr], si
		ret

		;;--------------------------------------------;
		;; Save a portion of the screen to a buffer.
		;; al: row (0-based) of upper-left corner ->
		;; ah: column (0-based) of upper-left corner ->
		;; bl: height of portion to save -> 0
		;; bh: width of portion to save ->
		;; cx: * -> GARBAGE
		;; di: * -> GARBAGE
SaveScreen:	push	ax
		push	bx
		call	CalcScreenOffset
.Loop:		mov	cl, bh
		push	di
		call	SaveScreenRow
		pop	di
		add	di, [bytesperline]
		dec	bl
		jnz	.Loop
		mov	di, [winbufptr]
		pop	bx
		pop	ax
		mov	[ds:di], ax
		inc	di
		inc	di
		mov	[ds:di], bx
		inc	di
		inc	di
		mov	[winbufptr], di
		ret


		;;--------------------------------------------;
		;; Restore a row of the screen from the buffer.
		;; di: ptr to start of screen row -> INCREMENTED
		;; cl: length of row -> 0
		;; ch: * -> GARBAGE
		;; ax: * -> GARBAGE
		;; si: * -> GARBAGE
RestoreScreenRow:xor	ch, ch
		mov	si, [winbufptr]
		mov	ax, cx
		shl	ax, 1
		sub	si, ax
		mov	[winbufptr], si
.Loop:		mov	ax, [ds:si]
		mov	[es:di], ax
		inc	di
		inc	di
		inc	si
		inc	si
		dec	cl
		jnz	.Loop
		ret


		;;--------------------------------------------;
		;; Restore a portion of the screen from buffer.
		;; *: * -> GARBAGE
RestoreScreen:	mov	di, [winbufptr]
		dec	di
		dec	di
		mov	bx, [ds:di]		; bl = height, bh = width
		dec	di
		dec	di
		mov	ax, [ds:di]		; al = row, ah = column
		mov	[winbufptr], di
		add	al, bl			; work from bot to top!
		dec	al
		call	CalcScreenOffset	; di = offset
.Loop:		mov	cl, bh
		push	di
		call	RestoreScreenRow
		pop	di
		sub	di, [bytesperline]
		dec	bl
		jnz	.Loop
		ret

PopUpTest:	mov	ax, 200ah
		mov	bx, 0a05h
		call	SaveScreen

		mov	bh, 0
		mov	cx, 0a20h		; (10,32)-
		mov	dx, 0e29h		; (14,41)
		mov	ax, 0600h		; BIOS clear rectangle
		int	10h

		; draw a border here!

		call	GetKey
		
		call	RestoreScreen
		ret


;--- END -----------------------------------------------------;
