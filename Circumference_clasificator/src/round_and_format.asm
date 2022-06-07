TITLE Redondear y organizar los datos.

; Este módulo contiene las funciones necesarias para redondear y mostrar en la pantalla.


INCLUDE Irvine32.inc


; DEFINIR CONSTANTES

NUM_OF_DECIMAL_PLACES = 3 ; Hacer este número igual al número de 0s de la constante de abajo (CTE)
SIZE_OF_MANTISSA = 23
SIZE_OF_EXP_AND_SIGN = 9
CTE = 1000		      ; Número de ceros = número de cifras decimales a redondear.
; ----------------------------------------------------------------------------------------------------------------------------------


.data

ZEROES_ARRAY BYTE 0 DUP(32)
NO_STRING BYTE 0


.code

WriteRoundFloat PROC
	LOCAL INTEGER_PART : DWORD, EXPONENT : BYTE, DECIMAL : DWORD, TempInt : DWORD, ZEROES: BYTE, IS_NEG: BYTE

	mov IS_NEG, 0
	fst TempInt
	test TempInt, 80000000h               ; usa la bandera 0 para reconocer si el número es negativo
	jz exit_neg						
	
	n_is_neg:
		mov IS_NEG, 1

	exit_neg:
	
	mov ZEROES, 0

	push TempInt

	mov cl, 1

	shl TempInt, cl

	shr TempInt, cl

	mov cl, SIZE_OF_MANTISSA						; Correr el número 23 espacios hacia la derecha, lo que es
											; efectivamente, remover la mantissa y dejar el exponente.

	shr TempInt, cl

	mov eax, 0
	mov al, BYTE PTR TempInt			; Mover a AL el exponente.


	sub al, 127
	mov EXPONENT, al				; Restarle el bias o exceso (127, en este caso) y guardarlo.


	pop TempInt

	push TempInt
	shl TempInt, SIZE_OF_EXP_AND_SIGN  ; Quedarse solo con la mantisa, corriendo el número hacia la izquierda
	shr TempInt, SIZE_OF_EXP_AND_SIGN	; y luego hacia la derecha, eliminando los bits corridos.


	OR TempInt, 00800000h			; Agregar el bit implícito del formato IEEE.


	mov cl, SIZE_OF_MANTISSA		
	sub cl, EXPONENT

	cmp cl, 32
	jae excess
	jmp not_excess

	excess:
		mov TempInt, 0
		jmp exit_1


	not_excess :
		shr TempInt, cl                      ; Correr la mantissa (23-EXPONENTE), para quedarse con la parte entera.


	exit_1:
		mov eax, TempInt

		mov INTEGER_PART, eax			  ; Guardar la parte entera.

		pop TempInt


		cmp IS_NEG, 1
		jne not_reverse

		fld TempInt
		fild INTEGER_PART
		faddp st(1), st(0)
		jmp exit_rev

		not_reverse:
		

		fld TempInt
		fild INTEGER_PART

		fsubp st(1), st(0)

		exit_rev:

		fst TempInt
		mov ebx, TempInt

		mov TempInt, 10
		fild TempInt


		mov esi, 0
	Zeroes_loop:
		fmulp st(1), st(0)

		fst TempInt

		push TempInt

		shr TempInt, SIZE_OF_MANTISSA
		mov al, BYTE PTR TempInt
		mov EXPONENT, al

		sub EXPONENT, 127

		pop TempInt

		shl TempInt, SIZE_OF_EXP_AND_SIGN
		shr TempInt, SIZE_OF_EXP_AND_SIGN

		OR TempInt, 00800000h

		mov cl, SIZE_OF_MANTISSA
		sub cl, EXPONENT

		cmp cl, 32
		jae excess_loop
		jmp not_excess_loop



	excess_loop:
		mov TempInt, 0
		jmp exit_1_loop

	not_excess_loop:
		shr TempInt, cl


	exit_1_loop:
		mov eax, TempInt
		cmp eax, 0

		jne Not_zero

		mov ZEROES_ARRAY[esi], "0"

		inc esi

		cmp esi, NUM_OF_DECIMAL_PLACES
		je Not_zero

		mov TempInt, 10
		fild TempInt

		jmp Zeroes_loop


	Not_zero:


		mov TempInt, ebx
		fld TempInt

		mov TempInt, CTE
		fild TempInt

		fmulp st(1), st(0)
		fst TempInt

		push TempInt
		mov cl, SIZE_OF_MANTISSA			; Correr el número 23 espacios hacia la derecha, lo que es
									; efectivamente, remover la mantissa y dejar el exponente.
		shr TempInt, cl

		mov eax, 0
		mov al, BYTE PTR TempInt			; Mover a AL el exponente.

		sub al, 127
		mov EXPONENT, al				; Restarle el bias o exceso(127, en este caso) y guardarlo.

		pop TempInt


		shl TempInt, SIZE_OF_EXP_AND_SIGN	; Quedarse solo con la mantisa, corriendo el número hacia la izquierda
		shr TempInt, SIZE_OF_EXP_AND_SIGN	; y luego hacia la derecha, eliminando los bits corridos.

		OR TempInt, 00800000h			; Agregar el bit implícito del formato IEEE.

		mov cl, SIZE_OF_MANTISSA
		sub cl, EXPONENT
		cmp cl, 32
		jae excess_3
		jmp not_excess_3

	excess_3:
		mov TempInt, 0
		jmp exit_3

	not_excess_3:
		shr TempInt, cl				; Correr la mantissa(23 - EXPONENTE), para quedarse con la parte entera.

	exit_3:
		mov eax, TempInt

		mov DECIMAL, eax
		cmp IS_NEG, 1
		jne not_neg

		mov al, '-'
		call WriteChar

		not_neg:

		mov eax, INTEGER_PART
		call WriteDec

		mov al, "."
		call WriteChar

		mov eax, DECIMAL

		cmp esi, 0
		je no_zeroes
		mov edx, OFFSET ZEROES_ARRAY
		call WriteString
		no_zeroes:
		mov edx, OFFSET NO_STRING
		call WriteDec

		fstp st(0)
		fstp st(0)
		fstp st(0) 
; Limpiar lo que queda en el stack de la FPU.


ret
WriteRoundFloat ENDP
END
