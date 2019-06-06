assume cs:code,ds:data

data segment
	data1 db 30h,33h,39h,31h,37h,34h
	data2 db 30h,36h,35h,30h,38h,32h
data ends

code segment
start:
	mov ax,data
	mov ds,ax

	;获取行号和列号分别保存在dh，dl中
	mov bh,0
	mov ah,3
	int 10h
	;设置es:di
	add dh,2
	mov ax,0b800h
	mov es,ax
	mov al,160
	mul dh
	mov di,ax

	add di,2
	mov cx,5
	mov si,offset data1
	inc si
	call show
	add di,160

	mov cx,5
	mov si,offset data2
	inc si
	call show
	add di,158


	mov cx,5

	;bl当作进位
	mov bx,0
	mov cx,6
	s1:
	mov si,cx
	dec si
	mov al,data1[si]
	mov ah,data2[si]
	sub ax,3030h
	add al,ah
	add al,bl
	mov bl,0
	cmp al,10
	jnb jinwei
	jmp ok

	jinwei:
	mov bl,1
	sub al,10

	ok:
	add al,30h
	mov data1[si],al
	loop s1


	mov cx,6
	mov si,offset data1
	call show

	mov ax,4c00h
	int 21h

	;将ds：si设置为数据地址，cx为要显示的个数,es:di
	show:
	push cx
	push si
	push di
	push ax

	mov ah,2
	s2:
	mov al,ds:[si]
	mov es:[di],ax
	inc si
	add di,2
	loop s2



	pop ax
	pop di
	pop si
	pop cx
	ret
code ends

end start