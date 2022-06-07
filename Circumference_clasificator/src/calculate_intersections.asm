TITLE Cálculo de las intersecciones entre los puntos.

; En este módulo se harán los calculos para hallar los puntos de intersección de las circunferencias
; a las que esto concierne. (Secantes, tangentes exteriores y tangentes interiores)


INCLUDE Irvine32.inc

EXTERN rx_1 : REAL4, ry_1 : REAL4, rx_2 : REAL4, ry_2 : REAL4, r_1 : REAL4, r_2 : REAL4
EXTERN WriteRoundFloat@0:PROC

WriteRoundFloat EQU <WriteRoundFloat@0>


.data
INT_X1 REAL4 ?
INT_Y1 REAL4 ?

INT_X2 REAL4 ?
INT_Y2 REAL4 ?

INTERSECCION BYTE "Los/el punto de interseccion es:", 0Ah, 0Dh, 0
.code

CalculateIntersection PROC TYPEOFC:DWORD
     LOCAL MAGNITUDE : REAL4, A_m:REAL4, K_m:REAL4,
     A_1:REAL4, A_2:REAL4, K_1:REAL4, K_2:REAL4

; Esta función recibe un parámetro(tipo de circunferencias) y calcula el / los puntos de intersección.
; Esta función regresa los puntos de intersección de las circunferencias que pasa el usuario (si hay).
     cmp TYPEOFC, 1
     jne not_tan_ext

     fst MAGNITUDE

; Punto de intersección circunferencias tangentes exteriores.
     fld rx_2
     fld rx_1
     fsubp st(1), st(0)                                ; Restar rx_2 de rx_1.
     fld r_1
     fmulp st(1), st(0)                                ; (x2 - x1)* r2.
     fdiv MAGNITUDE                                    ; ((x2 - x1)* r2) / distancia entre centros
     fld rx_1
     faddp st(1), st(0)                                ; (((x2 - x1)* r2) / Magnitud) + x1
     fstp INT_X1

     fld ry_2
     fld ry_1
     fsubp st(1), st(0)                                ; Restar ry_2 de ry_1
     fld r_1
     fmulp st(1), st(0)                                ; (y2 - y1)* r2
     fdiv MAGNITUDE                                    ; ((y2 - y1)* r2) / distancia entre centros
     fld ry_1
     faddp st(1), st(0)                                ; (((y2 - y1)* r2) / Magnitud) + y1
     fstp INT_Y1

     call Crlf                                         
     mov edx, OFFSET INTERSECCION                      
     call WriteString

; Mostrar en pantalla el punto.
     call Crlf                                         ; 
     fld INT_X1
     mov al, "("
     call WriteChar
     call WriteRoundFloat
     mov al, ","
     call WriteChar
     mov al, " "
     call WriteChar
     fld INT_Y1
     call WriteRoundFloat
     mov al, ")"
     call WriteChar

     jmp exit_sec

; Punto de intersección circunferencias tangentes interiores.
     not_tan_ext:                                 
     cmp TYPEOFC, 2
          jne not_tan_int

          fst MAGNITUDE

          fld rx_2
          fld rx_1
          fsubp st(1), st(0)
          fabs
          fld r_1
          fmulp st(1), st(0)
          fdiv MAGNITUDE
          fld rx_1
          faddp st(1), st(0)
          fstp INT_X1

          fld ry_2
          fld ry_1
          fsubp st(1), st(0)
          fabs
          fld r_1
          fmulp st(1), st(0)
          fdiv MAGNITUDE
          fld ry_1
          faddp st(1), st(0)
          fstp INT_Y1

          call Crlf
          mov edx, OFFSET INTERSECCION
          call WriteString

          call Crlf
          fld INT_X1
          mov al, "("
          call WriteChar
          call WriteRoundFloat
          mov al, ","
          call WriteChar
          mov al, " "
          call WriteChar
          fld INT_Y1
          call WriteRoundFloat
          mov al, ")"
          call WriteChar

          jmp exit_sec

; Puntos de intersección cirunferencias secantes.
     not_tan_int:
          fst MAGNITUDE

          fld r_2
          fmul r_2
          fld r_1
          fmul r_1
          fsubp st(1), st(0)
          fld MAGNITUDE
          fmul MAGNITUDE
          faddp st(1), st(0)
          fld MAGNITUDE
          fld MAGNITUDE
          faddp st(1), st(0)
          fdivp st(1), st(0)
          fstp A_m

          fld r_2
          fmul r_2
          fld A_m
          fmul A_m
          fsubp st(1), st(0)
          fsqrt
          fabs
          fstp K_m

          fld rx_1
          fld rx_2
          fsubp st(1), st(0)
          fdiv MAGNITUDE
          fmul A_m
          call Crlf
          fstp A_1


          fld ry_1
          fld ry_2
          fsubp st(1), st(0)
          fdiv MAGNITUDE
          fmul A_m
          fstp A_2



          fld ry_1
          fld ry_2
          fsubp st(1), st(0)
          fdiv MAGNITUDE
          fmul K_m
          fstp K_1

          fld rx_2
          fld rx_1
          fsubp st(1), st(0)
          fdiv MAGNITUDE
          fmul K_m
          fstp K_2


          fld A_1
          fld K_1
          faddp st(1), st(0)
          fadd rx_2
          fstp INT_X1

          fld A_2
          fld K_2
          faddp st(1), st(0)
          fadd ry_2
          fstp INT_Y1

          fld A_1
          fld K_1
          fsubp st(1), st(0)
          fadd rx_2
          fstp INT_X2

          fld A_2
          fld K_2
          fsubp st(1), st(0)
          fadd ry_2
          fstp INT_Y2

          call Crlf
          mov edx, OFFSET INTERSECCION
          call WriteString

          call Crlf
          mov al, "("
          call WriteChar
          fld INT_X1
          call WriteRoundFloat
          mov al, ","
          call WriteChar
          mov al, " "
          call WriteChar
          fld INT_Y1
          call WriteRoundFloat
          mov al, ")"
          call WriteChar

          call Crlf

          call Crlf
          fld INT_X2
          mov al, "("
          call WriteChar
          call WriteRoundFloat
          mov al, ","
          call WriteChar
          mov al, " "
          call WriteChar
          fld INT_Y2
          call WriteRoundFloat
          mov al, ")"
          call WriteChar

     exit_sec:

     ret
CalculateIntersection ENDP
END