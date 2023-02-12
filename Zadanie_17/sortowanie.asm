.686
.model flat

public _sortowanie



.code

_sortowanie PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx

	mov ecx, [ebp+12]
	mov esi, [ebp+8]
	
	mov edi, 0
	mov eax, [esi]
	mov edx, [esi+4]

	mov ebx, 1

	cmp ecx, 1
	je koniec

ptl:
	cmp eax, [esi+8*ebx]
	jb nowa_wieksza
	ja nowa_mniejsza
	cmp edx, [esi+8*ebx+4]
	jae nowa_mniejsza
nowa_wieksza:
	mov eax, [esi+8*ebx]
	mov edx, [esi+8*ebx+4]
	mov edi, ebx
nowa_mniejsza:
	inc ebx
	cmp ebx, ecx
	jne ptl

	push eax
	push edx
	dec ebx
	mov eax, [esi+8*ebx]
	mov edx, [esi+8*ebx+4]
	mov [esi+8*edi], eax
	mov [esi+8*edi+4], edx
	pop dword PTR [esi+8*ebx+4]
	pop dword PTR [esi+8*ebx]
	push ebx
	push esi
	call _sortowanie
	add esp, 8
	mov eax, [esi+8*ebx]
	mov edx, [esi+8*ebx+4]
koniec:
	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
	
_sortowanie ENDP
END