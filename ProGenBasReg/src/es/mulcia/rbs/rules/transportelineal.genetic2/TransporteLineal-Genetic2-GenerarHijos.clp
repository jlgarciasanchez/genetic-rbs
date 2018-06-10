; TransporteLineal-Genetic2-GenerarHijos.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que crea crea dos soluciones hijas con id el número de elementos + el número de hijos.
(defrule GenerarHijos::Generar-solucion
        (nElementos ?elementos)
        (nHijos (n ?hijos))
        =>
        (assert (solucion (id (+ ?hijos ?elementos)) (esfuerzo 0) (estado hijo0)))
        (assert (solucion (id (+ (+ ?hijos ?elementos) 1)) (esfuerzo 0) (estado hijo1)))
)

; Regla que crea las filas de las nuevas soluciones.
(defrule GenerarHijos::Generar-filas
        (solucion (id ?id0)(estado hijo0))
        (solucion (id ?id1)(estado hijo1))
        (fila (fila ?fila))
        (not (fila (idSolucion ?id0) (fila ?fila)))
        =>
        (assert (fila (idSolucion ?id0) (fila ?fila)))
        (assert (fila (idSolucion ?id1) (fila ?fila)))
)

; Regla que añade los elemenots al hijo0 sumando div + rem. Se pasa de estado C a D.
(defrule GenerarHijos::Generar-hijo0
        (solucion (id ?id)(estado hijo0))
        (fila (idSolucion -2) (fila ?fila)(datos $? / ?columna ?vdiv $?))
        ?rem <- (fila (idSolucion -3) (fila ?fila)(datos $?der / ?columna ?vrem C $?izq))
        ?filax <- (fila (idSolucion ?id) (fila ?fila)(datos $?datos))
        =>
        (modify ?rem (datos $?der / ?columna ?vrem D $?izq))
        (modify ?filax (datos $?datos / ?columna (+ ?vdiv ?vrem) P))
)

; Regla que añade los elemenots al hijo1 sumando div + rem2. Se pasa de estado C a D.
(defrule GenerarHijos::Generar-hijo1
        (solucion (id ?id)(estado hijo1))
        (fila (idSolucion -2) (fila ?fila)(datos $? / ?columna ?vdiv $?))
        ?rem <- (fila (idSolucion -4) (fila ?fila)(datos $?der / ?columna ?vrem C $?izq))
        ?filax <- (fila (idSolucion ?id) (fila ?fila)(datos $?datos))
        =>
        (modify ?rem (datos $?der / ?columna ?vrem D $?izq))
        (modify ?filax (datos $?datos / ?columna (+ ?vdiv ?vrem) P))
)

; Regla que elimina las filas de div.
(defrule GenerarHijos::Eliminar-div
        (not (fila (idSolucion -3) (datos $? / ? ? C $?)))
        (not (fila (idSolucion -4) (datos $? / ? ? C $?)))
        ?div <- (fila (idSolucion -2))
        =>
        (retract ?div)
)

; Regla que elimina las filas de rem.
(defrule GenerarHijos::Eliminar-rem
        (not (fila (idSolucion -3) (datos $? / ? ? C $?)))
        (not (fila (idSolucion -4) (datos $? / ? ? C $?)))
        ?rem <- (fila (idSolucion -3))
        =>
        (retract ?rem)
)

; Regla que elimina las filas de rem2.
(defrule GenerarHijos::Eliminar-rem2
        (not (fila (idSolucion -3) (datos $? / ? ? C $?)))
        (not (fila (idSolucion -4) (datos $? / ? ? C $?)))
        ?rem2 <- (fila (idSolucion -4))
        =>
        (retract ?rem2)
)