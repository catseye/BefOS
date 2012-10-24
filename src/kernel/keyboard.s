;--- BEGIN ---------------------------------------------------;

;--- CONSTANTS -----------------------------------------------;

;--- DATA ----------------------------------------------------;

SEGMENT	.data

;--- BSS -----------------------------------------------------;

SEGMENT	.bss

keyhit:		RESW 1		; BIOS code for last key hit
shiftflags:	RESW 1		; shift flags for last key hit

;--- CODE ----------------------------------------------------;

SEGMENT	.text

		;;--------------------------------------------;
		;; Wait for a key to be pressed, and return
		;; its scancode.  Scancode is also displayed
		;; on status bar, if visible.  The scancode
		;; and shift flags are also available in variables.
		;; cx: * -> scancode of pressed key
		;; ax: * -> GARBAGE
GetKey:		mov	ah, 12h
		int	16h		; get key shift states

		mov	[shiftflags], ax

		;mov	cx, ax
		;call	StatusWord

; Notes: AL bit 3 set only for left Alt key on many machines.
; AH bits 7 through 4 always clear on a Compaq SLT/286.
; INT 16/AH=09h should be used to determine whether this function
; is supported.

; Bitfields for _al_
;Bit(s)  Description     (Table 00587)
;7      Insert active
;6      CapsLock active
;5      NumLock active
;4      ScrollLock active
;3      Alt key pressed (either Alt on 101/102-key keyboards)
;2      Ctrl key pressed (either Ctrl on 101/102-key keyboards)
;1      left shift key pressed
;0      right shift key pressed

;Bitfields for _ah_
;Bit(s)  Description     (Table 00588)
;7      SysReq key pressed (SysReq is often labeled SysRq)
;6      CapsLock pressed
;5      NumLock pressed
;4      ScrollLock pressed
;3      right Alt key pressed
;2      right Ctrl key pressed
;1      left Alt key pressed
;0      left Ctrl key pressed

		xor	ah, ah			; get a key
		int	16h
		mov	[keyhit], ax

		call	ShowKeyStroke
		mov	cx, [keyhit]
		ret



		;;--------------------------------------------;
		;; Check if a key was pressed; return its
		;; scancode if it was, or 0 if no key was pressed.
		;; cx: * -> scancode of pressed key or 0
		;; ax: * -> GARBAGE
ReadKey:	xor	ah, ah			; check for outstanding key
		inc	ah
		int	16h
		jz	.NoKey
		jmp	GetKey
.NoKey:		xor	cx, cx
		ret

;--- END -----------------------------------------------------;
