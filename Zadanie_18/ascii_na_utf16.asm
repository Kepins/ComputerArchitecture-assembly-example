.686
.model flat

extern _malloc : PROC

public _ASCII_na_UTF16


.code

_ASCII_na_UTF16 PROC
	push ebp
	mov ebp, esp
	push ebx
	push esi
	push edi
	
	mov esi, [ebp+8]
	mov eax, ecx
	inc eax
	shl eax, 1
	push eax
	call _malloc
	add esp, 4
	mov edi, eax
	mov edx, edi
	mov ecx, [ebp+12]
ptl:
	xor ax, ax
	mov al, [esi]
	mov [edi], ax
	inc esi
	add edi, 2
loop ptl
	xor ax, ax
	mov [edi], ax
	mov eax, edx
	pop edi
	pop esi
	pop ebx
	pop ebp


	ret
_ASCII_na_UTF16 ENDP
END