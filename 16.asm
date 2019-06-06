;安装中断程序三部曲：
;1. 安装中断向量
;2. 将程序复制到内存固定位置，如0:200h
;3. 完成程序功能
assume cs:codesg

codesg segment
	int7c:
		jmp short set
		table dw sub1+200h,sub2+200h,sub3+200h,sub4
		set:
			push bx
			push ds

			mov bx,20h
			mov ds,bx

			cmp ah,3
			ja return
			mov bl,ah
			mov bh,0
			add bl,bl

			mov bx,word ptr table[bx]
			add bx,200h
			call bx
	return:	
		pop ds
		pop bx
		iret

		;清屏
		sub1:
			push bx
			push cx
			push es

			mov bx,0b800h
			mov es,bx
			mov bx,0
			mov cx,2000
			sub1s:
			mov byte ptr es:[bx],' '
			add bx,2
			loop sub1s

			pop es
			pop cx
			pop bx
		ret

		; 设置前景色
		sub2:
			push bx
			push cx
			push es

			mov bx,0b800h
			mov es,bx
			mov bx,1
			mov cx,2000
			sub2s:
			and byte ptr es:[bx],11111000b
			or es:[bx],al
			add bx,2
			loop sub2s

			pop es
			pop cx
			pop bx
		ret

		; 设置背景色
		sub3:
			push bx
			push cx
			push es

			mov cl,4
			shl al,cl
			mov bx,0b800h
			mov es,bx
			mov bx,1
			mov cx,2000
			sub3s:
			and byte ptr es:[bx],10001111b
			or es:[bx],al
			add bx,2
			loop sub3s

			pop es
			pop cx
			pop bx
		ret

		; 向上滚动一行
		sub4:
			push cx
			push si
			push di
			push es
			push ds

			mov si,0b800h
			mov es,si
			mov ds,si
			mov si,160
			mov di,0
			cld
			mov cx,24

			sub4s:
			push cx
			mov cx,160
			rep movsb
			pop cx
			loop sub4s

			mov cx,80
			mov si,0
			sub4s1:
			mov byte ptr [160*24+si],' '
			add si,2
			loop sub4s1

			pop ds
			pop es
			pop di
			pop si
			pop cx
		ret
	int7cEnd:
		nop

	start:
		mov ax,cs
		mov ds,ax
		mov si,offset int7c
		mov ax,0
		mov es,ax
		mov di,200h

		mov word ptr es:[7ch*4],200h
		mov word ptr es:[7ch*4+2],0

		mov cx,offset int7cEnd - offset int7c
		cld
		rep movsb

		mov ax,4c00h
		int 21h

codesg ends

end start