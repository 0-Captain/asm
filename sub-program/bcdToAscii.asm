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