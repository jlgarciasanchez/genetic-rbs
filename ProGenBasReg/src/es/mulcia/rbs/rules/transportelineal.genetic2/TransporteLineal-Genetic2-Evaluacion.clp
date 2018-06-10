; TransporteLineal-Genetic2-Evaluacion.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que calcula el esfuerzo de un elemento de la solucion, lo marca y lo suma al total.
(defrule Evaluacion::Evaluar-lista
        ?solucion <- (solucion (id ?id) (esfuerzo ?esfuerzoTotal))
        ?fila <- (fila (idSolucion ?id) (fila ?f) (datos $?izq / ?c ?merc P $?der))
        (esfuerzo (fuente ?c) (destino ?f) (esfuerzo ?esfuerzo))
        =>
        (modify ?solucion (esfuerzo (+ ?esfuerzoTotal (* ?esfuerzo ?merc))))
        (modify ?fila (datos $?izq / ?c ?merc E $?der))
)

; Regla que llama al módulo EvaluarMejor una vez se hayan evaluado todas las listas.
(defrule Evaluacion::Buscar-mejor
        (not(fila (datos $? / ? ? P $?)))
        ?solucion <- (solucion (estado mejor))
        =>
        (focus EvaluarMejor)
)

; Regla que copia las filas de la mejor solución.
(defrule Evaluacion::Almacenar-filas-mejor
        (solucion (id ?id)(estado mejor))
        ?fila <- (fila (idSolucion ?id))
        =>
        (duplicate ?fila (idSolucion -1))
)
