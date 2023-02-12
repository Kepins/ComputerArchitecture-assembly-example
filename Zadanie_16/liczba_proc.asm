.686
.model flat

extern _GetSystemInfo@4 : PROC

public _liczba_procesorow

.data

buffer db 34

.code


_liczba_procesorow PROC
	mov ecx, offset buffer
	push ecx
	call _GetSystemInfo@4
	mov ecx, offset buffer
	add ecx, 20
	mov eax, dword ptr [ecx]

	ret
_liczba_procesorow ENDP
END