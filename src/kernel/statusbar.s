;--- BEGIN ---------------------------------------------------;

;--- CONSTANTS -----------------------------------------------;

WORK_LIGHT	EQU	0ee0ah
OK_LIGHT	EQU	02a0ah
BAD_LIGHT	EQU	0cc0ah

EDIT_LIGHT	EQU	02e45h
NO_EDIT_LIGHT	EQU	02f20h

;--- DATA ----------------------------------------------------;

SEGMENT	.data

bytesperline:	dw	160	; bytes per line
hoffs:		dw	160	; number of heading lines displayed,
				; in byte offset (1 line = 160)

;--- BSS -----------------------------------------------------;

SEGMENT	.bss

;--- CODE ----------------------------------------------------;

SEGMENT	.text

		;;--------------------------------------------;
		;; Returns from caller if there are not enough
		;: status bar lines visible on the screen.
		;; Also switches to text mode if there are.
		;; ah: -> GARBAGE
		;; al: minimum number of lines showing -> GARBAGE
		;; dx: -> GARBAGE
AssertStatusBar:xor	ah, ah
		xor	dx, dx
		mul	word [bytesperline]
		cmp	[hoffs], ax
		jb	.NotEnough
		jmp	.Enough
.NotEnough:	pop	ax
.Enough:	ret



		;;--------------------------------------------;
		;; Shrinks the status bar, if possible.
		;; *: -> GARBAGE
MoreScreen:	cmp	[hoffs], word 0
		ja	.LessHeader
		ret
.LessHeader:	sub	[hoffs], word 160
		call	MoveCursor
		jmp	DisplayPage



		;;--------------------------------------------;
		;; Expands the status bar, if possible.
		;; *: -> GARBAGE
LessScreen:	cmp	[hoffs], word 2560
		jb	.MoreHeader
		ret
.MoreHeader:	add	[hoffs], word 160

		mov	ax, [bufptr]
		mov	bx, [hoffs]
		shr	bx, 1
		add	ax, bx
		cmp	ax, 2000
		jb	.InRange

		sub	[bufptr], word 80

.InRange:	cmp	[hoffs], word 320
		jae	.Blanks
		cmp	[hoffs], word 160
		jne	.StillOn
		call	OKLight
		call	RefreshStatus
.StillOn:	jmp	DisplayPage
.Blanks:	mov	ax, 2020h
		mov	di, 160
		mov	cx, [hoffs]
		sub	cx, di
		call	DrawBar
		jmp	DisplayPage



		;;--------------------------------------------;
		;; Refreshes the status bar, if possible.
		;; *: -> GARBAGE
RefreshStatus:	mov	al, 1
		call	AssertStatusBar

		mov	di, 0
		mov	[es:di], word 02f42h	; the BefOS 'logo'

		test	[flags], byte FLAG_EDIT
		jnz	.EditMode
		call	NoEditLight
		jmp	.Next
.EditMode:	call	EditLight

.Next:		mov	di, 6
		mov	word [es:di], NO_EDIT_LIGHT	; TODO - DrawBar

		mov	di, 8
		mov	bx, [basek]
		mov	ah, 07h
		call	DisplayShort

		mov	di, 16
		mov	bx, [extk]
		mov	ah, 70h
		call	DisplayShort

		call	ShowKeyStroke

		;call	ShowPageNo
		mov	ah, 03h
		mov	bx, [pageno]		; Display page number onscreen
		mov	di, 152
		jmp	DisplayShort



		;;--------------------------------------------;
		;; Display the current byte in the page buffer
		;; on the status bar, if it is visible.
		;; *: -> GARBAGE
UpdateCurByte:	mov	al, 1
		call	AssertStatusBar
		
		mov	di, [bufptr]
		mov	bl, [cbuffer + di]

		mov	ah, 1fh
		mov	di, 148
		jmp	DisplayByte


		;;--------------------------------------------;
		;; Display the scancode of the last keystroke
		;; on the status bar, if it is visible.
		;; *: -> GARBAGE
ShowKeyStroke:	mov	al, 1
		call	AssertStatusBar
		mov	bx, [keyhit]
		mov	ah, 70h
		mov	di, 140
		jmp	DisplayShort


		;;--------------------------------------------;
		;; Displays the given word in the 'status' area
		;; on the status bar, if it is visible.
		;; cx: word to display
		;; *: -> GARBAGE
StatusWord:     mov	al, 1
		call	AssertStatusBar

		mov     di, 24
		mov     bx, cx
		mov     ah, 3fh
		jmp     DisplayShort



		;;--------------------------------------------;
		;; Display the 'working' light.
		;; ax: * -> GARBAGE
WorkLight:	mov	ax, WORK_LIGHT
		jmp	Light

		;;--------------------------------------------;
		;; Display the 'action failed' light.
		;; ax: * -> GARBAGE
BadLight:	mov	ax, BAD_LIGHT
		jmp	Light

		;;--------------------------------------------;
		;; Display the 'OK' light.
		;; ax: * -> GARBAGE
OKLight:	mov	ax, OK_LIGHT
		; FALLTHROUGH

		;;--------------------------------------------;
		;; Displays the BefOS 'light' as the given
		;; character with the given attributes.
		;; ah: attributes ->
		;; al: character ->
		;; di: * -> screen location
Light:		cmp	[hoffs], word 0
		jbe	.NoRoom
		mov	di, 2
		mov	[es:di], ax
.NoRoom:	ret


EditLight:	cmp	[hoffs], word 0
		jbe	.NoRoom
		mov	ax, EDIT_LIGHT
		mov	di, 4
		mov	[es:di], ax
.NoRoom:	ret

NoEditLight:	cmp	[hoffs], word 0
		jbe	.NoRoom
		mov	ax, NO_EDIT_LIGHT
		mov	di, 4
		mov	[es:di], ax
.NoRoom:	ret

;--- END -----------------------------------------------------;
