; TSP-AdyacencyRepresentation-Evaluacion.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que selecciona una lista con estado adyacente y la marca como evaluando.
; Inicializa el iterador a 0.
(defrule Evaluacion::Seleccionar-lista
        (not (lista (estado evaluando)))
        ?list <- (lista (estado adyacente))
        =>
        (modify ?list (estado evaluando))
        (assert (iter (n 0)))
)

; Regla que el añade a la lista evaluando el coste del desplazamiento ij.
(defrule Evaluacion::Evaluar-lista-ij
        ?iter <- (iter (n ?i))
        ?list <- (lista (estado evaluando)(esfuerzo ?esfuerzo)(datos $? / ?i ?j  $?))
        (esfuerzo (ciudadA ?i) (ciudadB ?j) (esfuerzo ?esf))
        =>
        (modify ?list (esfuerzo (+ ?esfuerzo ?esf)))
        (modify ?iter (n (+ ?i 1)))
)

; Regla que el añade a la lista evaluando el coste del desplazamiento ji.
(defrule Evaluacion::Evaluar-lista-ji
        ?iter <- (iter (n ?i))
        ?list <- (lista (estado evaluando)(esfuerzo ?esfuerzo)(datos $? / ?i ?j  $?))
        (esfuerzo (ciudadA ?j) (ciudadB ?i) (esfuerzo ?esf))
        =>
        (modify ?list (esfuerzo (+ ?esfuerzo ?esf)))
        (modify ?iter (n (+ ?i 1)))
)

; Regla que se dispara cuando se han evaluado toda la ruta de una lista.
; Se marca la lista como evaluda y se borra el iterador.
(defrule Evaluacion::Fin-evaluar-lista
        (p ?p)
        ?iter <- (iter (n ?p))
        ?list <- (lista (estado ?evaluando))
        =>
        (modify ?list(estado evaluada))
        (retract ?iter)
)

; Regla que se dispara cuando se han evaluado todas las listas.
; Se invoca al mòdulo EvaluarMejor.
(defrule Evaluacion::Evaluar-mejor
        (not (lista (estado adyacente)))
        =>
        (focus EvaluarMejor)
)