; TransporteLineal-Genetic1-MutarElemento.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que genera dos números aleatorios entre 0 y p-1.
(defrule MutarElemento::Inicio
        (p ?p)
        (not (aleatorioA ?))
        =>
        (assert (aleatorioA (mod (random) ?p)))
        (assert (aleatorioB (mod (random) ?p)))
)

; Regla que se dispara si aleatorioA esta a la iazuiqerda de aleatorioB. Intercambia sus posiciones.
; Se invoca al módulo RepararCiclos para romper posibles ciclos generados por la mutación.
(defrule MutarElemento::Mutar-izquierda
        ?aleatorioA <- (aleatorioA ?a)
        ?aleatorioB <- (aleatorioB ?b)
        ?list <- (lista (datos $?izq / ?a ?ja $?cen / ?b ?jb $?der) (estado mutando))
        =>
        (retract ?aleatorioA)
        (retract ?aleatorioB)
        (modify ?list (datos $?izq / ?a ?jb $?cen / ?b ?ja $?der) (estado hijo-actual))
        (focus RepararCiclos)
)

; Regla que se dispara si aleatorioA esta a la derecha de aleatorioB. Intercambia sus posiciones.
; Se invoca al módulo RepararCiclos para romper posibles ciclos generados por la mutación.
(defrule MutarElemento::Mutar-derecha
        ?aleatorioA <- (aleatorioA ?a)
        ?aleatorioB <- (aleatorioB ?b)
        ?list <- (lista (datos $?izq / ?b ?jb $?cen / ?a ?ja $?der) (estado mutando))
        =>
        (retract ?aleatorioA)
        (retract ?aleatorioB)
        (modify ?list (datos $?izq / ?b ?ja $?cen / ?a ?jb $?der) (estado hijo-actual))
        (focus RepararCiclos)
)

; Regla que se dispara si aleatorioA es igual a aleatorioB. Se modifica el estado de la lista a adyacente.
(defrule MutarElemento::Mutar-igual
        ?aleatorioA <- (aleatorioA ?igual)
        ?aleatorioB <- (aleatorioB ?igual)
        ?list <- (lista(estado mutando))
        =>
        (retract ?aleatorioA)
        (retract ?aleatorioB)
        (modify ?list (estado adyacente))
)

; Regla que cambia la lista de estado hijo-actual a adyacente.
(defrule MutarElemento::Cambiar-estado
        ?list <- (lista (estado hijo-actual))
        =>
        (modify ?list (estado adyacente))
)

; Regla que se dispara cuando ya se ha modificado la lista. Se pone fin a la ejecución del módulo.
(defrule MutarElemento::Finalizar
        (not (lista(estado mutando)))
        (not (lista(estado hijo-actual)))
        =>
        (pop-focus)
)