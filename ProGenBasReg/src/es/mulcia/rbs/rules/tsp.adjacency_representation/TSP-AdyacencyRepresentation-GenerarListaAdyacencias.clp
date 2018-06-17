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

; Regla que modifica la lista actual para comience en la ciudad 0 y crea una lista temporal.
(defrule GenerarListaAdyacencias::Inicio
        ?list <- (lista (id ?id)(estado actual)(datos $?izq 0 $?der))
        =>
        (modify ?list (datos 0 $?izq $?der))
        (assert (lista (id ?id)(estado temp)))
)

; Regla que va añadiendo a la lista temporal las duplas i j en el orden en el que se recorren.
(defrule GenerarListaAdyacencias::Rellenar-lista-adyacencia
         ?list <- (lista (id ?id)(estado actual)(datos ?i ?j $?rest))
         ?temp <- (lista (id ?id)(estado temp)(datos $?datos))
         =>
         (modify ?list (datos ?j $?rest))
         (modify ?temp (datos $?datos ?i ?j /))
)

; Regla que añade el último elemento i 0 a la lista temporal e
; inicializa la lista ordenada con 0 j
(defrule GenerarListaAdyacencias::Anadir-ultimo
         ?list <- (lista (id ?id)(estado actual)(datos ?i))
         ?temp <- (lista (id ?id)(estado temp)(datos 0 ?j $?datos))
         =>
         (retract ?list)
         (modify ?temp (datos $?datos ?i 0))
         (assert (iter (n 1)))
         (assert (lista (id ?id)(estado ordenada)(datos / 0 ?j)))
)

; Lista que va añadiendo a la lista ordenada los elementos del a lista temporal
; en orden natural.
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