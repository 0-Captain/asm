;func:	进行不会溢出的除法运算，被除数为dword，除数为word,结果为dword
;解释：	X/N = int(H/N)*2^16 + [rem(H/N)*2^16+L]/N （其中H为被除数高16位，L为低16位；N为除数；int为商，rem为余数）

;参数: 	ax：被除数的低16位，	dx：被除数的高16位，	cx：除数
;返回：	ax：结果的低16位，	dx：结果的高16位，	cx：余数
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