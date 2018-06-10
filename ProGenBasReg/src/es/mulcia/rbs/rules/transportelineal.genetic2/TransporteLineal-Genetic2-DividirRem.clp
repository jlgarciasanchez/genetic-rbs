; TransporteLineal-Genetic2-DividirRem.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Plantilla que se utiliza para almacenar el contador del número de 1 en las filas y columnas de REM.
(deftemplate DividirRem::contador
        (slot id)
        (slot tipo)
        (slot numero)
        (slot cantidad)
)

;============================================================================

; Regla que crea las filas de REM2 con id -4.
(defrule DividirRem::Crear-filas
        (fila (fila ?fila))
        (not (fila (idSolucion -4)(fila ?fila)))
        =>
        (assert (fila (idSolucion -4)(fila ?fila)))

)

; Regla que cuenta los 1s en en las filas y columnas de REM. Se modifica el estado de A a B.
; Se utiliza cuando ya han sido creados los contadores de fila y columna.
(defrule DividirRem::Contar
        ?rem <- (fila (idSolucion -3) (fila ?fila) (datos $?der / ?columna 1 A $?izq))
        ?contadorF <- (contador (id 0)(tipo fila)(numero ?fila)(cantidad ?cantidadF))
        ?contadorC <- (contador (id 0)(tipo columna)(numero ?columna)(cantidad ?cantidadC))
        =>
        (modify ?rem (datos $?der / ?columna 1 B $?izq))
        (modify ?contadorF (cantidad (+ ?cantidadF 1)))
        (modify ?contadorC (cantidad (+ ?cantidadC 1)))
)

; Regla que cuenta los 1s en en las filas y columnas de REM. Se modifica el estado de A a B.
; Se utiliza cuando ya ha sido creado el contador de fila pero no el de columna.
(defrule DividirRem::Contar-columna-nueva
        ?rem <- (fila (idSolucion -3) (fila ?fila) (datos $?der / ?columna 1 A $?izq))
        ?contadorF <- (contador (id 0)(tipo fila)(numero ?fila)(cantidad ?cantidad))
        (not(contador (id 0)(tipo columna)(numero ?columna)))
        =>
        (modify ?rem (datos $?der / ?columna 1 B $?izq))
        (modify ?contadorF (cantidad (+ ?cantidad 1)))
        (assert (contador (id 0)(tipo columna)(numero ?columna)(cantidad 1)))
        (assert (contador (id 1)(tipo columna)(numero ?columna)(cantidad 0)))
)

; Regla que cuenta los 1s en en las filas y columnas de REM. Se modifica el estado de A a B.
; Se utiliza cuando ya ha sido creado el contador de columna pero no el de fila.
(defrule DividirRem::Contar-fila-nueva
        ?rem <- (fila (idSolucion -3) (fila ?fila) (datos $?der / ?columna 1 A $?izq))
        (not (contador (id 0)(tipo fila)(numero ?fila)))
        ?contadorC <- (contador (id 0)(tipo columna)(numero ?columna)(cantidad ?cantidad))
        =>
        (modify ?rem (datos $?der / ?columna 1 B $?izq))
        (assert (contador (id 0)(tipo fila)(numero ?fila)(cantidad 1)))
        (assert (contador (id 1)(tipo fila)(numero ?fila)(cantidad 0)))
        (modify ?contadorC (cantidad (+ ?cantidad 1)))
        
)

; Regla que cuenta los 1s en en las filas y columnas de REM. Se modifica el estado de A a B.
; Se utiliza cuando aún no han sido creados los contadores de fila y columna.
(defrule DividirRem::Contar-fila-columna-nuevas
        ?rem <- (fila (idSolucion -3) (fila ?fila) (datos $?der / ?columna 1 A $?izq))
        (not (contador (id 0)(tipo fila)(numero ?fila)(cantidad ?cantidad)))
        (not(contador (id 0)(tipo columna)(numero ?columna)(cantidad ?cantidad)))
        =>
        (modify ?rem (datos $?der / ?columna 1 B $?izq))
        (assert (contador (id 0)(tipo fila)(numero ?fila)(cantidad 1)))
        (assert (contador (id 0)(tipo columna)(numero ?columna)(cantidad 1)))
        (assert (contador (id 1)(tipo fila)(numero ?fila)(cantidad 0)))
        (assert (contador (id 1)(tipo columna)(numero ?columna)(cantidad 0)))
        
)

