

.686
.model flat

public _avg_wd


.code

_avg_wd PROC
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx

	xor ebx, ebx
	finit
	mov esi, [ebp+12]
	mov edi, [ebp+16]
	mov ecx, [ebp+8]
	fld1
	fld1
	fsubp
ptl:
	fld dword PTR [esi+4*ebx]
	fld dword PTR [edi+4*ebx]
	fmulp
	faddp
	inc ebx
	cmp ebx, ecx
	jne ptl
	xor ebx, ebx
	fld1
	fld1
	fsubp
ptl2:
	fld dword PTR [edi + 4* ebx]
	faddp
	inc ebx
	cmp ebx, ecx
	jne ptl2
	fdivp st(1), st(0)

	pop ebx
	pop edi
	pop esi
	pop ebp
	ret
_avg_wd ENDP

END