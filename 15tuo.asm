;修改int 9中断。
;1.保存原来的9号中断向量在200h～204h，更新中断向量为0:200h	
;2.安装中断程序在204
;3.写中断程序：当检测到60h端口中有A的断码时，将满屏幕铺满A,按esc时卸载此功能
assume cs:codesg

codesg segment
	start:
		mov ax,0
		mov es,ax
		mov di,200h
		;1.1
		push es:[9*4+2]
		push es:[9*4]
		pop es:[di]
		pop es:[di+2]
		;1.2
		cli
		mov word ptr es:[9*4],204h
		mov word ptr es:[9*4+2],0			
		sti
		;2
		push cs
		pop ds
		mov si,offset int9
		add di,4
		mov cx,offset int9end - offset int9
		cld
		rep movsb

		mov ax,4c00h
		int 21h

	int9:
		push ax
		push es
		push di
		push cx

		;recover bios int9
		int 80h

		in al,60h
		cmp al,9eh
		je showA
		jmp xiezai
	showA:
		mov ax,0b800h
		mov es,ax
		mov di,0
		mov ax,0641h
		mov cx,2000
		s1:
		mov es:[di],ax
		add di,2
		loop s1
		jmp ok
	xiezai:
		cmp al,01h
		je x
		jmp ok
	x:	
		mov ax,0
		mov es,ax
		push es:[202h]
		push es:[200h]
		pop es:[9*4]
		pop es:[9*4+2]
	ok:
		pop cx
		pop di
		pop es
		pop ax
		iret
	int9end:
		nop

codesg ends

end start