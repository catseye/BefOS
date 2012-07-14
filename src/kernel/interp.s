;--- BEGIN ---------------------------------------------------;

;--- CONSTANTS -----------------------------------------------;

;--- DATA ----------------------------------------------------;

SEGMENT	.data

beeblequit:	db 00

	;-----BefOS "STACK"-----;
ossp:		dw 0

	;-----Beeblebrox Bindings---;

%include	"../inc/beeble.inc"

;--- BSS -----------------------------------------------------;

SEGMENT	.bss

	;-----SYSTEM STACK------;
osstack:	RESB 256	; BefOS system stack

;--- CODE ----------------------------------------------------;

SEGMENT	.text

		;;--------------------------------------------;
		;; cx: word to push ->
		;; bx: * -> GARBAGE
PushWord:	mov	bx, [ossp]
		mov	[bx + osstack], cx
		inc	word [ossp]
		ret


		;;--------------------------------------------;
		;; cx: * -> word popped
		;; bx: * -> GARBAGE
PopWord:	dec	word [ossp]
		mov	bx, [ossp]
		mov	cx, [bx + osstack]
		ret


PushHexInstr:	mov	bx, [bufptr]
		xor	ch, ch
		mov	cl, [cbuffer + bx]
		sub	cl, 'a'
		jmp	PushWord


AddWords:	call	PopWord
		mov	ax, cx
		call	PopWord
		add	ax, cx
		mov	cx, ax
		jmp	PushWord


SubWords:	call	PopWord
		mov	ax, cx
		call	PopWord
		sub	ax, cx
		mov	cx, ax
		jmp	PushWord


MulWords:	call	PopWord
		mov	ax, cx
		call	PopWord
		mul	cx
		mov	cx, ax
		jmp	PushWord


DivWords:	call	PopWord
		mov	ax, cx
		call	PopWord
		div	cx
		mov	cx, ax
		jmp	PushWord


Beeblebrox:	xor	al, al
		mov	[beeblequit], al

.Loop:		mov	al, [beeblequit]
		cmp	al, 0
		jne	.BeebleQuit
		call	ExecBeebInstr
		jmp	.Loop
.BeebleQuit:	ret


EndBeeblebrox:	mov	[beeblequit], byte 1
		ret


ExecBeebInstr:	mov	di, [bufptr]
		xor	bh, bh
		mov	bl, [cbuffer + di]

		shl	bx, 1
		mov	ax, [scripttab + bx]
		call	ax
		jmp	Advance


StringMode:	jmp	Unimp


RunBeeble:	call	BufHome
		mov	[lastmove], word BufRight
		jmp	Beeblebrox


;--- END -----------------------------------------------------;
