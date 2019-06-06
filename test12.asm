assume cs:codesg

codesg segment
start:
	;准备安装中断程序
	mov ax,cs
	mov ds,ax
	mov si,offset do0

	mov ax,0
	mov es,ax
	mov di,200h

	mov cx,offset do0end - offset do0 ;得到中断程序长度
	cld ;设置为正增长
	rep movsb ;将程序复制过去

	;设置中断向量表
	mov ax,0
	mov ds,ax
	mov word ptr ds:[0],200h
	mov word ptr ds:[2],0

	mov ax,4c00h
	int 21h

	do0:
		jmp short begin
		db 'divide error'
		
		begin:
			mov ax,cs
			mov ds,ax
			mov si,202h

			mov ax,0b800h
			mov es,ax
			mov di,12*160+36*2

			mov cx,12
			show:
				mov al,ds:[si]
				mov es:[di],al
				inc si
				inc di
				mov byte ptr es:[di],2
				inc di
				loop show

		mov ax,4c00h
		int 21h

	do0end:
		nop

codesg ends

end start