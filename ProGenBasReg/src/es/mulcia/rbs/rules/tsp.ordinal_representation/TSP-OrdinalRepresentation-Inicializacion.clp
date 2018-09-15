; TSP-OrdinalRepresentation-Inicializacion.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que fija como mejor solución una lista vacía con esfuerzo -1 y llama a GenerarLista.
(defrule Inicializacion::Inicio
        (not (it ?))
        =>
        (assert(it 0))
        (assert (lista (id -2)(estado mejor)(esfuerzo -1)))
        (focus GenerarLista)
)

; Regla que se dispara hasta que se hayan generado suficientes listas desordenadas, crea una copia de la lista ordenda 
; y llama a DesordenarLista para que la desordene.
(defrule Inicializacion::Generar-listas-desordenadas
        ?iter <- (it ?x)
        ?list <- (lista (estado ordenada))
        (not (nElementos ?x))
        =>
        (duplicate ?list (id ?x)(estado desordenando))
        (assert (it (+ ?x 1)))
        (retract ?iter)
        (focus DesordenarLista)
)

; Regla que cambia el estado de la lista ordenada a ciudades.
(defrule Inicializacion::Guardar-ciudades
        (nElementos ?nE)
        ?iter <- (it ?nE)
        ?orde <- (lista (estado ordenada))
        =>
        (modify  ?orde (estado ciudades))
)

; Regla que marca una lista como actual e invoca al módulo GenerarListaOrdinal
; para convertir la lista en la representación ordinal.
(defrule Inicializacion::Generar-lista-ordinal
        ?lista <- (lista (estado pendiente))
        (lista (estado ciudades))
        =>
        (modify ?lista (estado actual))
        (focus GenerarListaOrdinal)
)

; Regla que elimina el iterador temporal y pone fin a la ejecución del módulo.
(defrule Inicializacion::Finalizar
        (nElementos ?nE)
        ?iter <- (it ?nE)
        (not (lista (estado pendiente)))
        =>
        (retract ?iter)
        (pop-focus)
)