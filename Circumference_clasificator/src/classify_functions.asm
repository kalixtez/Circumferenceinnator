TITLE Funciones de utilidad.

; En este m�dulo est�n las funciones que se utilizar�n para clasificar las circunferencias en base a sus centros.

INCLUDE Irvine32.inc

; Heredar y renombrar funciones necesarias.
EXTERN EqualCenterCase@0:PROC
EXTERN DifferentCenterCase@0:PROC


EqualCenterCase EQU <EqualCenterCase@0>
DifferentCenterCase EQU <DifferentCenterCase@0>
EXTERN WriteRoundFloat@0:PROC



.data

EPSILON REAL4 1.0E-6                         ; Variable de comparaci�n para evitar errores de representaci�n de n�meros de punto flotante.
PUBLIC EPSILON

.code

BranchBasedOnDistance PROC

; Esta funci�n recibe a la distancia entre los centros (en ST(0)) y el valor absoluto de la resta y la suma de los mismos (en ST(2) y ST(1), respectivamente).

     fld EPSILON                                  ; Comprobar si la distancia entre los centros es mayor que 0 o no.
     fcomi st(0), st(1)                           ; Esto permitir� saber cuales subrutinas hay que llamar.
     fstp st(0)

     jae EqualCenter


     call DifferentCenterCase
     jmp Exit_func

     EqualCenter:

          call EqualCenterCase

     Exit_func:

     ret
BranchBasedOnDistance ENDP
END