;--- BEGIN ---------------------------------------------------;

;--- CONSTANTS -----------------------------------------------;

;--- DATA ----------------------------------------------------;

SEGMENT	.data

;--- Global Descriptor Table (GDT) ---------------------------;
	
gdt:		times 16 db 0
srclen:		dw 0
srcaddr:	dw 0
		db 0
srcacc:		db 93h
srchigh:	dw 0
destlen:	dw 0
destaddr:	dw 0
		db 0
destacc:	db 93h
desthigh:	dw 0
gdtpad:		times 16 db 0

;--- BSS -----------------------------------------------------;

SEGMENT	.bss

basek:		RESW 1		; non-extended kilobytes
extk:		RESW 1		; extended kilobytes

;--- CODE ----------------------------------------------------;

SEGMENT	.text

DiscoverRAM:	int	12h			; get avail base mem in k
		mov	[basek], ax

		mov	ax, 8800h
		int	15h			; SYSTEM - GET EXTENDED MEMORY SIZE (286+)
		mov	[extk], ax
		
		ret


StoreExtPage:	push	es
		call	WorkLight

		mov	[srclen], word 2048
		mov	[srcaddr], word cbuffer
		mov	ax, ds
		shl	ax, 4
		add	[srcaddr], ax
		mov	ax, ds
		shr	ax, 12
		mov	[srcaddr+2], al

		mov	[destlen], word 2048
		mov	[destaddr], word 0
		mov	[destaddr+2], byte 10h

		mov	ax, ds
		mov	es, ax
		mov	ah, 87h
		mov	cx, 1024
		mov	si, gdt
		int	15h

		jc	.Error
		pop	es
		jmp	OKLight
.Error:		pop	es
		jmp	BadLight


RetrieveExtPage:push	es
		call	WorkLight

		mov	[srclen], word 2048
		mov	[srcaddr], word 0
		mov	[srcaddr+2], byte 10h

		mov	[destlen], word 2048
		mov	[destaddr], word cbuffer
		mov	ax, ds
		shl	ax, 4
		add	[destaddr], ax
		mov	ax, ds
		shr	ax, 12
		mov	[destaddr+2], al

		mov	ax, ds
		mov	es, ax
		mov	ah, 87h
		mov	cx, 1024
		mov	si, gdt
		int	15h

		jc	.Error
		pop	es
		call	OKLight
		jmp	DisplayPage
.Error:		pop	es
		jmp	BadLight

;--- END -----------------------------------------------------;
