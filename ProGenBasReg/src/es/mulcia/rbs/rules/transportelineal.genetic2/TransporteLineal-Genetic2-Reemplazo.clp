; TransporteLineal-Genetic2-Reemplazo.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que llama al módulo eliminar padres.
(defrule Reemplazo::Eliminar-padres
        ?reemplazo <- (reemplazo)
        =>
        (focus EliminarPadres)
        (retract ?reemplazo)
        
)

; Regla que cambia el id de la mejor solución por -1
(defrule Reemplazo::Modificar-id-mejor
        ?mejor <- (solucion (estado mejor))
        =>
        (modify ?mejor (id -1))
)

; Regla que cambia los ids de las filas hijos por ids de padres.
(defrule Reemplazo::Reemplazo-fila
        (not (reemplazo))
        ?fila <- (fila (idSolucion ?id))
        (nElementos ?nE)
        (test (>= ?id ?nE))
        =>
        (modify ?fila (idSolucion (- ?id ?nE)))
)

; Regla que cambia los ids de los hijos por ids de padres.
(defrule Reemplazo::Reemplazo-solucion
        (not (reemplazo))
        ?solucion <- (solucion (id ?id)(estado lista))
        (nElementos ?nE)
        (test (>= ?id ?nE))
        =>
        (modify ?solucion (id (- ?id ?nE))(estado pendiente))
)