assume cs:codesg

data segment
	db 'conversation',0
data ends

codesg segment
	start:
	;安装中断
	mov ax,cs
	mov ds,ax
	mov si,offset st

	mov ax,0
	mov es,ax
	mov di,200h

	mov cx,offset over - offset st
	cld
	rep movsb

	mov word ptr [7ch*4],200h
	mov word ptr [7ch*4+2],0

	jmp short main
st:
	add [sp],bx
	iret
	; push bp

	; mov bp,sp,
	; dec

	; pop bp
	; iret
over:
	nop

	;中断安装完毕
	main:
		mov ax,data
		mov ds,ax
		mov si,0
		mov ax,b800h
		mov es,ax
		mov di,12*160
	s:
		cmp byte ptr [si],0
		je ok
		movsb
		inc si
		add di,2
		mov bx,offset s - offset ok
		int 7ch
	ok:	
		mov ax,4c00h
		int 21h

codesg ends

end start