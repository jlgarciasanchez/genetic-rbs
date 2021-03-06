;; TSP-AdyacencyRepresentation-EvaluarMejor.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Reqla que si encuentra una lista con esfuerzo menor que la mejor la reemplaza.
(defrule EvaluarMejor::Seleccionar-mejor
        ?mejor <- (lista (estado mejor) (esfuerzo ?m))
        ?nueva <- (lista (esfuerzo ?n))
        (test (> ?m ?n))
        =>
        (retract ?mejor)
        (duplicate ?nueva (estado mejor))
)

; Reqla que se dispara si aún no se ha encontrado una mejor solución y fija una cualquiera.
(defrule EvaluarMejor::Seleccionar-primera
        ?mejor <- (lista (estado mejor) (esfuerzo -1))
        ?nueva <- (lista (esfuerzo ?n))
        =>
        (retract ?mejor)
        (duplicate ?nueva (estado mejor))
)