;dword型数据转化为十进制的ascii码
;数据源为ds:[si]  目标地址为es:[di]

dword_trans_10:
	push di
	push ax
	push cx
	push bx
	push dx
	mov bx,0

	main:
		inc bx
		mov ax,[si]
		mov dx,[si].2
		mov cx,10
		call divdw
		push cx

		clc
		add ax,dx
		adc ax,0
		mov cx,ax
		jcxz over
		jmp main

	over:	;十进制数的每一位都转换为ascii码
		mov cx,bx
		to_ascii:
			pop ax
			add ax,30h
			mov es:[di],al
			inc di
			loop to_ascii

	finish:
		pop dx
		pop bx
		pop cx
		pop ax
		pop di
		ret 




;参数: 	ax：被除数的低16位，	dx：被除数的高16位，	cx：除数
;返回：	ax：结果的低16位，	dx：结果的高16位，	cx：余数
divdw:
	push bx
	push ax
	;栈结构为：[bx->ax]

	mov ax,dx
	mov dx,0
	div cx 		;ax=int(H/N),dx=rem(N/N)
	pop bx		;bx为被除数的低16位. [bx]
	push ax		;[bx->ax=int(H/N)]
	mov ax,bx	;上一次相处的余数在dx正好位于高16位，此时将被除数的低16位移到ax为下一步div作准备
	div cx		;结果低16位在ax
	mov cx,dx	;放余数到cx
	pop dx		;高16位放在dx 	[bx]

	pop bx
	ret