assume cs:code,ds:data

data segment
	data1 db 32h,39h,33h,35h,34h
	data2 db 33h
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

	mov cx,5
	mov si,offset data1
	call show
	add di,168

	mov cx,1
	mov si,offset data2
	call show
	add di,152


	;ah放结果，bh放进位
	mov dl,data2[0]
	sub dl,30h
	mov cx,5
	s1:
	mov si,cx
	dec si
	mov al,data1[si]
	sub al,30h
	mul dl
	;此时al为一位相乘的结果
	mov bl,10
	div bl
	;先加上一次的进位
	add ah,bh
	;设置这一次的进位
	mov bh,al

	cmp ah,10
	jnb jinwei
	jmp ok

	jinwei:
	inc bh
	sub ah,10

	ok:
	add ah,30h
	mov data1[si],ah
	inc si
	loop s1

	mov cx,5
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