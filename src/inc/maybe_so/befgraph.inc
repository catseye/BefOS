CENX		EQU	160	; center of VGA screen xwise
CENY		EQU	100	; center of VGA screen ywise

CODESEG

;	mov	di, [word tcol]
;	inc	di
;	mov	[word tcol], di
;	mov	si, di
;	mov	ax, [word mx]
;	mov	bx, [word my]
;	mov	cx, 160
;	mov	dx, 199
;	call	LINE
;
;	; now, is there a keypress outstanding?
;
;	mov	ah, 1
;	int	16h	
;	jz	@@Tram
;	jmp	@@Test
;
;	; IF A$ = "" THEN
;

PUBLIC	SynchRaster
PROC	SynchRaster
; dx,al = DESTROYED

	mov	dx, 03dah
@@VRT3:	in	al, dx
	test	al, 08h
	je	@@VRT3
ENDP

;	mov	si, 0
;	mov	ax, [word mx]
;	mov	bx, [word my]
;	mov	cx, 160
;	mov	dx, 199
;	call	LINE
;

PUBLIC	DrawPix
PROC	DrawPix
; es SHOULD BE SET TO pixbase FIRST!!
	;	ah = y coordinate
	;	bx = x coordinate
	;	dl = colour
	;	cx, al DESTROYED

	; VGA[(py<<8)+(py<<6)+px]=color;

	xor	al, al
	mov	cx, ax
	shr	cx, 2
	add	ax, cx
	add	ax, bx
	mov	di, ax
	mov	[byte es:di], dl
	ret
ENDP

;	Thanks for the following algorithm goes to lines.c
;	by David Brackeen (http://silo.csci.unt.edu/home/brackeen/vga/)

PUBLIC	DrawLine
PROC	DrawLine
; es SHOULD BE SET TO pixbase FIRST!!
	;	ax = x1 coordinate
	;	bx = y1 coordinate
	;	cx = x2 coordinate
	;	dx = y2 coordinate
	;	si = colour

	;  px=x1;
	;  py=y1;

	mov	[word lpx], ax
	mov	[word lpy], bx

	;  dx=x2-x1; (cx-ax) /* the horizontal distance of the line */
	;  dy=y2-y1; (bh-bl) /* the vertical distance of the line */

	sub	cx, ax
	mov	[word ldx], cx

	sub	dx, bx
	mov	[word ldy], dx

	mov	bx, si
	mov	[byte lcol], bl

	;  dxabs=abs(dx);
	;  dyabs=abs(dy);
	;  sdx=sgn(dx);
	;  sdy=sgn(dy);

	mov	[word lsdx], 1
	cmp	cx, 0
	jge	@@S1

	neg	cx
	mov	[word lsdx], -1

@@S1:	mov	[word ldxabs], cx

	mov	[word lsdy], 1
	cmp	dx, 0
	jge	@@S2

	neg	dx
	mov	[word lsdy], -1

@@S2:	mov	[word ldyabs], dx

	;  x=dyabs>>1;
	;  y=dxabs>>1;

	shr	cx, 1
	mov	[word ly], cx

	shr	dx, 1
	mov	[word lx], dx

	; VGA[(py<<8)+(py<<6)+px]=color;

	mov	bx, [word lpx]
	mov	ax, [word lpy]
	mov	ah, al
	mov	dl, [byte lcol]
	call	DrawPix

	;  if (dxabs>=dyabs) /* the line is more horizontal than vertical */
	;  {

	mov	ax, [word ldyabs]
	cmp	ax, [word ldxabs]
	jg	@@Vert

	;	if dx>=dy we draw dy horizontal lines
	;	staggered between y1 and y2.
	;	each line is of length dx/dy

	;    for(i=0;i<dxabs;i++) ( i == bx )
	;    {

	xor	bx, bx
@@B1:	cmp	bx, [word ldxabs]
	jge	@@E1

	;      y+=dyabs;

	mov	ax, [word ldyabs]
	add	ax, [word ly]
	mov	[word ly], ax

	;      if (y>=dxabs)
	;      {

	cmp	ax, [word ldxabs]
	jl	@@NE1

	;        y-=dxabs;

	sub	ax, [word ldxabs]
	mov	[word ly], ax

	;        py+=sdy;

	mov	ax, [word lsdy]
	add	[word lpy], ax

	;      }

@@NE1:
	;      px+=sdx;

	mov	ax, [word lsdx]
	add	[word lpx], ax

	;      plot_pixel(px,py,color);

	mov	[word temp], bx
	mov	bx, [word lpx]
	mov	ax, [word lpy]
	mov	ah, al
	mov	dl, [byte lcol]
	call	DrawPix
	mov	bx, [word temp]

	;    }

	inc	bx
	jmp	@@B1

	;  }

@@E1:	jmp	@@Exit

        ; else the line is more vertical than horizontal

@@Vert:	;	if dy>dx we draw dx vertical lines
	;	staggered between x1 and x2.
	;	each line is of length dy/dx

	;  {
	;    for(i=0;i<dyabs;i++) (i == bl)

	xor	bx, bx
@@B2:	cmp	bx, [word ldyabs]
	jge	@@E1

	;    {
	;      x+=dxabs;

	mov	ax, [word ldxabs]
	add	ax, [word lx]
	mov	[word lx], ax

	;      if (x>=dyabs)
	;      {

	cmp	ax, [word ldyabs]
	jl	@@NE2

	;        x-=dyabs;

	sub	ax, [word ldyabs]
	mov	[word lx], ax

	;        px+=sdx;

	mov	ax, [word lsdx]
	add	[word lpx], ax

	;      }

@@NE2:
	;      py+=sdy;

	mov	ax, [word lsdy]
	add	[word lpy], ax

	;      plot_pixel(px,py,color);

	mov	[word temp], bx
	mov	bx, [word lpx]
	mov	ax, [word lpy]
	mov	ah, al
	mov	dl, [byte lcol]
	call	DrawPix
	mov	bx, [word temp]

	;    }

	inc	bx
	jmp	@@B2

	;  }

@@Exit:	ret

ENDP
