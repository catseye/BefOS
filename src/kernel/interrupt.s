;--- BEGIN ---------------------------------------------------;

;--- DATA ----------------------------------------------------;

SEGMENT	.data

timerSegment:	dw 0
timerOffset:	dw 0
comSegment:	dw 0
comOffset:	dw 0
breakSegment:	dw 0
breakOffset:	dw 0
prtscSegment:	dw 0
prtscOffset:	dw 0

;--- CODE ----------------------------------------------------;

SEGMENT	.text

		;;--------------------------------------------;
		;; Install an interrupt handler.
		;; bl: interrupt number -> GARBAGE
		;; cx: segment of interrupt handler routine -> GARBAGE
		;; di: offset of interrupt handler routine -> GARBAGE
		;; ax: * -> GARBAGE
		;; bh: * -> GARBAGE
WriteIntr:	push	es

		xor	bh, bh
		shl	bx, 2		; bx = zero page intr loc

		xor	ax, ax
		mov	es, ax

		cli			; disable interrupts
					; poke vector into zero page

		mov	[es:0000h + bx], di
		mov	[es:0002h + bx], cx

		sti			; enable interrupts

		pop	es
		ret


		;;--------------------------------------------;
		;; Retrieve an interrupt handler.
		;; bl: interrupt number -> GARBAGE
		;; cx: * -> segment of interrupt handler routine
		;; di: * -> offset of interrupt handler routine
		;; ax: * -> GARBAGE
		;; bh: * -> GARBAGE
ReadIntr:	push	es

		xor	bh, bh
		shl	bx, 2		; bx = zero page intr loc
					; peek vector from zero page

		xor	ax, ax
		mov	es, ax

		mov	di, [es:0000h + bx]
		mov	cx, [es:0002h + bx]

		pop	es
		ret


PlugClock:	call	WorkLight

		mov	bl, 1ch
		call	ReadIntr

		mov	[timerSegment], cx
		mov	[timerOffset], di

		mov	cx, cs
		mov	di, ClockISR
		mov	bl, 1ch		; user clock interrupt
		call	WriteIntr

		jmp	OKLight



UnplugClock:	call	WorkLight
		mov	cx, [timerSegment]
		cmp	cx, 0
		je	.Fail
		mov	[timerSegment], word 0
		mov	di, [timerOffset]
		mov	bl, 1ch		; user clock interrupt
		call	WriteIntr
		call	OKLight
		ret
.Fail:		jmp	BadLight



ClockISR:	push	ax
		push	bx
		push	cx
		push	dx
		push	ds
		push	es
		push	di

		mov	ax, 0040h
		mov	ds, ax
		mov	cx, [006ch]		; get timer value from BIOS
		mov	ax, cs
		mov	ds, ax
		call	TextVidBase		; since we have no assurance
						; that es=screen during intr
		call	StatusWord

		pop	di
		pop	es
		pop	ds
		pop	dx
		pop	cx
		pop	bx
		pop	ax

		iret



PlugBreak:	call	WorkLight

		mov	bl, 1bh
		call	ReadIntr

		mov	[breakSegment], cx
		mov	[breakOffset], di

		mov	cx, cs
		mov	di, BreakISR
		mov	bl, 1bh		; user clock interrupt
		call	WriteIntr

		jmp	OKLight



UnplugBreak:	call	WorkLight
		mov	cx, [breakSegment]
		cmp	cx, 0
		je	.Fail
		mov	[breakSegment], word 0
		mov	di, [breakOffset]
		mov	bl, 1bh		; user clock interrupt
		call	WriteIntr
		jmp	OKLight
.Fail:		jmp	BadLight



;	This is a *very* special kind of ISR; it takes a very
;	proactive approach to resetting BefOS.

BreakISR:	mov	ax, cs
		mov	ds, ax

		call	UnplugClock
		;call	UnplugCom
		call	UnplugBreak
		call	UnplugPrtSc

		xor	al, al
		mov	[flags], al		; clear modes

		sti

;	At this point, we can't even get back to the caller,
;	so dismiss the idea of ending this with 'iret' or 'retf'.
;	Instead we shall use a far jump.

		jmp	BEFOS_SEG:BEFOS_OFF



PlugPrtSc:	call	WorkLight

		mov	bl, 05h
		call	ReadIntr

		mov	[prtscSegment], cx
		mov	[prtscOffset], di

		mov	cx, cs
		mov	di, PrtScISR
		mov	bl, 05h		; prtsc interrupt
		call	WriteIntr

		jmp	OKLight



UnplugPrtSc:	call	WorkLight
		mov	cx, [prtscSegment]
		cmp	cx, 0
		je	.Fail
		mov	[prtscSegment], word 0
		mov	di, [prtscOffset]
		mov	bl, 05h		; prtsc interrupt
		call	WriteIntr
		jmp	OKLight
.Fail:		jmp	BadLight


PrtScISR:	push	ax
		push	bx
		push	cx
		push	dx
		push	ds
		push	es
		push	di

		call	TextVidBase		; since we have no assurance
						; that es=screen during intr
		mov	ax, 1234h
		call	Light

		pop	di
		pop	es
		pop	ds
		pop	dx
		pop	cx
		pop	bx
		pop	ax

		iret
