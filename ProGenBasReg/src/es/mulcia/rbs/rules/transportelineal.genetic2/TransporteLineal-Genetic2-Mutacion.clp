; TransporteLineal-Genetic2-Mutacion.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que genera un número aleatorio entre 0 y 99.
(defrule Mutacion::Inicio
        (not (aletario ?))
        (iteracion (n ?i))
        =>
        (assert (aleatorio (mod (random) 100)))
)

; Regla que se dispara cuando el cociente de mutación es mayor o igual que el número aleatorio.
; Se modifica el estado del hijo a lista.
(defrule Mutacion::No-mutar
        (cociente-mutacion ?m)
        ?solucion <- (solucion (estado hijo))
        ?aleatorio <- (aleatorio ?a)
        (test (<= ?m ?a))
        =>
        (retract ?aleatorio)
        (assert (aleatorio (mod (random) 100)))
        (modify ?solucion (estado lista))
)

; Regla que se dispara cuando el cociente de mutación es menor que el número aleatorio.
; Se modifica el estado del hijo a mutando y se invoca al módulo MutarElemento.
(defrule Mutacion::Mutar
        (not (solucion (estado mutando)))
        (cociente-mutacion ?m)
        ?solucion <- (solucion (estado hijo))
        ?aleatorio <- (aleatorio ?a)
        (test (> ?m ?a))
        =>
        (retract ?aleatorio)
        (assert (aleatorio (mod (random) 100)))
        (modify ?solucion (estado mutando))
        (focus MutarElemento)
)

; Regla que se dispara cuando se ha realizado el reemplo. Poniendo fin a la ejecución del módulo.
(defrule Mutacion::Finalizar
        (not (solucion (estado hijo)))
        ?aleatorio <- (aleatorio ?)
        =>
        (retract ?aleatorio)
        (pop-focus)
)