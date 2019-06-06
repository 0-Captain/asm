;这是一个显示日期的程序
assume cs:codesg

data segment
	db 0dh dup (0)
data ends

codesg segment
	start:
		mov ax,data
		mov ds,ax

		mov ax,0b800h
		mov es,ax
		mov di,5*160+20

		; mov cx,0
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

		;检测键盘是否有输入
		in al,60h
		cmp al,3bh
		je pf1
		cmp al,01h
		je pesc
		jmp next

		pf1:
		push cx
		mov cx,0ffffh
		yanshi:
		push cx
		mov cx,05h
		yanshi2:
		loop yanshi2
		pop cx
		loop yanshi

		pop cx
		call subf1
		jmp next

		pesc:
		call subesc
		jmp next

		next:
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
		jmp loop0

		over:
		mov ax,4c00h
		int 21h

;按下esc返回到主菜单
subesc:
; push ax


; mov ah,0
; int 16h

; pop ax
jmp over

;按下f1改变显示的颜色，第6行
subf1:
	push ax
	push bx
	push es
	push cx

	mov ax,0b800h
	mov es,ax
	mov bx,160*5+1
	mov al,es:[bx];先拿到原来的颜色，是07说明现在是白色，切换为绿色，如果是绿色就切换为白色. 111--100

	cmp al,7
	je lv
	jl bai
	jmp subf1ok

	lv:
	mov al,2
	jmp subf1ok

	bai:
	mov al,7
	jmp subf1ok
	
	subf1ok:
	mov cx,80*1
	subf1s:
	mov es:[bx],al
	add bx,2
	loop subf1s

	pop cx
	pop es
	pop bx
	pop ax
ret



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
	mov byte ptr es:[di],cl
	add di,2
	mov byte ptr es:[di],al
	add di,2

	pop cx
	ret

codesg ends

end start