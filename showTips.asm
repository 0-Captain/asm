assume cs:code,ds:data

data segment
	table dw resetPc,startSystem,clock,setClock,inputTips,0
	resetPc db '1)reset pc',0
	startSystem db '2)start system',0
	clock db '3)clock',0
	setClock db '4)set clock with format year/month/day hour:minite:second',0
	inputTips db '>'
data ends

code segment
	codeTable dw resetPc0,startSystem0,clock0,setClock0
	start:
		mov ax,data
		mov ds,ax
		mov bx,0

		mov dx,0
		; mov ah,3
		; int 10h ;获取行号和列号分别保存在dh，dl中
		s1:
		mov si,table[bx]
		cmp si,0
		je s1end
		mov cl,7
		call show_str
		add bx,2
		inc dh
		jmp s1
		; 显示tips完成
		s1end:
		; 置光标位置
		inc dl 
		dec dh
		mov bh,0
		mov ah,2
		int 10h

		;等待用户输入
	input:
		mov ah,0
		int 16h
		;输入完成，键入字符保存在ax
		cmp al,31h
		jl input
		cmp al,34h
		ja input
		; 显示输入的字符
		mov bl,7
		mov bh,0
		mov cx,1
		mov ah,09h
		int 10h

		mov cx,cs
		mov ds,cx

		sub al,31h
		mov bx,0
		add al,al
		mov bl,al
		call codeTable[bx]

		jmp near ptr start

		mov ax,4c00h
		int 21h

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

	show0:	;ds:[si] -> es:[di]	
		mov cl,[si]
		mov es:[di],cl
		inc si
		inc di
		mov es:[di],bl
		inc di
		jcxz back0
		jmp show0

	back0:
		pop dx
		pop cx
		pop di
		pop ax
		pop bx
		ret


resetPc0:
	pushf
	mov ax,0ffffh
	push ax
	mov ax,0
	push ax
	iret

startSystem0:
	mov ax,0
	mov es,ax
	mov bx,7c00h

	mov al,1
	mov ch,0
	mov cl,1
	mov dh,0
	mov dl,80h

	mov ah,2
	int 13h

	pushf
	mov ax,0
	push ax
	mov ax,7c00h
	push ax
	iret

clock0:
	
	mov ax,data
		mov ds,ax

		mov ax,0b800h
		mov es,ax
		mov di,50

		mov cx,20
		;dx记录秒，loop1执行完成后dx中的值和ds:[0]中一样说明在同一秒，则再次执行loop1，否则往下执行，输出时间
		mov dl,0ffh

	loop0:
		push cx
		;取出cmos ram中的数据放在内存中
		mov cx,0dh
		mov ax,0
		mov bx,0
	loop1:
		push ax
		out 70h,al
		in al,71h
		mov [bx],al
		inc bx
		pop ax
		inc al
		loop loop1
		
		pop cx
		cmp dl,ds:[0]
		je loop0
		push cx

		mov dl,ds:[0]
		push dx

		mov si,0
		mov dx,2 ;此处dl存放颜色
		;此时把时间数据在ds:[0]开始的位置

		;显示年月日
		mov cx,3
		mov bx,9
		loop2:
			mov al,ds:[si+bx]
			call bcdToAscii
			call show
			mov word ptr es:[di],062fh
			add di,2
			dec bx
		loop loop2
		mov word ptr es:[di-2],0600h

		;显示时分秒
		mov cx,3
		mov bx,4
		loop3:
			mov al,ds:[si+bx]
			call bcdToAscii
			call show
			mov word ptr es:[di],063ah
			add di,2
			sub bx,2
		loop loop3
			mov word ptr es:[di-2],0

		sub di,36
		pop dx
		pop cx
		inc cx
		loop loop0

	iret

	;格式：将一个字节里面的两个压缩bcd数转为其ascii码，存在一个字里面
	;输入：al
	;输出： ax
	bcdToAscii: 
		push cx

		mov ah,0
		mov cl,4
		shl ax,cl
		shr al,cl
		add ax,3030h

		pop cx
		ret

	;将ax中的两个byte数据放到es:[di]，颜色放在dl
	show: 
		push cx

		mov cl,ah
		mov ch,dl
		mov ah,dl
		mov word ptr es:[di],cx
		add di,2
		mov word ptr es:[di],ax
		add di,2

		pop cx
		ret	

;设置时钟需要修改CMOS RAM
setClock0:
	jmp startSet
	db 12 dup(0)

	startSet:
	push ax
	push bx
	push cx
	push dx
	push ds


	mov ah,3
	int 10h ;获取行号和列号分别保存在dh，dl中	

	;设置ds，bx指向本子程序开头处设置的空间
	mov ax,cs
	mov ds,ax
	mov bx,offset setClock0 +3

	inc dh
	mov dl,0;将光标位置设置到下一行行首
	mov cx,12
	startInput:
		push cx
		push bx

		not cl
		and cl,00000001b
		add dl,cl
		; 置光标位置
		inc dl
		mov bh,0
		mov ah,2
		int 10h

		mov ah,0
		int 16h
		cmp al,30h
		jl startInput
		cmp al,39h
		ja startInput
		; 显示输入的字符
		mov bl,2
		mov bh,0
		mov cx,1
		mov ah,09h
		int 10h

		pop bx
		pop cx
		sub al,30h
		mov ds:[bx],al ;将输入的每一个数字存到本程序开始位置处的空间，依次为年月日，时分秒共12个字节
		inc bx
		loop startInput

		;将上面12个字节的非压缩BCD数转换为6字节的压缩BCD数，转换后的结果存在每个字的低位
		; mov bx,offset setClock0 +3
		; mov cx,6
		; yasuoBCD:
		; push cx
		; 	mov al,ds:[bx]
		; 	mov ah,ds:[bx+1]
		; 	mov cx,4
		; 	shl ah,cx
		; 	add al,ah
		; 	mov ds:[bx],al
		; 	mov ds:[bx+1],0
		; 	add bx,2
		; pop cx
		; loop yasuoBCD

		; 置光标位置到下一行
		inc dh
		mov dl,0
		mov bh,0
		mov ah,2
		int 10h


		setOver:
		mov bx,offset setClock0 +3
		mov ax,9
		mov cx,6
		setRAM:
		;处理数据
		push cx
		push ax
		mov al,ds:[bx]
		mov cl,4
		shl al,cl
		inc bx
		mov ah,ds:[bx]
		inc bx
		add al,ah
		push ax
		;将存储下来的数据依此写入CMOS RAM
		pop ax
		out 71h,al
		pop ax
		out 70h,al

		cmp al,7
		je equal
		ja above
		jl less

		equal:
		sub al,3
		jmp endset
		above:
		sub al,1
		jmp endset
		less:
		sub al,2
		jmp endset

		endset:
		pop cx
		loop setRAM



	pop ds
	pop dx
	pop cx
	pop bx
	pop ax
	ret


		

		

	; ok:
	; 	mov ax,4c00h
	; 	int 21h


code ends

end start









