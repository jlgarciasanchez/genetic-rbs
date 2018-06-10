; TransporteLineal-Genetic2-EliminarPadres.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que elimina las filas de los padres.
(defrule EliminarPadres::Eliminar-filas-padres
        ?fila <- (fila (idSolucion ?id))
        (nElementos ?nE)
        (test (> ?id -1))
        (test (< ?id ?nE))
        =>
        (retract ?fila)
)

; Regla que elimina a los padres.
(defrule EliminarPadres::Eliminar-soluciones-padres
        ?solucion <- (solucion (estado pendiente))
        =>
        (retract ?solucion)
)