;func：	在指定位置（行、列）用指定颜色来显示以0为结尾的字符串
;参数：	dh：行号，	dl：列号,	cl：颜色，	ds:si：字符串地址
;返回：	无

show_str: 

	;保护寄存器,栈结构：cx,di,ax,bx
	push bx
	;cx需要判断0，将cl中的颜色转移到bl	
	mov bl,cl
	push ax
	push di
	push cx
	push dx
	
	;main start
	mov ax,0
	mov di,0
	mov cx,0

	;calculate address of show-memary and send to di
	mov al,160
	mul dh
	mov dh,0
	add ax,dx
	add ax,dx
	mov di,ax 	;get 目标偏移地址
	mov ax,0b800h
	mov es,ax	;get 目标段地址

show:	;ds:[si] -> es:[di]
	
	mov cl,[si]
	mov es:[di],cl
	inc si
	inc di
	mov es:[di],bl
	inc di
	jcxz back
	jmp show

back:
	pop dx
	pop cx
	pop di
	pop ax
	pop bx
	ret