.8086
assume cs:codesg

data segment
	db "hello word"
data ends

codesg segment
	start:
	mov dh,13
	mov dl,30
	mov cl,02h

	mov ax,data
	mov ds,ax
	mov si,0
	call show_str

	mov ax,4c00h
	int 21h
	
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
	pop dx
	pop cx
	pop di
	pop ax
	pop bx
	ret

codesg ends
end start