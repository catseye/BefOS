; Boot Block for BefOS.

; Boot Block is one sector (= 512 bytes.)
; Program must be =< 510 bytes in length.
; Byte 511 must be 55h and byte 512 must be aah.

; Boot Block loads at 0000:7C00.
; In turn, it loads KERNEL_SIZE sectors
; off the disk starting at sector KERNEL_POS
; into memory at BEFOS_SEG:BEFOS_OFF.


;--- BEGIN ---------------------------------------------------;

BITS	16
ORG	7C00h

;--- INCLUDES -----------------------------------------------;

%include "../inc/befos.inc"

;--- CONSTANTS -----------------------------------------------;

INT13_READCODE	EQU	02h

KERNEL_SIZE	EQU	16	; * 512 = 8K = 4 BefOS Pages (2K ea)
KERNEL_POS	EQU	4	; start sector

SEC_TRACK	EQU	18	; sectors per track (on a floppy)
NUM_HEADS	EQU	2	; number of heads (on a floppy)

KERNEL_SEC	EQU	(KERNEL_POS % SEC_TRACK) + 1
KERNEL_CYL	EQU	(KERNEL_POS / SEC_TRACK) / NUM_HEADS
KERNEL_HEAD	EQU	(KERNEL_POS / SEC_TRACK) % NUM_HEADS
KERNEL_DRIVE	EQU	0

KERNEL_AX	EQU	KERNEL_SIZE + (INT13_READCODE * 256)
KERNEL_CX	EQU	KERNEL_SEC + (KERNEL_CYL * 256)
KERNEL_DX	EQU	KERNEL_DRIVE + (KERNEL_HEAD * 256)

;--- CODE ----------------------------------------------------;

SEGMENT	.text

;--- Main ----------------------------------------------------;

Main:	mov	ax, cs		; find DATA segment
        mov	ds, ax		; assign to ds register

        mov	ax, 0b800h	; ASSUMES COLOR VGA 80x25 TEXT
        mov	es, ax
	mov	di, 0
	mov	[es:di], word 02f42h	; the BefOS 'logo'

;--- Load ----------------------------------------------------;

; the following should be tried three times!

	mov	di, 4

Reset:	dec	di
	jz	NoGood
	mov	ah, 00h		; call code = reset
	mov	dl, 00h		; drive
	int	13h

Load:	mov	ax, BEFOS_SEG	; dest segment
	mov	es, ax
	mov	bx, BEFOS_OFF	; dest offset

	mov	cx, KERNEL_CX
	mov	dx, KERNEL_DX

	mov	ax, KERNEL_AX
	int	13h
	jc	Reset

        mov	ax, 0b800h	; ASSUMES COLOR VGA 80x25 TEXT
        mov	es, ax
	mov	di, 0
	mov	[es:di], word 00f24h	; '$'

	jmp	BEFOS_SEG:BEFOS_OFF

NoGood:	mov	ah, 0ah
	mov	al, 'X'
	mov	bh, 0
	mov	bl, 1
	int	10h
	jmp	NoGood

;--- DATA ----------------------------------------------------;

SEGMENT	.data

; nothing here now
