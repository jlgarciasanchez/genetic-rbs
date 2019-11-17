; TransporteLineal-Genetic2-Cruce.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que crea añade nuevas filas a las matrices DIV y REM.
(defrule Cruce::Anadir-filas
        (fila (idSolucion ?id)(fila ?fila)(datos $? / ? ? E $?))
        (not (solucion (estado hijo0)))
        (test (neq ?id -1))
        =>
        (assert (fila (idSolucion -2)(fila ?fila)))
        (assert (fila (idSolucion -3)(fila ?fila)))
)

; Regla rellena la matriz DIV. Los elementos pasan de estado E a estado D.
(defrule Cruce::Rellenar-div
        (solucion (id ?idPadreA) (estado padre))
        (solucion (id ?idPadreB) (estado padre))
        ?filaA <- (fila (idSolucion ?idPadreA) (fila ?fila) (datos $?izqA / ?columna ?cantidadA E $?derA))
        ?filaB <- (fila (idSolucion ?idPadreB) (fila ?fila) (datos $?izqB / ?columna ?cantidadB E $?derB))
        ?hijo <- (fila (idSolucion -2) (fila ?fila) (datos $?datos))
        (test (neq ?idPadreA ?idPadreB))
        =>
        (modify ?hijo (datos $?datos / ?columna (div (+ ?cantidadA ?cantidadB) 2 )))
        (modify ?filaA (datos $?izqA / ?columna ?cantidadA D $?derA))
        (modify ?filaB (datos $?izqB / ?columna ?cantidadB D $?derB))
)

; Regla rellena la matriz REM, los datos de REM se rellenan con estado A. Los elementos pasan de estado D a estado R.
(defrule Cruce::Rellenar-rem
        (solucion (id ?idPadreA) (estado padre))
        (solucion (id ?idPadreB) (estado padre))
        ?filaA <- (fila (idSolucion ?idPadreA) (fila ?fila) (datos $?izqA / ?columna ?cantidadA D $?derA))
        ?filaB <- (fila (idSolucion ?idPadreB) (fila ?fila) (datos $?izqB / ?columna ?cantidadB D $?derB))
        ?hijo <- (fila (idSolucion -3) (fila ?fila) (datos $?datos))
        (test (neq ?idPadreA ?idPadreB))
        =>
        (modify ?hijo (datos $?datos / ?columna (mod (+ ?cantidadA ?cantidadB) 2 ) A))
        (modify ?filaA (datos $?izqA / ?columna ?cantidadA R $?derA))
        (modify ?filaB (datos $?izqB / ?columna ?cantidadB R $?derB))
)

; Regla que llama al módulo DividirRem, se dispara cuando las matrices DIV y REM han sido rellenadas.
(defrule Cruce::Dividir-rem
        (solucion (id ?idPadreA) (estado padre))
        (solucion (id ?idPadreB) (estado padre))
        (not (fila (idSolucion ?idPadreA) (fila ?fila) (datos $? / ? ? E $?)))
        (not (fila (idSolucion ?idPadreB) (fila ?fila) (datos $? / ? ? E $?)))
        (not (fila (idSolucion ?idPadreA) (fila ?fila) (datos $? / ? ? D $?)))
        (not (fila (idSolucion ?idPadreB) (fila ?fila) (datos $? / ? ? D $?)))
        (test (neq ?idPadreA ?idPadreB))
        =>
        (focus DividirRem)
)

; Regla que llama al módulo GenerarHijos, se dispara después de invocar al módulo DividirRem.
(defrule Cruce::Generar-hijos
        (fila (idSolucion -4))
        =>
        (focus GenerarHijos)
)

; Regla que modifica las filas para volver a poner el estado de los datos a E.
(defrule Cruce::Reiniciar-padres
        (solucion (estado hijo0))
        ?fila <- (fila (datos $?der / ?columna ?cantidad R $?izq))
        =>
        (modify ?fila (datos $?der / ?columna ?cantidad E $?izq))
)

; Regla que finaliza finaliza la ejecución del módulo. Modifica el estado de los padres a pendiente.
; Modifica el estado de hijo0 e hijo1 a hijo y actualiza el contador nHijos.
(defrule Cruce::Finalizar
        (not (fila (datos $? / ?columna ?cantidadA R $?)))
        ?hijos <- (nHijos (n ?h))
        ?hijo0 <- (solucion (estado hijo0))
        ?hijo1 <- (solucion (estado hijo1))
        ?padreA <- (solucion (id ?idPadreA) (estado padre))
        ?padreB <- (solucion (id ?idPadreB) (estado padre))
        (test (neq ?idPadreA ?idPadreB))
        =>
        (modify ?hijos (n (+ ?h 2)))
        (modify ?hijo0 (estado hijo))
        (modify ?hijo1 (estado hijo))
        (modify ?padreA (estado pendiente))
        (modify ?padreB (estado pendiente))
        (pop-focus)
)