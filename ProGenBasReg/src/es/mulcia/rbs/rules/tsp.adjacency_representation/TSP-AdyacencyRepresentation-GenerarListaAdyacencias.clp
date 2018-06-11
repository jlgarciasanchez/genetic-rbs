; TSP-AdyacencyRepresentation-GenerarListaAdyacencias.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla

;============================================================================

; Plantilla que se utiliza para almacenar los datos de un iterador.
(deftemplate GenerarListaAdyacencias::iter
        (slot n)
)

;============================================================================

; Regla que fija como mejor solución una lista vacía con esfuerzo -1 y llama a GenerarLista.
(defrule GenerarListaAdyacencias::Inicio
        ?list <- (lista (id ?id)(estado actual)(datos $?izq 0 $?der))
        =>
        (modify ?list (datos 0 $?izq $?der))
        (assert (lista (id ?id)(estado temp)))
)

(defrule GenerarListaAdyacencias::Rellenar-lista-adyacencia
         ?list <- (lista (id ?id)(estado actual)(datos ?i ?j $?rest))
         ?temp <- (lista (id ?id)(estado temp)(datos $?datos))
         =>
         (modify ?list (datos ?j $?rest))
         (modify ?temp (datos $?datos ?i ?j /))
)

(defrule GenerarListaAdyacencias::Anadir-ultimo
         ?list <- (lista (id ?id)(estado actual)(datos ?i))
         ?temp <- (lista (id ?id)(estado temp)(datos 0 ?j $?datos))
         =>
         (retract ?list)
         (modify ?temp (datos $?datos ?i 0))
         (assert (iter (n 1)))
         (assert (lista (id ?id)(estado ordenada)(datos 0 ?j)))
)

(defrule GenerarListaAdyacencias::Ordenar
        ?iter <- (iter (n ?it))
        ?temp <- (lista (estado temp)(datos $?izq / ?it ?j $?der))
        ?orde <- (lista (estado ordenada)(datos $?datos))
        =>
        (assert (prueba))
        (modify ?temp (datos $?izq $?der))
        (modify ?orde (datos ?datos / ?it ?j))
        (modify ?iter (n (+ ?it 1)))
)