.686
.model flat


extern _ExitProcess@4 : PROC
extern _MessageBoxW@16 : PROC


public _main

.data
tekst dw 'a', 'b', 'c', 'd', 0h

naglowek dw 'n', 'a', 'g', 142h , 'o', 'w', 'e', 'k', 0h


tekst_utf8 db 53h, 69h, 65h, 6dh, 61h, 2ch, 20h, 0e2h, 82h, 0ach
 db 20h, 6dh, 61h, 6dh, 20h, 64h, 0c5h, 82h, 75h, 67h
 db 69h, 20h, 74h, 65h, 6bh, 73h, 74h, 20h, 0F0h, 90h, 80h, 80h, 20h
 db 69h, 20h, 6dh, 61h, 20h, 62h, 79h, 0c4h
 db 87h, 20h, 77h, 20h, 55h, 54h, 46h, 2dh
 db 31h, 36h, 0h

 dlug = $ - tekst_utf8
 

 tekst_utf16 dw 2*dlug dup(?)
 

.code

_main PROC

xor esi, esi ; set esi to 0
xor edi, edi ; set edi to 0

ptl_gl:
 mov al, tekst_utf8[esi]
 cmp al, 0
 je koniec_ptl_gl ; jmp if there is '\0'

 bt eax, 7
 jc bit_7_set
 ; al: 0xxx xxxx

 mov byte PTR tekst_utf16[edi], al
 mov byte PTR tekst_utf16[edi+1], 0
 add edi, 2

 jmp dalej
bit_7_set:	; al: 110x xxxx
 bt eax, 5
 jc bit_5_set

 sub al, 0c0h ; al: 000x xxxx
 mov bl, tekst_utf8[esi+1] ; bl: 10xx xxxx 
 sub bl, 80h ; bl: 00xx xxxx
 mov ah, al
 and ah, 3h ; ah: 0000 00xx
 shl ah, 6 ; ah: xx00 0000
 add bl, ah ; bl: xxxx xxxx
 shr al, 2 ; al: 0000 0xxx
 ; al: 0000 0xxx bl: xxxx xxxx
 ; wynik: 0000 0xxx xxxx xxxx
 mov byte PTR tekst_utf16[edi], bl
 mov byte PTR tekst_utf16[edi+1], al
 add esi, 1
 add edi, 2

 jmp dalej
bit_5_set:	; al: 1110 xxxx
 bt eax, 4
 jc bit_4_set

 mov bl, tekst_utf8[esi+1] ; bl: 10xx xxxx
 mov cl, tekst_utf8[esi+2] ; cl: 10xx xxxx
 sub al, 0e0h ; al: 0000 xxxx
 sub bl, 80h  ; bl: 00xx xxxx
 sub cl, 80h  ; cl: 00xx xxxx
 
 mov bh, bl
 and bh, 3h
 shl bh, 6   ; bh: ab00 0000 where ab are two last bits of bl
 add cl, bh  ; cl: xxxx xxxx
 shr bl, 2   ; bl: 0000 xxxx
 shl al, 4   ; al: xxxx 0000
 add bl, al
 mov byte PTR tekst_utf16[edi], cl
 mov byte PTR tekst_utf16[edi+1], bl
 add esi, 2
 add edi, 2

 jmp dalej
bit_4_set:	; al: 1111 0xxx rest: bl: 10x1  xxxx cl: 10xx xxxx dl: 10xx xxxx
 ; result must be encoded on 32 bits
 ; 1101 10xx xxxx xxxx    1101 11xx xxxx xxxx
 ;    al        bl           cl         dl   

 mov bl, tekst_utf8[esi+1]
 mov cl, tekst_utf8[esi+2]
 mov dl, tekst_utf8[esi+3]

 sub al, 0f0h  ; al: 0000 00xx ;?
 sub bl, 90h   ; bl: 00x0 xxxx
 sub cl, 80h   ; cl: 00xx xxxx
 sub dl, 80h   ; dl: 00xx xxxx

 mov ch, cl
 and ch, 3h ; ch: 0000 00xx
 shl ch, 6
 add dl, ch    ; dl: xxxx xxxx
 shr cl, 2     ; cl: 0000 xxxx

 mov ch, cl
 shr ch, 2     ; ch: 0000 00ab  where ab are bits that must go to bl
 shl bl, 2     ; bl: xxxx xx00
 add bl, ch    ; bl: xxxx xxxx
 and cl, 3h    ; cl: 0000 00xx

 add al, 0d8h  ; al: 1101 10xx
 add cl, 0dch  ; cl: 1101 11xx

 mov byte PTR tekst_utf16[edi], bl
 mov byte PTR tekst_utf16[edi+1], al
 mov byte PTR tekst_utf16[edi+2], dl
 mov byte PTR tekst_utf16[edi+3], cl

 add edi, 4
 add esi, 3

 jmp dalej


dalej:
 inc esi
 jmp ptl_gl
koniec_ptl_gl:
 mov word PTR tekst_utf16[edi], 0h


 push 0
 push OFFSET naglowek
 push OFFSET tekst_utf16
 push 0
 call _MessageBoxW@16 


 push 0
 call _ExitProcess@4
_main ENDP

END