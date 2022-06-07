TITLE Funciones para los casos donde los centros coinciden.

; Aqu� se clasificar�n los casos donde los centros de las circunferencias coinciden.

INCLUDE Irvine32.inc

.data
EPSILON2 REAL4 1.0E-12			; Variable de comparaci�n para evitar errores de representaci�n de n�meros de punto flotante.

; Mensajes de resultado.
CONCENTRIC BYTE "Estas circunferencias son conc�ntricas", 0Ah, 0Dh, 
				"pero tienen distintos radios.", 0

COINCIDENT BYTE "Estas circunferencias son conc�ntricas, tambi�n tienen igual radio", 0Ah, 0Dh,
				"y por lo tanto, son la misma circunferencia o circunferencias coincidentes.", 0


.code

EqualCenterCase PROC			; Esta funci�n clasifica circulos cuando sus centros coinciden.

	fld EPSILON2
	fcomi st(0), st(3)
	ja COINCIDENT_c

	mov edx, OFFSET CONCENTRIC	; Si los circulos son concentricos.
	call WriteString

	jmp Exit_func

	COINCIDENT_c:				; Si los circulos son coincidentes

		mov edx, OFFSET COINCIDENT
		call WriteString

	Exit_func:
		fstp st(0)			; Borrar a EPSILON del stack de la FPU.

	ret
EqualCenterCase ENDP
END
