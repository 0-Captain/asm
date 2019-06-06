;大小写互换

code segment
start:	mov ax,data
	mov ds,ax
      	mov bx,0

      	mov cx,26
        ;大写字母从41h开始，小写从61h开始
        ;将一个字母的ascii码加上20h，分两种情况：
        ;1. 如果为大写字母，此时变为小写
        ;2. 如果为小写字母，61h+20h=81h(1000 0001)，此时将其第一位置0，第二位置1，即可转变为大写
        ;由此发现：大小写字母可以理解为0xx xxxxx，从前往后其第一位永远为0，第二三位代表大小写，10为大写，11为小写，后五位代表字母是哪个。
s:    	add byte ptr [bx],00100000b	;将需要修改字母的ASCII码加上20h
      	and byte ptr [bx],01111111b	;将相加后的数值最高位 置为0
      	or byte ptr [bx],01000000b	;将相加后的数值次高位 置为1
	;这三句指令比较有技巧，注意理解。
     	inc bx
     	loop s

        mov ax,4c00h
        int 21h

code ends
end start