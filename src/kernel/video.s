;--- BEGIN ---------------------------------------------------;

;--- DATA ----------------------------------------------------;

SEGMENT	.data

vpage:		db 00		; current video page
vbase:		dw 0b800h	; text area (next page = 0b900h?)
pixbase:	dw 0a000h	; graphics mode area

;--- CODE ----------------------------------------------------;

SEGMENT	.text

DiscoverVidBase:mov	ax, 0500h    ; SELECT ACTIVE DISPLAY PAGE -> 0
		int	10h
		mov	ah, 15       ; GET CURRENT VIDEO MODE, ah -> col, al -> mode, bh -> active page
		int	10h
		cmp	al, 7
		jne	.UseDefault
		mov	[vbase], word 0b000h
.UseDefault:	ret

TextVidBase:	mov	es, [vbase]
		ret

PixVidBase:	mov	es, [pixbase]
		ret

		; TODO: determine if the text video page is already active;
		; if so, only swap pages with TextVidPage.
		; this will reduce flicker on return to OS from application.

TextVid:        mov     ax, 0003h
        	int	10h
		mov     ax, 0500h
		int	10h
		mov	[vpage], byte 0

;		mov	ax, ds
;		mov	es, ax
;		mov	ax, 1100h
;		mov	bp, offset charset
;		mov	cx, 256		; num of chars to be reimaged
;		mov	dx, 0		; first char num to be reimaged
;		mov	bl, 0		; block to load in "map 2"
;		mov	bh, 16		; bytes per char-image
;		int	10h

		call	TextVidBase
	        call	OKLight
		call	RefreshStatus
		jmp	DisplayPage


PixVid:       	mov     ax, 0013h
	        int	10h
        	jmp	PixVidBase


NextTextVidPage:mov	al, [vpage]
		inc	al
		and	al, 7
		mov	[vpage], al
		mov     ah, 05h
		int	10h
		; TODO: change vid base
		ret


PrevTextVidPage:mov	al, [vpage]
		dec	al
		and	al, 7
		mov	[vpage], al
		mov     ah, 05h
		int	10h
		; TODO: change vid base
		ret

ClrScreen:	mov	bh, cl
		xor	cx, cx			; (0,0)-
		mov	dx, 184fh		; (79,24)
		mov	ax, 0600h		; BIOS clear rectangle
		int	10h
		ret


;--- END -----------------------------------------------------;
