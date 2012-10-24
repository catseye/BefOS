;--- BEGIN ---------------------------------------------------;

BITS	16
ORG	0100h

;--- Externals -----------------------------------------------;

%include	"../inc/bekernel.inc"

;--- BSS -----------------------------------------------------;

SEGMENT	.bss

status:		RESW	1
keyhit:		RESW	1

;--- CODE ----------------------------------------------------;

SEGMENT	.text

;--- Main ----------------------------------------------------;

Main:		call	BefTermScreen

		; mov	cx, 19200
		mov	bx, BefOS_InitCom
		call	BefOS

		mov	bx, BefOS_PlugCom
		call	BefOS

PollLoop:	mov	bx, BefOS_ReadCom
		call	BefOS

		cmp	ch, 0
		je	CheckKey
		jmp	ReadData

CheckKey:	mov	bx, BefOS_ReadKey
		call	BefOS

		cmp	cx, 0
		je	PollLoop
		mov	[keyhit], cx	; else retrieve
		mov	ax, cx

FinalAlt:	cmp	ax, 1000h	; Alt-Q
		jne	RealKey

		mov	bx, BefOS_UnplugCom
		call	BefOS

		mov	bx, BefOS_TextVid
		call	BefOS
		retf

RealKey:	cmp	al, 0
		jne	ASCIIKey

ASCIIKey:	mov	bx, BefOS_WorkLight
		call	BefOS

		mov	cx, [keyhit]
		mov	bx, BefOS_WriteCom
		call	BefOS

		mov	bx, BefOS_OKLight
		call	BefOS

		jmp	PollLoop

ReadData:	mov	al, cl

		;mov	bx, BefOS_EditLight
		;call	BefOS

		cmp	al, 13
		jne	NotReturn

		mov	bx, BefOS_LeftMarg
		call	BefOS
		jmp	CheckKey

NotReturn:	cmp	al, 10
		jne	NotLineFeed

		mov	bx, BefOS_LineFeed
		call	BefOS
		jmp	CheckKey

NotLineFeed:	cmp	al, 12
		jne	NotFormFeed

		call	BefTermScreen
		jmp	CheckKey

NotFormFeed:	xor	cx, cx
		mov	cl, al
		mov	bx, BefOS_WriteByte
		call	BefOS
		mov	bx, BefOS_BufRight
		call	BefOS

SkipRead:	jmp	CheckKey



BefTermScreen:	mov	cx, 0
		mov	bx, BefOS_MoveCrsr
		call	BefOS
		mov	cl, 6dh
		mov	bx, BefOS_ClrScreen
		call	BefOS
		mov	bx, BefOS_RefreshStatus
		jmp	BefOS
