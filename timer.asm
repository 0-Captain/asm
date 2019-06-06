assume cs:codesg

codesg segment
	start:
		mov ax,0b800h
		mov es,ax
		mov di,5*160+30
		mov dx,0200h ;dx存放要往现存放的数据

		mov cx,6
		mov bx,0ffh ;bl存放当前秒
	time:
		mov ax,0
		out 70h,al
		in al,71h

		;判断是否为第一次
		cmp cx,6
		je initial

		cmp bl,al
		je time
		mov bl,al
		mov dl,cl
		add dl,30h
		mov es:[di],dx
		loop time

		mov ax,4c00h
		int 21h

		initial:
			mov bx,ax
			dec cx
			jmp short time

codesg ends

end start