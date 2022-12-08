.386
.model flat, stdcall
option casemap: none
	include D:\masm32\include\windows.inc
	include D:\masm32\include\masm32.inc
	include D:\masm32\include\kernel32.inc

	includelib D:\masm32\lib\masm32.lib
	includelib D:\masm32\lib\kernel32.lib

.data
    inputFile db "D:\Asm\lab6\input.txt", 0
    outputFile db "D:\Asm\lab6\output.txt", 0
	
	filein dword ?
	fileout dword ?
	nRead dd ?
	nWrite dd ?
	
	fileBuffer db 2048 dup(0)
	lineBuffer db 128 dup(0)
	resultLineBuffer db 128 dup(0)
	numbOfLine db " ) "
	
	endOfFile dd ?
	codeOfChar byte ?
	temp dd ?
	buffIndex dword 0
	countOfString byte 0
	lengthOfString dword 0
	numberWord dd ?
	counter dd ?
	
.code
    start:
		invoke CreateFileA, ADDR inputFile, GENERIC_READ, 0, 0, OPEN_EXISTING, 0, 0
		mov filein, eax
		
		invoke CreateFileA, ADDR outputFile, GENERIC_WRITE, 0, 0, OPEN_ALWAYS, 0, 0
		mov fileout, eax

		invoke ReadFile, filein, ADDR fileBuffer, sizeof fileBuffer, ADDR nRead, 0
		
		invoke GetFileSizeEx, filein, ADDR nRead
		mov eax, nRead
		mov endOfFile, eax


		processString:
			cmp buffIndex, 0
				je skip
			inc buffIndex
			skip:

			mov numberWord, 0
			mov lengthOfString, 0
			inc countOfString
			mov dl, countOfString
			add dl, 30h
			
			mov [numbOfLine], dl
			
			cld
			mov esi, offset numbOfLine
			mov edi, offset resultLineBuffer
			mov ecx, 3
			rep movsb

			add lengthOfString, 3
			
			cmp buffIndex, 0
				je skip_2
			inc buffIndex
			skip_2:
			
			mov edx, buffIndex
			mov temp, edx
			
			mov esi, offset fileBuffer
			add esi, buffIndex
			add esi, 1
			
			EndLine:
				inc edx
				
				cmp edx, endOfFile
					je finish

				lodsb
				
				mov codeOfChar, al
				
				cmp codeOfChar, 20h
					jne jump
					add numberWord, 1
				jump:
				
				cmp codeOfChar, 0Dh
					jne EndLine
			
			sub edx, 1
			mov buffIndex, edx
			mov ebx, 1
			
			std
			mov esi, offset fileBuffer
			add esi, buffIndex
			
			ReverseLine:
				lodsb
				
				mov [lineBuffer + ebx], al
				inc ebx
				dec edx
				
				cmp edx, temp
					jge ReverseLine
			mov [lineBuffer + ebx], 0Dh
			
			inc ebx
			
			std
			mov esi, offset lineBuffer
			add esi, ebx
			mov al, 0h
			
			setNull:
				lodsb
				
				inc ebx
				cmp ebx, 128
					jne setNull
					
			mov ebx, 1
			mov counter, 0
			
			Print:
				mov temp, ebx
				
				mov edx, counter
				cmp edx, numberWord
					jg PrintExit
				
				cld
				mov esi, offset lineBuffer
				add esi, ebx
				add esi, 1
				
				CycleOne:
					inc ebx
					
					lodsb
					mov codeOfChar, al
					
					cmp codeOfChar, 0Dh
						je exit
					cmp codeOfChar, 20h
						jne CycleOne
					
					exit:
				
				mov ecx, ebx
				inc ecx
				dec ebx
				
				mov edx, lengthOfString
				
				std
				mov esi, offset lineBuffer
				add esi, ebx
				
				CycleTwo:
					lodsb
					mov [resultLineBuffer + edx], al
					inc edx
					dec ebx
					
					cmp al, 0Dh
						je finish
					
					inc lengthOfString
					
					cmp ebx, temp
					jge CycleTwo
				
				inc lengthOfString
				mov [resultLineBuffer + edx], 20h
				inc counter
				mov ebx, ecx
				jmp Print
				
			PrintExit:

			mov ebx, lengthOfString
			mov [resultLineBuffer + ebx], 10d
			inc lengthOfString
			finish:
				inc buffIndex
				
			invoke WriteFile, fileout, ADDR resultLineBuffer, lengthOfString, ADDR nWrite, 0
			
			mov eax, buffIndex
			cmp eax, endOfFile
				jne processString
	
		invoke ExitProcess, 0
    end start