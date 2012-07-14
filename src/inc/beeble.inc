SEGMENT	.data

scripttab:	dw	ClrScreen	; 00 - explicit blank
		dw	Unimp		; 01 - line happy
		dw	Unimp		; 02 - solid happy
		dw	Unimp		; 03 - heart
		dw	Unimp		; 04 - diamond
		dw	Unimp		; 05 - club
		dw	Unimp		; 06 - spade
		dw	Unimp		; 07 - middot
		dw	Advance		; 08 - inverted middot
		dw	Unimp		; 09 - middot outline
		dw	Unimp		; 0a - inverted middot outline
		dw	Unimp		; 0b - male
		dw	Unimp		; 0c - female
		dw	Unimp		; 0d - eighth note
		dw	Unimp		; 0e - two sixteenth notes
		dw	Unimp		; 0f - snowflake

		dw	BufHopRight	; 10 - right wedge
		dw	BufHopLeft	; 11 - left wedge
		dw	Unimp		; 12 - up-down arrow
		dw	Unimp ;WriteCom	; 13 - double exclamation
		dw	Unimp ;ReadCom		; 14 - paragraph
		dw	Unimp		; 15 - cyclone
		dw	Unimp		; 16 - thick low bar
		dw	Unimp		; 17 - up-down arrow underlined
		dw	BufUp		; 18 - up arrow
		dw	BufDown		; 19 - down arrow
		dw	BufRight	; 1a - right arrow
		dw	BufLeft		; 1b - left arrow
		dw	Unimp		; 1c - upside down pistol pointing right
		dw	Unimp		; 1d - left-right arrow
		dw	BufHopUp	; 1e - up wedge
		dw	BufHopDown	; 1f - down wedge

		dw	OKLight		; 20 - space
		dw	Unimp		; 21 - !
		dw	StringMode	; 22 - "
		dw	Unimp		; 23 - #
		dw	PopWord		; 24 - $
		dw	Unimp		; 25 - %
		dw	Unimp		; 26 - &
		dw	Unimp		; 27 - '
		dw	PrevPage	; 28 - (
		dw	NextPage	; 29 - )
		dw	MulWords	; 2a - *
		dw	AddWords	; 2b - +
		dw	Unimp		; 2c - ,
		dw	SubWords	; 2d - -
		dw	Unimp		; 2e - .
		dw	DivWords	; 2f - /

		dw	Unimp		; 30 - 0
		dw	Unimp		; 31 - 1
		dw	Unimp		; 32 - 2
		dw	Unimp		; 33 - 3
		dw	Unimp		; 34 - 4
		dw	Unimp		; 35 - 5
		dw	Unimp		; 36 - 6
		dw	Unimp		; 37 - 7
		dw	Unimp		; 38 - 8
		dw	Unimp		; 39 - 9
		dw	Unimp		; 3a - :
		dw	Unimp		; 3b - ;
		dw	Unimp		; 3c - <
		dw	Unimp		; 3d - =
		dw	Unimp		; 3e - >
		dw	Unimp		; 3f - ?

		dw	Unimp		; 40 - @
		dw	Unimp		; 41 - A
		dw	CopyByte	; 42 - B
		dw	CopyPage	; 43 - C
		dw	Unimp		; 44 - D
		dw	EditMode	; 45 - E
		dw	FillPage	; 46 - F
		dw	GoPage		; 47 - G
		dw	HelpPage	; 48 - H
		dw	Unimp		; 49 - I
		dw	Unimp		; 4a - J
		dw	Unimp		; 4b - K
		dw	Unimp ;DrawLine	; 4c - L
		dw	Unimp		; 4d - M
		dw	Unimp		; 4e - N
		dw	Unimp		; 4f - O

		dw	Unimp ;DrawPix		; 50 - P
		dw	EndBeeblebrox	; 51 - Q
		dw	Unimp		; 52 - R
		dw	SavePage	; 53 - S
		dw	Unimp		; 54 - T
		dw	Unimp		; 55 - U
		dw	PastePage	; 56 - V
		dw	PasteByte	; 57 - W
		dw	PixVid		; 58 - X
		dw	Unimp		; 59 - Y
		dw	Unimp ;InitCom		; 5a - Z
		dw	PageDown	; 5b - [
		dw	Unimp		; 5c - \
		dw	PageUp		; 5d - ]
		dw	Unimp		; 5e - ^
		dw	Unimp		; 5f - _

		dw	Unimp		; 60 - ` (lowercase + 20)
		dw	PushHexInstr	; 41 - a
		dw	PushHexInstr	; 42 - b
		dw	PushHexInstr	; 43 - c
		dw	PushHexInstr	; 44 - d
		dw	PushHexInstr	; 45 - e
		dw	PushHexInstr	; 46 - f
		dw	Unimp		; 47 - g
		dw	Unimp		; 48 - h
		dw	Unimp		; 49 - i
		dw	Unimp		; 4a - j
		dw	Unimp		; 4b - k
		dw	LoadPage	; 4c - l
		dw	Unimp		; 4d - m
		dw	Unimp		; 4e - n
		dw	Unimp		; 4f - o

		dw	Unimp		; 70 - p
		dw	Unimp		; 51 - q
		dw	Unimp		; 52 - r
		dw	Unimp		; 53 - s
		dw	Unimp		; 54 - t
		dw	Unimp		; 55 - u
		dw	Unimp		; 56 - v
		dw	WriteByte	; 57 - w
		dw	Unimp		; 58 - x
		dw	Unimp		; 59 - y
		dw	Unimp		; 5a - z
		dw	Unimp		; 7b - {
		dw	Unimp		; 7c - |
		dw	Unimp		; 7d - }
		dw	Unimp		; 7e - ~
		dw	Unimp		; 7f - delta

		dw	AskGoPage	; 80 - capital C cedille
		dw	BufHome		; 81 - lower u umlaut
		dw	LeftMarg	; 82 - lower e acute
		dw	LineFeed	; 83 - lower a circumflex
		dw	LessScreen	; 84 - lower a umlaut
		dw	MoreScreen	; 85 - lower a grave
		dw	NextTextVidPage	; 86 - 
		dw	PrevTextVidPage	; 87 - 
		dw	NextDisk	; 88 - 
		dw	PrevDisk	; 89 - 
		dw	Unimp		; 8a - 
		dw	Unimp		; 8b - 
		dw	Unimp		; 8c - 
		dw	Unimp		; 8d - 
		dw	Unimp		; 8e - 
		dw	EditPageProps	; 8f - 

		dw	Unimp		; 90 - 
		dw	Unimp		; 91 - 
		dw	Unimp		; 92 - 
		dw	Unimp		; 93 - 
		dw	Unimp		; 94 - 
		dw	Unimp		; 95 - 
		dw	Unimp		; 96 - 
		dw	Unimp		; 97 - 
		dw	Unimp		; 98 - 
		dw	Unimp		; 99 - 
		dw	Unimp		; 9a - 
		dw	Unimp		; 9b - 
		dw	Unimp		; 9c - 
		dw	Unimp		; 9d - 
		dw	Unimp		; 9e - 
		dw	Unimp		; 9f - 

		dw	Unimp		; a0 -
		dw	Unimp		; a1 -
		dw	Unimp		; a2 -
		dw	Unimp		; a3 -
		dw	Unimp		; a4 -
		dw	Unimp		; a5 -
		dw	Unimp		; a6 -
		dw	Unimp		; a7 -
		dw	Unimp		; a8 -
		dw	Unimp		; a9 -
		dw	Unimp		; aa -
		dw	Unimp		; ab -
		dw	Unimp		; ac -
		dw	Unimp		; ad -
		dw	Unimp		; ae -
		dw	Unimp		; af -

		dw	Unimp		; b0 - 
		dw	Unimp		; b1 - 
		dw	Unimp		; b2 - 
		dw	Unimp		; b3 - 
		dw	Unimp		; b4 - 
		dw	Unimp		; b5 - 
		dw	Unimp		; b6 - 
		dw	Unimp		; b7 - 
		dw	Unimp		; b8 - 
		dw	Unimp		; b9 - 
		dw	Unimp		; ba - 
		dw	Unimp		; bb - 
		dw	Unimp		; bc - 
		dw	Unimp		; bd - 
		dw	Unimp		; be - 
		dw	Unimp		; bf - 

		dw	Unimp		; c0 - 
		dw	Unimp		; c1 - 
		dw	Unimp		; c2 - 
		dw	Unimp		; c3 - 
		dw	Unimp		; c4 - 
		dw	Unimp		; c5 - 
		dw	Unimp		; c6 - 
		dw	Unimp		; c7 - 
		dw	Unimp		; c8 - 
		dw	Unimp		; c9 - 
		dw	Unimp		; ca - 
		dw	Unimp		; cb - 
		dw	Unimp		; cc - 
		dw	Unimp		; cd - 
		dw	Unimp		; ce - 
		dw	Unimp		; cf - 

		dw	Unimp		; d0 - 
		dw	Unimp		; d1 - 
		dw	Unimp		; d2 - 
		dw	Unimp		; d3 - 
		dw	Unimp		; d4 - 
		dw	Unimp		; d5 - 
		dw	Unimp		; d6 - 
		dw	Unimp		; d7 - 
		dw	Unimp		; d8 - 
		dw	Unimp		; d9 - 
		dw	Unimp		; da - 
		dw	Unimp		; db - 
		dw	Unimp		; dc - 
		dw	Unimp		; dd - 
		dw	Unimp		; de - 
		dw	Unimp		; df - 

		dw	Unimp		; e0 - 
		dw	Unimp		; e1 - 
		dw	Unimp		; e2 - 
		dw	Unimp		; e3 - 
		dw	Unimp		; e4 - 
		dw	Unimp		; e5 - 
		dw	Unimp		; e6 - 
		dw	Unimp		; e7 - 
		dw	Unimp		; e8 - 
		dw	Unimp		; e9 - 
		dw	Unimp		; ea - 
		dw	Unimp		; eb - 
		dw	Unimp		; ec - 
		dw	Unimp		; ed - 
		dw	Unimp		; ee - 
		dw	Unimp		; ef - 

		dw	Unimp		; f0 - 
		dw	Unimp		; f1 - 
		dw	Unimp		; f2 - 
		dw	Unimp		; f3 - 
		dw	Unimp		; f4 - 
		dw	Unimp		; f5 - 
		dw	Unimp		; f6 - 
		dw	Unimp		; f7 - 
		dw	Unimp		; f8 - 
		dw	Unimp		; f9 - 
		dw	Unimp		; fa - 
		dw	Unimp		; fb - 
		dw	Unimp		; fc - 
		dw	Unimp		; fd - 
		dw	Unimp		; fe - 
		dw	Unimp		; ff - 
