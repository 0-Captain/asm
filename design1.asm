assume cs:codesg

data segment
	db "1975", "1976", "1977", "1978", "1979", "1980", "1981", "1982", "1983", "1984", "1985", "1986", "1987", "1988", "1989", "1990", "1991", "1992", "1993", "1994", "1995"
	dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514,345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
	dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226,11542,11430,15257,17800
	db 21 dup (20h,20h,20h,20h)
data ends

table segment
	; db 21 dup ('year',09h, 20h,20h,20h,20h,20h,20h,20h,20h,09h, 20h,20h,20h,20h,20h,20h,20h,20h,09h,20h,20h,20h,20h, 0ah)
	db 37 dup (20h)
table ends

;idata表示data段中的三个数组的基址，分别为0，84，168；si和bx为变址，其中si每次循环增加4，对应年份和收入，bx每次增加2对应员工数；
codesg segment
	start:	mov ax,data
			mov ds,ax
			mov ax,table
			mov es,ax

			mov bx,0
			mov si,0
			;此处设置显示的开始位置与颜色
			mov dh,04h
			mov dl,05h

			mov cx,21
	input: 	;将年份移动到table
			push cx
			push dx

			mov di,0
			mov dx,[0][si]		
			mov es:[di],dx
			add di,2
			mov dx,[0][si+2]
			mov es:[di],dx
			add di,7

			;移动收入
			; mov dx,[84][si]		
			; mov es:[di].5,dx
			; mov dx,[84][si+2]
			; mov es:[di].7,dx
			call dword_trans_10
			add di,13

			;移动雇员
			; mov dx,[168][bx]	
			; mov es:[di].0ah,dx
			mov ax,[168][bx]
			call word_trans_10
			add di,9

			;计算平均收入
			mov ax,[84][si]
			mov dx,[84][si+2]
			div word ptr [168][bx]
			; mov es:[di].0dh,ax
			call word_trans_10
			add di,5



			mov word ptr es:[di],0
			; 显示 设置参数 (此时的数据在es:[0]开始的地方，需要吧ds设置为es的值，si至0)
			pop dx
			mov cl,02h
			push ds
			push es
			pop ds
			pop es
			push si
			mov si,0
			call show_str
			pop si
			push ds
			push es
			pop ds
			pop es
			
			add si,4
			add bx,2

			inc dh
			pop cx

			loop input

			mov   ax,4c00h   
			int   21h  


;word型数据转化为十进制的ascii码
;数据源为ax  目标地址为es:[di]
word_trans_10:
	push di
	push ax
	push bx
	push cx
	push dx

	mov bx,0
	transfrom:	;4位16进制数转10进制,数据源在ax
		inc bx	;计数，得到10进制数的位数
		mov cx,10
		mov dx,0
		div cx
		push dx
		mov cx,ax
		jcxz over1
		jmp transfrom

	over1:	;十进制数的每一位都转换为ascii码
		mov cx,bx
		to_ascii1:
			pop ax
			add ax,30h
			mov es:[di],al
			inc di
			loop to_ascii1
	pop dx
	pop cx
	pop bx
	pop ax
	pop di
	ret

;dword型数据转化为十进制的ascii码
;数据源为ds:[si]  目标地址为es:[di]
dword_trans_10:
	push di
	push ax
	push cx
	push bx
	push dx
	mov bx,0
; main:
	mov ax,[84][si]
	mov dx,[84][si+2]

	loop1:
	inc bx
	mov cx,10
	call divdw
	push cx

	clc
	add ax,dx
	adc ax,0
	mov cx,ax
	jcxz over2
	jmp loop1

	over2:	;十进制数的每一位都转换为ascii码
		mov cx,bx
		to_ascii2:
			pop ax
			add ax,30h
			mov es:[di],al
			inc di
			loop to_ascii2
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
	push es
	
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
	pop es
	pop dx
	pop cx
	pop di
	pop ax
	pop bx
	ret

codesg ends

end start






