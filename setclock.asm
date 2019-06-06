assume cs:code

code segment
start:
setclock0:
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
		;将存储下来的数据依此写入CMOS RAM
		; mov cl,al
		; pop ax
		; out 70h,al
		; mov al,cl
		; out 71h,al
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

code ends

end start