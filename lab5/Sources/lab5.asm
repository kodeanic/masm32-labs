.386
.model flat, stdcall
option casemap :none
	include D:\masm32\include\user32.inc
	include D:\masm32\include\kernel32.inc
	includelib D:\masm32\lib\user32.lib
	includelib D:\masm32\lib\kernel32.lib
	
BSIZE equ 256

.data
	buffer_key_1 db BSIZE dup(?)
	buf byte 2 dup(0)
	ifmt db "%d", 0
	enterNumb byte "Enter number: "
	nextLine byte 13, 10
	space db " ", 0
	
	stdout dd ?
	stdin dd ?
	nRead dd ?
	nWritten dd ?
	input byte ?
	output byte ?
	temp byte ?
	
	answ1 byte ?
	answ2 byte ?
	
	n db 8
	i db 2
	
.code
	start:
		invoke GetStdHandle, -10
		mov stdin, eax
		invoke GetStdHandle, -11
		mov stdout, eax
		
		mov eax, 0
		
		Return:
			
		invoke WriteConsoleA, stdout, ADDR enterNumb, SIZEOF enterNumb, ADDR nWritten, 0
		
		Input:
		
		invoke ReadConsoleInput, stdin, ADDR buffer_key_1, BSIZE, ADDR nRead
		cmp [buffer_key_1+04d], 1h
			jne Input
		cmp [buffer_key_1+14d], 0Dh
			je InputEnd
		cmp [buffer_key_1+14d], 0
			je Input
			
		cmp [buffer_key_1+14d], 30h
			jl Input
		cmp [buffer_key_1+14d], 31h
			jg Input
		
		mov al, input
		shl al, 1
		mov input, al
		mov eax, 0
		mov al, [buffer_key_1+14d]
		sub al, 30h
		add input, al
		
		invoke wsprintf, ADDR buf, ADDR ifmt, al
		invoke WriteConsoleA, stdout, ADDR buf, 1, ADDR nWritten, 0
		
		dec n
		cmp n, 0
			je InputEnd
		jmp Input
		
		InputEnd:
			
		invoke WriteConsoleA, stdout, ADDR nextLine, SIZEOF nextLine, ADDR nWritten, 0
		
		cmp answ1, 0
			jne ElsePart
		mov al, input
		mov answ1, al
			jmp Exit
		ElsePart:
			mov al, input
			mov answ2, al
		Exit:
		mov n, 8
		dec i
		cmp i, 0
			je ReturnEnd
		jmp Return
		
		ReturnEnd:
		
		mov n, 8
		mov al, answ1
		mov temp, al
		mov i, 2
		
		Output:
			shl temp, 1
				jc Add1
			mov output, '0'
				jmp Print0
			Add1:
				mov output, '1'
			
			Print0:
				invoke WriteConsoleA, stdout, ADDR output, SIZEOF output, ADDR nWritten, 0
			
			dec n
			cmp n, 0
				je EndOutput
			jmp Output
		
		EndOutput:
		
		invoke WriteConsoleA, stdout, ADDR space, SIZEOF space, ADDR nWritten, 0
		
		mov n, 8
		mov al, answ2
		mov temp, al
		
		dec i
		cmp i, 0
			je OutputExit
		jmp Output
		
		OutputExit:
			
		invoke WriteConsoleA, stdout, ADDR nextLine, SIZEOF nextLine, ADDR nWritten, 0
		
		mov al, answ1
		shl al, 2
		mov answ1, al
		
		mov al, answ2
		shr al, 1
		mov answ2, al
		
		mov n, 8
		mov al, answ1
		mov temp, al
		mov i, 2
		
		Output_2:
			shl temp, 1
				jc Add1_2
			mov output, '0'
				jmp Print0_2
			Add1_2:
				mov output, '1'
			
			Print0_2:
				invoke WriteConsoleA, stdout, ADDR output, SIZEOF output, ADDR nWritten, 0
			
			dec n
			cmp n, 0
				je EndOutput_2
			jmp Output_2
		
		EndOutput_2:
		
		invoke WriteConsoleA, stdout, ADDR space, SIZEOF space, ADDR nWritten, 0
		
		mov n, 8
		mov al, answ2
		mov temp, al
		
		dec i
		cmp i, 0
			je OutputExit_2
		jmp Output_2
		
		OutputExit_2:
			
		invoke WriteConsoleA, stdout, ADDR nextLine, SIZEOF nextLine, ADDR nWritten, 0
		
		mov al, answ1
		mov bl, answ2	
		or al, bl
		
		mov answ1, al
		
		mov n, 8
		mov al, answ1
		mov temp, al
		mov i, 2
		
		Output_3:
			shl temp, 1
				jc Add1_3
			mov output, '0'
				jmp Print0_3
			Add1_3:
				mov output, '1'
			
			Print0_3:
				invoke WriteConsoleA, stdout, ADDR output, SIZEOF output, ADDR nWritten, 0
			
			dec n
			cmp n, 0
				je EndOutput_3
			jmp Output_3
		
		EndOutput_3:
		
		invoke WriteConsoleA, stdout, ADDR nextLine, SIZEOF nextLine, ADDR nWritten, 0
		
		mov al, answ1
		
		mov bl, answ1
		and bl, 01000000b
		mov cl, answ1
		and cl, 00000001b
		
		shr bl, 6
		shl cl, 6
		
		and al, 10111110b
		or al, bl
		or al, cl
		
		mov temp, al
		mov answ1, al
		mov n, 8
		dec i
		cmp i, 0
			je OutputExit_3
		jmp Output_3
		
		OutputExit_3:
		
        invoke ExitProcess, 0
	end start
