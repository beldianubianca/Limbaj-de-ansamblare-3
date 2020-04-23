
;8. Dându-se un octet mod si două siruri s1 si s2 (având aceeasi lungime n), să se construiască sirul s3 în felul următor:
;- daca mod apartine [00h,0Fh] atunci s3[i]:=s1[i]+s2[i] (i=1,n)
;- daca mod apartine [10h,1fh] atunci s3[i]:=abs(s1[i]-s2[i])
;- daca mod apartine [20h,2fh] atunci s3:=s1+s2 (+ reprezintă concatenarea)
;- daca mod apartine [30h,3fh] atunci s3[i]:=s1[i]+s2[n-i]
;- daca mod apartine [40h,4Fh] atunci s3:=~s1+~s2 (unde ~ reprezintă sirul parcurs în ordine inversă)
;- altfel s3:=s1.

ASSUME cs:text_,ds:data_
data_ SEGMENT
s1 db 2,3,4,5,6
n EQU ($-s1)
p EQU ($-s1)*2
s2 db 4,5,8,10,11

s3 db p dup(?)
mod db 37h
data_ ENDS

text_ SEGMENT

start:
mov ax, data_
mov ds, ax
; Evaluarea propriu-zisa a expresiei
mov cx,n
sub cx,1
mov si,0
mov bp,0
mov bl,mod
cmp bl,00h
jge compara 
altfel:			;s3:=s1
	mov al,s1[si]
	mov s3[si],al
	add si,1
	cmp si,cx
	jle altfel
	jmp gata
compara:
	cmp bl,0Fh
	jle adauga
	cmp bl,10h
	jge compara2
adauga:					;s3[i]:=s1[i]+s2[i]
	mov al,s1[si]		
	mov ah,s2[si]
	add al,ah
	mov s3[si],al
	add si,1
	cmp si,cx
	jle adauga
	jmp gata
compara2:
	cmp bl,1fh
	jle adauga2
	cmp bl,20h
	jge compara3
adauga2:				;s3[i]:=s1[i]-s2[i]
	mov al,s1[si]
	mov ah,s2[si]
	sub al,ah
	mov s3[si],al
	add si,1
	cmp si,cx
	jle adauga2
	jmp gata
compara3:
	cmp bl,2fh
	jle adauga3
	cmp bl,30h
	jge compara4
adauga3:				;s3:=s1+s2 (concatenarea)
	punes1:
		mov al,s1[si]
		mov s3[bp],al
		add si,1
		add bp,1
		cmp si,cx
		jle punes1
	mov si,0
	punes2:
		mov al,s2[si]
		mov s3[bp],al
		add si,1
		add bp,1
		cmp si,cx
		jle punes2
	jmp gata
compara4:
	cmp bl,3fh
	jle adauga4
	cmp bl,40h
	jge compara5
adauga4:					;s3[i]:=s1[i]+s2[n-i]
	mov di,n
	sub di,1
	sub di,si
	repeta:
		mov al,s1[si]
		mov ah,s2[di]
		add al,ah
		mov s3[si],al
		add si,1
		sub di,1
		cmp si,cx
		jle repeta
		jmp gata
compara5:
	cmp bl,4Fh
	jle adauga5
	cmp bl,4Fh
	jg altfel2
adauga5:					;s3:=~s1+~s2 (unde ~ reprezintă sirul parcurs în ordine inversă)
	mov di,n
	sub di,1
	punesir1:
		mov al,s1[di]
		mov s3[bp],al
		add bp,1
		sub di,1
		cmp bp,cx
		jle punesir1
	mov di,n
	sub di,1
	punesir2:
		mov al,s2[di]
		mov s3[bp],al
		add bp,1
		sub di,1
		cmp di,-1
		jne punesir2
	jmp gata
altfel2:					;s3:=s1
	mov al,s1[si]
	mov s3[si],al
	add si,1
	cmp si,cx
	jle altfel2
	jmp gata
	
gata:

; Terminarea programului
mov ax, 4c00h
int 21h
text_ ENDS

END start