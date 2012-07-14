;--- BEGIN ---------------------------------------------------;

BITS	16
ORG	0100h

;--- CODE ----------------------------------------------------;

SEGMENT	.text

;--- Main ----------------------------------------------------;

Main:	mov	ax, cs		; find DATA segment
        mov	ds, ax		; assign to ds register
	mov	ax, 0b800h	; ASSUMES COLOR VGA 80x25 TEXT
	mov	es, ax

	xor	ax, ax
	xor	bx, bx
	xor	cx, cx
	xor	dx, dx

;	mov     si, 0
;.Cloop:mov     [byte prebuf+si], 32
;	mov     [byte postbuf+si], 32
;	inc     si
;	cmp     si, 162
;	jne     .Cloop

	mov	si, 0
	mov	di, 0
.L1:	mov	al, [es:di]	; get pixel at pt
        cmp     al, 32
	je	.Off
.On:	call	Neighbours
	cmp	al, 2
	je	.Life
	cmp	al, 3
	je	.Life
.Deth:	mov     [cabuf+si], byte 32	; stick zero in lifebuf
	jmp	.Cont
.Off:	call	Neighbours
	cmp	al, 3
	jne	.Deth
        mov     [cabuf+si], byte 32
.Life:	inc	byte [cabuf+si]		; inc lifebuf
        cmp     [cabuf+si], byte 31
	jne	.Cont
	dec	byte [cabuf+si]		; inc lifebuf

.Cont:	inc	di
	inc	di
	inc	si
	cmp	si, 2000
	jne	.L1

	; now, is there a keypress outstanding?

        mov     ah, 1
        int     16h 
        jnz     .Exit

	; no... update screen and repeat

	mov	di, 0
	mov	si, 0
.L2:	mov	al, [cabuf+si]
	mov	[es:di], al
	inc	di
	inc	di
	inc	si
	cmp	si, 2000
	jne	.L2

	mov	di, 0
        mov     si, 0
	jmp	.L1

.Exit:	;mov     ax, 4c00h
        ;int     21h

	retf

;--- Neighbours ----------------------------------------------;

Neighbours:
	; di = position in es where pixel is
	; al = returned: number of 'on' neighbours

	; sum significant bits of: di-1 di+1
	; di-321 di-320 di-319
	; di+319 di+320 di+321

	xor	ax, ax

        cmp     [es:di-2], byte 32
	je	.N1
	inc	al

.N1:	cmp     [es:di+2], byte 32
	je	.N2
	inc	al
	
.N2:	cmp	[es:di-162], byte 32
	je	.N3
	inc	al

.N3:	cmp	[es:di-160], byte 32
	je	.N4
	inc	al

.N4:	cmp	[es:di-158], byte 32
	je	.N5
	inc	al

.N5:	cmp	[es:di+158], byte 32
	je	.N6
	inc	al

.N6:	cmp	[es:di+160], byte 32
	je	.N7
	inc	al

.N7:	cmp	[es:di+162], byte 32
	je	.N8
	inc	al

.N8:	ret

;--- DATA ----------------------------------------------------;

SEGMENT	.bss

cabuf:	RESB	2000
