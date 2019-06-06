;将1位16进制数转换为其ascii码
;参数: ds:si
;返回: ds:si
trans16:
	add byte ptr ds:[si],30h
	cmp byte ptr ds:[si],39h
	ja s1 	;如果比39h大说明是a～f之间的数字，应该再加7
	jmp ok
	s1:
		add byte ptr ds:[si],7
	ok:
	ret