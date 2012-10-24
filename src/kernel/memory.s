;--- BEGIN ---------------------------------------------------;

;--- CONSTANTS -----------------------------------------------;

;--- DATA ----------------------------------------------------;

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

;--- END -----------------------------------------------------;
