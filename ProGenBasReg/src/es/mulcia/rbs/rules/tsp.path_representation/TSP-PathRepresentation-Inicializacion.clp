; TSP-PathRepresentation-Inicializacion.clp
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

; Regla que cambia el estado de una lista de pendiente a preparada y coloca el 0 en la primera posición.
(defrule Inicializacion::Cambiar-inicio
        ?lista <- (lista (estado pendiente)(datos $?izq 0 $?der))
        =>
        (modify ?lista (estado preparada)(datos 0 $?izq $?der))
)

; Regla que elimina el iterador temporal y pone fin a la ejecución del módulo.
(defrule Inicializacion::Finalizar
        (nElementos ?nE)
        ?iter <- (it ?nE)
        ?list <- (lista (estado ordenada))
        (not (lista (estado pendiente)))
        =>
        (retract ?iter)
        (retract ?list)
        (pop-focus)
)