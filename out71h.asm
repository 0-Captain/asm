assume cs:code

code segment

start:
	mov al,9
	out 70h,al
	mov al,11
	out 71h,al


	mov al,9
	out 70h,al
	in al,71h

code ends

end start