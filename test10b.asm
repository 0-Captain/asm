.8086
assume cs:codesg

codesg segment
	start:
		mov ax,4240h
		mov dx,000fh
		mov cx,10
		call divdw

		mov ax,4c00h
		int 21h

	divdw:
		push bx
		push ax
		;栈结构为：[bx->ax]

		mov ax,dx
		mov dx,0
		div cx 		;ax=int(H/N),dx=rem(N/N)
		pop bx		;bx为被除数的低16位. [bx]
		push ax		;[bx->ax=int(H/N)]
		mov ax,bx	;上一次相处的余数在dx正好位于高16位，此时将被除数的低16位移到ax为下一步div作准备
		div cx		;结果低16位在ax
		mov cx,dx	;放余数到cx
		pop dx		;高16位放在dx 	[bx]

		pop bx
		ret
codesg ends

end start