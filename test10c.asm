.8086
assume cs:codesg

data segment
	dw 123,12666,1,8,3,38,0
data ends

numascii segment
	db 64 dup (0)
numascii ends

codesg segment
	start:
		mov ax,data
		mov ds,ax
		mov si,0

		mov ax,numascii
		mov es,ax

		mov dh,8
		mov dl,3
		mov cl,2 

		call show_num

		mov ax,4c00h
		int 21h

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
		;4位16进制数转10进制,数据源在ax
	transfrom:
		inc bx	;计数，得到10进制数的位数
		mov cx,10
		mov dx,0
		div cx
		push dx
		mov cx,ax
		jcxz over
		jmp transfrom
	over:
		;十进制数的每一位都转换为ascii码
		mov cx,bx
	to_ascii:
		pop ax
		add ax,30h
		mov es:[di],al
		inc di
		loop to_ascii

		;移入一个空格
		mov byte ptr es:[di],32
		add di,1

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


codesg ends

end start