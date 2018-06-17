; TransporteLineal-Genetic1-EvaluarMejor.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Reqla que si encuentra una lista con esfuerzo menor que la mejor la reemplaza.
(defrule EvaluarMejor::Seleccionar-mejor
        ?mejor <- (lista (estado mejor) (esfuerzo ?m))
        ?nueva <- (lista (id ?id)(esfuerzo ?n))
        (test (> ?m ?n))
        (test (> ?id -1))
        =>
        (retract ?mejor)
        (duplicate ?nueva (estado mejor))
)

; Reqla que se dispara si aún no se ha encontrado una mejor solución y fija una cualquiera.
(defrule EvaluarMejor::Seleccionar-primera
        ?mejor <- (lista (estado mejor) (esfuerzo -1))
        ?nueva <- (lista (id ?id)(esfuerzo ?n))
        (test (> ?id -1))
        =>
        (retract ?mejor)
        (duplicate ?nueva (estado mejor))
)