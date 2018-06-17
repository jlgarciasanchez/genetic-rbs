; TransporteLineal-Genetic2-Inicializacion.clp
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
        (assert (lista (estado mejor)(esfuerzo -1)))
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

; Regla que marca una lista como actual e invoca al módulo GenerarListaAdyacencias
; para convertir la lista en la representación por adyacencias.
(defrule Inicializacion::Generar-lista-adyacencias
        ?lista <- (lista (estado pendiente))
        =>
        (modify ?lista (estado actual))
        (focus GenerarListaAdyacencias)
)