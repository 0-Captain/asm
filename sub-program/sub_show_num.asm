;功能：	在指定的行列，用指定的颜色，显示数值的十进制码
;参数：	dh：行号，	dl：列号,	cl：颜色， ds:[si]：数字地址 word型  es:[di]：可供使用的内存
;		ch: ch = 1代表dword型数据，ch=0代表word型数据	
;返回：	无

show_num:
	push di
	push ax
	push bx
	push cx
	push dx

	;main
trans_all:
	mov ax,[si]
	add si,2
	mov bx,0
	
	; ;判断ax是否为数字，是数字继续往下执行，否则直接写入目的地址
	; mov cx,0
	; sub ax,2fh
	; mov ch,ah	;如果ah=0 => ch=0
	; not cx		
	; jcxz transform 	
	; ;---判断结束---

	transfrom:	;4位16进制数转10进制,数据源在ax
		inc bx	;计数，得到10进制数的位数
		mov cx,10
		mov dx,0
		div cx
		push dx
		mov cx,ax
		jcxz over
		jmp transfrom

	over:	;十进制数的每一位都转换为ascii码
		mov cx,bx
		to_ascii:
			pop ax
			add ax,30h
			mov es:[di],al
			inc di
			loop to_ascii

	;移入一个空格
	; mov byte ptr es:[di],32
	; add di,1

	mov cx,ds:[si]
	jcxz finish
	jmp trans_all

finish:
	mov word ptr es:[di],0
	;10进制转为字符串，将字符串地址设为ds:si
	mov ax,es
	mov ds,ax
	pop dx
	pop cx
	pop bx
	pop ax
	pop di
	mov si,di
	;show
	call show_str	

	ret


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
	
	
	