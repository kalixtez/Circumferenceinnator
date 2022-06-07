TITLE Funciones de circunferencias con distinto centro.

; En este m�dulo est�n todas las funciones que clasifican a una circunferencia cuando no comparten centro.


INCLUDE Irvine32.inc

EXTERN EPSILON : REAL4
EXTERN CalculateIntersection@4:PROC

CalculateIntersection EQU <CalculateIntersection@4>

.data
; Mensajes de resultado.
EXTERIORES BYTE "La distancia entre los centros es mayor a la suma de sus radios, por lo tanto", 0Ah, 0Dh,
				"estas circunferencias son exteriores: no comparten ning�n punto.", 0

TANGENTES_EXT BYTE "La distancia entre sus centros es igual a la suma de sus radios,", 0Ah, 0Dh,
				   "y estas circunferencias comparten un punto. Por lo tanto son tangentes exteriormente.", 0

TANGENTES_INT BYTE "La distancia entre sus centros es igual al valor absoluto de la diferencia de sus radios", 0Ah, 0Dh,
					"tienen un punto en com�n y una se encuentra dentro de otra. Por lo tanto son tangentes interiores.", 0

SECANTES BYTE "Estas circunferencias comparten dos puntos distintos y la distancia entre sus centros es", 0Ah, 0Dh,
			"menor a la suma de sus radios, por lo tanto son secantes.", 0

INTERIORES_EXT BYTE "La distancia entre sus centros es mayor que 0 y menor al valor absoluto de la diferencia", 0Ah, 0Dh,
					"de sus radios, por lo tanto son interiores exc�ntricas.", 0

.code

DifferentCenterCase PROC					; Esta funci�n clasifica circulos cuando sus centros no coinciden.


	fld st(0)
	fsub st(0), st(2)
	fldz

	fcomip st(0), st(1)

	ja no_exteriores

	fld EPSILON

	fcomi st(0), st(1)
	ja tangente_ext
	jb exteriores_j

	tangente_ext:						; Caso de circunferencias tangentes exteriores.
		fstp st(0)
		fstp st(0)
		mov edx, OFFSET TANGENTES_EXT
		call WriteString
		push 1
		call CalculateIntersection
		jmp exitf

	exteriores_j:						; Caso de circunferencias exteriores.
		mov edx, OFFSET EXTERIORES
		call WriteString
		jmp exitf

	no_exteriores:						; Casos interiores
		fstp st(0)
		fld st(0)
		fsub st(0), st(3)


		fld EPSILON
		fcomip st(0), st(1)
		jb secantes_j
		fldz
		fcomip st(0), st(1)

		ja interiores_ext_j

		fstp st(0)
		mov edx, OFFSET TANGENTES_INT		; Caso de tangentes interiores.
		call WriteString
		push 2
		call CalculateIntersection
		jmp exitf

	interiores_ext_j:
		mov edx, OFFSET INTERIORES_EXT	; Caso de interiores excentricas.
		call WriteString
		jmp exitf
	
	secantes_j:
		fstp st(0)
		mov edx, OFFSET SECANTES			; Caso de circunferencias secantes
		call WriteString
		push 3
		call CalculateIntersection		; Calcula la intersecci�n.

	exitf:

	ret
DifferentCenterCase ENDP
END
