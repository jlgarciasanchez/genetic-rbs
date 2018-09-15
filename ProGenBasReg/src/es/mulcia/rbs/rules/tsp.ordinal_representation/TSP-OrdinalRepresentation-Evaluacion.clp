; TSP-OrdinalRepresentation-Evaluacion.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que selecciona una lista con estado preparada y la marca como evaluando.
; Inicializa el iterador a 0.
(defrule Evaluacion::Seleccionar-lista
        ?list <- (lista (estado preparada))
        =>
        (modify ?list (estado actual))
        (assert (iter (n 0)))
        (focus EvaluarLista)
)

; Regla que se dispara cuando se han evaluado todas las listas.
; Se invoca al mòdulo EvaluarMejor.
(defrule Evaluacion::Evaluar-mejor
        (not (lista (estado preparada)))
        =>
        (focus EvaluarMejor)
)