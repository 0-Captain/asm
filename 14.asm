;这是一个显示日期的程序
assume cs:codesg

data segment
	db 0dh dup (0)
data ends

codesg segment
	start:
		mov ax,data
		mov ds,ax
		mov bx,0
		;取出cmos ram中的数据放在内存中
		mov cx,0dh
		mov al,0
	loop1:
		push ax
		out 70h,al
		in al,71h
		mov [bx],al
		inc bx
		pop ax
		inc al
		loop loop1

		mov si,0
		mov dx,2
		;此时把时间数据放在了ds:[0]开始的位置
		mov ax,0b800h
		mov es,ax
		mov di,5*160+30

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


		; mov al,ds:[si+9]
		; call bcdToAscii
		; call show
		; mov word ptr es:[di],062fh
		; add di,2

		; mov al,ds:[si+8]
		; call bcdToAscii
		; call show
		; mov word ptr es:[di],062fh
		; add di,2

		; mov al,ds:[si+7]
		; call bcdToAscii
		; call show
		; mov word ptr es:[di],0600h
		; add di,2

		; mov al,ds:[si+4]
		; call bcdToAscii
		; call show
		; mov word ptr es:[di],063ah
		; add di,2

		; mov al,ds:[si+2]
		; call bcdToAscii
		; call show
		; mov word ptr es:[di],063ah
		; add di,2

		; mov al,ds:[si+0]
		; call bcdToAscii
		; call show
		; add di,2

		;循环


		mov ax,4c00h
		int 21h


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

codesg ends

end start