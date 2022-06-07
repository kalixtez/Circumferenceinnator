TITLE Clasificador de círcunferencias.

; Este programa clasifica circunferencias en base a sus posiciones relativas.

; ----------------------------------------------------------------------------------------------------------------------------------------------

.386
.model flat, stdcall

INCLUDE Irvine32.inc

EXTERN MainClassifier@0:PROC                 ; Se hereda el procedimiento MainClassifier del módulo classify_main.

; DEFINIR CONSTANTES

NUM_OF_OPTIONS = 6                           ; Constante que determina cuantas veces se dejará al usuario ingresar un input.

;-------------------

MainClassifier EQU <MainClassifier@0>        ; Renombra MainClassifier@0 a MainClassifier para más comodidad.

.data                                        ; Indicaciones para el usuario.

Sld10 BYTE "Bienvenido", 0Ah, 0Dh, 0
Sld11 BYTE "Este programa clasifica las posiciones relativas entre dos circunferencias.", 0Ah, 0Dh, 0
Sld12 BYTE "Primero recibe seis datos correspondientes a los componentes de ambas circunferencias. (X1, Y1, R1, X2, Y2, R2) ", 0Ah, 0Dh, 0
Sld13 BYTE "Posteriormente mostrara la posicion relativa entre las dos e imprimira los puntos de interseccion si es el caso", 0Ah, 0Dh, 0
Sld14 BYTE "acabando con un mensaje de despedida.", 0Ah, 0Dh, 0
Dpd BYTE "Fin del programa, Muchas Gracias!", 0Ah, 0Dh, 0

rst BYTE "Volver a correr el programa? (Si=1, No=0)", 0Ah, 0Dh, 0

MSGX1 BYTE "Ingrese el X1:", 0Ah, 0Dh, 0
MSGY1 BYTE "Ingrese el Y1:", 0Ah, 0Dh, 0
MSGR1 BYTE "Ingrese el R1:", 0Ah, 0Dh, 0

MSGX2 BYTE "Ingrese el X2:", 0Ah, 0Dh, 0
MSGY2 BYTE "Ingrese el Y2:", 0Ah, 0Dh, 0
MSGR2 BYTE "Ingrese el R2:", 0Ah, 0Dh, 0

STRING_OFFSET = SIZEOF MSGX1                  ; Constante que contiene el tamaño de los mensajes, todos los mensaje tienen el mismo tamaño.

.data?                                        ; Variables que se utilizan en los cálculos.
rx_1 REAL4 ?                                  
ry_1 REAL4 ?
r_1  REAL4 ?

rx_2 REAL4 ?
ry_2 REAL4 ?
r_2  REAL4 ?

reset DWORD ?

PUBLIC rx_1, ry_1, rx_2, ry_2, r_1, r_2       ; Se hacen públicas las variables para que puedan ser heredadas por otros módulos.

.code
main PROC

     mov eax, green
     call SetTextColor

     mov dl, 45
     mov dh, 17
     call GotoXy
     call WaitMsg
     call Crlf
     call Clrscr

     mov eax, white
     call SetTextColor

     mov dl, 54
     mov dh, 5
     call GotoXy
     mov edx, OFFSET Sld10
     call WriteString

     mov dl, 23
     mov dh, 9
     call GotoXy
     mov edx, OFFSET Sld11
     call WriteString

     mov dl, 4
     mov dh, 10
     call GotoXy
     mov edx, OFFSET Sld12
     call WriteString

     mov dl, 4
     mov dh, 11
     call GotoXy
     mov edx, OFFSET Sld13
     call WriteString

     mov dl, 40
     mov dh, 12
     call GotoXy
     mov edx, OFFSET Sld14
     call WriteString


     mov dl, 46
     mov dh, 17
     call GotoXy
     call WaitMsg
     call Crlf
     call Clrscr

     inicio:

          call Clrscr

          mov ecx, NUM_OF_OPTIONS                  ; Se mueve NUM_OF_OPTIONS a ecx para el loop en el que se piden datos al usuario.
          mov esi, 0                               ; Indice para referenciar las variables de los cálculos (coordenadas del centro y radio de las circunferencias).

          push esi                                 ; Se guarda esi debido a que en el posterior loop será modificado.

          mov edx, OFFSET MSGX1                    ; Se mueve a edx el OFFSET del primer mensaje para utilizar WriteString.

          prompt:                                  ; Se imprime cada uno de los mensajes y se leen las variables.

               call WriteString
               add edx, STRING_OFFSET

               call ReadFloat

               fstp rx_1[esi]
               add esi, 4

          loop prompt

          pop esi                                   ; Se restaura esi.

          fld r_1                                   ; Se cargan los radios en el stack de la fpu.
          fld r_2                                   

          fsubp
          fabs	                                     ; Se saca el valor absoluto de la resta de los radios.

          fld r_1
          fld r_2

          faddp	                                ; Se suman los dos radios

          fld rx_1	                                ; Se cargan las coordenadas de los centros en la fpu y luego se pasan a la función MainClassifier
          fld rx_2
          fld ry_1
          fld ry_2

          call Crlf
          call MainClassifier

          fstp st(0)
          fstp st(0)
          fstp st(0)


          call Crlf

          mov edx, OFFSET rst                       ; Reinicia el programa si el usuario da la opción adecuada.
          call WriteString
          call ReadInt
          mov reset, eax

          fild reset
          fldz
          fcomi st(0), st(1)
          jg inicio_stc
          jmp fin

          inicio_stc :
               fstp st(0)
               fstp st(0)
               jmp inicio

          fin :
               call Crlf
               mov edx, OFFSET Dpd
               call WriteString
               call Crlf
               call WaitMsg

          exit
main ENDP
END main
