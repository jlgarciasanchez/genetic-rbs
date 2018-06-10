; TransporteLineal-Genetic1-GenerarLista.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que crea una lista vacía.
(defrule GenerarLista::Inicializar
        (not (lista (id -1)))
        =>
        (assert (lista (id -1)(esfuerzo 0)(estado ordenada)))
        (assert (it 0))
)

; Regla que añade elementos en orden hasta llegar a p.
(defrule GenerarLista::Agregar-elementos
        ?list <- (lista (datos $?datos)(estado ordenada))
        ?iter <- (it ?x)
        (not (p ?x))
        =>
        (modify ?list (datos $?datos ?x))
        (assert (it (+ ?x 1)))
        (retract ?iter)
)

; Regla que pone fin a la ejecución del módulo.
(defrule GenerarLista::Finalizar
        ?iter <- (it ?x)
        (p ?x)
        =>
        (retract ?iter)
        (pop-focus)
)