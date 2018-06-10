; TransporteLineal-Genetic1-EvaluarMejor.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Reqla que si encuentra una lista con esfuerzo menor que la mejor la reemplaza.
(defrule EvaluarMejor::Seleccionar-mejor
        ?mejor <- (solucion (estado mejor) (esfuerzo ?m))
        ?nueva <- (solucion (esfuerzo ?n))
        (test (> ?m ?n))
        =>
        (retract ?mejor)
        (duplicate ?nueva (estado mejor))
)

; Regla que borra las filas de la anterior mejor solución.
(defrule EvaluarMejor::Borrar-filas-antiguas
        (solucion (id ?id)(estado mejor))
        ?fila <- (fila (idSolucion -1))
        (not (test (eq ?id -1)))
        =>
        (retract ?fila)
)

; Reqla que se dispara si aún no se ha encontrado una mejor solución y fija una cualquiera.
(defrule EvaluarMejor::Seleccionar-primera
        ?mejor <- (solucion (estado mejor) (esfuerzo -1))
        ?nueva <- (solucion (esfuerzo ?n))
        =>
        (retract ?mejor)
        (duplicate ?nueva (estado mejor))
)