; Regla que pasa un 1 de REM a REM2. Se modifica el estado de B a C y se actualizan los contadores.
; Se dispara cuando el elemento vale 1 y los contadores de REM son mayores que los de REM2.
(defrule DividirRem::Uno-a-rem2
        (not (fila (idSolucion -3)(datos $? / ?columna 1 A $?)))
        ?rem <- (fila (idSolucion -3) (fila ?fila) (datos $?der / ?columna 1 B $?izq))
        ?rem2 <- (fila (idSolucion -4) (fila ?fila) (datos $?datos))
        ?fila0 <- (contador (id 0) (tipo fila) (numero ?fila)(cantidad ?cfila0))
        ?fila1 <- (contador (id 1) (tipo fila) (numero ?fila)(cantidad ?cfila1))
        ?columna0 <- (contador (id 0) (tipo columna) (numero ?columna)(cantidad ?ccolumna0))
        ?columna1 <- (contador (id 1) (tipo columna) (numero ?columna)(cantidad ?ccolumna1))
        (test (> ?cfila0 ?cfila1))
        (test (> ?ccolumna0 ?ccolumna1))
        =>
        (modify ?rem (datos $?der / ?columna 0 C $?izq))
        (modify ?rem2 (datos $?datos / ?columna 1 C))
        (modify ?fila0 (cantidad (- ?cfila0 1)))
        (modify ?fila1 (cantidad (+ ?cfila1 1)))
        (modify ?columna0 (cantidad (- ?ccolumna0 1)))
        (modify ?columna1 (cantidad (+ ?ccolumna1 1)))
)

; Regla que añade un 0 a REM2. Se modifica el estado de B a C.
; Se dispara cuando el elemento vale 1 y los contadores de REM son iguales que los de REM2.
(defrule DividirRem::Uno-a-rem
        (not (fila (idSolucion -3)(datos $? / ?columna 1 A $?)))
        ?rem <- (fila (idSolucion -3) (fila ?fila) (datos $?der / ?columna 1 B $?izq))
        ?rem2 <- (fila (idSolucion -4) (fila ?fila) (datos $?datos))
        (contador (id 0) (tipo fila) (numero ?fila)(cantidad ?cfila0))
        (contador (id 1) (tipo fila) (numero ?fila)(cantidad ?cfila1))
        (contador (id 0) (tipo columna) (numero ?columna)(cantidad ?ccolumna0))
        (contador (id 1) (tipo columna) (numero ?columna)(cantidad ?ccolumna1))
        (test (eq ?cfila0 ?cfila1))
        (test (eq ?ccolumna0 ?ccolumna1))
        =>
        (modify ?rem (datos $?der / ?columna 1 C $?izq))
        (modify ?rem2 (datos $?datos / ?columna 0 C))
)

; Regla que añade un 0 a REM2. Se modifica el estado de B a C.
; Se dispara cuando el elemento vale 0.
(defrule DividirRem::Cero-a-rem2
        (not (fila (idSolucion -3)(datos $? / ?columna 1 A $?)))
        ?rem <- (fila (idSolucion -3) (fila ?fila) (datos $?der / ?columna 0 A $?izq))
        ?rem2 <- (fila (idSolucion -4) (fila ?fila) (datos $?datos))
        =>
        (modify ?rem (datos $?der / ?columna 0 C $?izq))
        (modify ?rem2 (datos $?datos / ?columna 0 C))
)

; Regla que elimina los contadores. Se disapra cuando todos los elementos tienen estado C.
(defrule DividirRem::Borrar-contadores
        (not (fila (idSolucion -3)(datos $? / ?columna ? A $?)))
        (not (fila (idSolucion -3)(datos $? / ?columna ? B $?)))
        ?contador <- (contador)
        =>
        (retract ?contador)
)
