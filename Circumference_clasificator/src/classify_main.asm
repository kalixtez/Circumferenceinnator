TITLE Clasificación en base a distancia entre centros y magnitud de los radios.

; En este módulo se harán los cálculos con los que posteriormente se clasificarán las circunferencias.

INCLUDE Irvine32.inc

; Heredar y renombrar funciones necesarias.
EXTERN WriteRoundFloat@0:PROC                                         
EXTERN BranchBasedOnDistance@0:PROC

WriteRoundFloat EQU <WriteRoundFloat@0>
BranchBasedOnDistance EQU <BranchBasedOnDistance@0>

.code

MainClassifier PROC                          ; Esta función calcula la distancia entre los 2 centros.
     LOCAL temp : REAL4                           

; Recibe: Las coordenadas de los centros.
; Devuelve: La distancia entre los centros(en st(0)).

; ----------------------------------------------------------------------------------------------------------------------------------------

     call DistanceBetweenCenters
     call BranchBasedOnDistance

     ret
MainClassifier ENDP

DistanceBetweenCenters PROC   ; Esta función calcula la distancia entre los 2 centros.
LOCAL temp : REAL4

; Recibe: Las coordenadas de los centros.
; Devuelve: La distancia entre los centros (en st(0)).

; ----------------------------------------------------------------------------------------------------------------------------------------

     fsubp st(1), st(0)			; Resta x_2 de x_1.
     fmul st(0), st(0)			; Multiplica la resta de arriba por si misma (x_2 - x_1) ^ 2.

     fstp temp					; Guarda el resultado en temp.

     fsubp st(1), st(0)			; Resta de y_2 y y_1.
     fmul st(0), st(0)			; (y_2 - y_1) ^ 2.

     fld temp					; Suma de los cuadrados.

     faddp

     fsqrt						; Raiz cuadrada de la suma de los cuadrados.

     ret
DistanceBetweenCenters ENDP
END