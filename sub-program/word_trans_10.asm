;word型数据转化为十进制的ascii码
;数据源为ds:[si]  目标地址为es:[di]
word_trans_10:
	push di
	push ax
	push bx
	push cx
	push dx

	mov dx,0
	mov ax,[si]
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
	pop dx
	pop cx
	pop bx
	pop ax
	pop di
	ret

