; TSP-PathRepresentation-MutarElemento.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que genera dos números aleatorios entre 1 y p-1.
(defrule MutarElemento::Inicio
        (p ?p)
        (not (aleatorioA ?))
        =>
        (assert (aleatorioA (+ (mod (random) (- ?p 1))1)))
        (assert (aleatorioB (+ (mod (random) (- ?p 1))1)))
)

; Regla que se dispara si aleatorioA esta a la iazuiqerda de aleatorioB. Intercambia sus preparada.
; Además modifica el estado de la lista a pendiente.
(defrule MutarElemento::Mutar-izquierda
        ?aleatorioA <- (aleatorioA ?a)
        ?aleatorioB <- (aleatorioB ?b)
        ?list <- (lista (datos $?izq ?a $?cen ?b $?der) (estado mutando))
        =>
        (retract ?aleatorioA)
        (retract ?aleatorioB)
        (modify ?list (datos $?izq ?b $?cen ?a $?der) (estado preparada))
)

; Regla que se dispara si aleatorioA esta a la derecha de aleatorioB. Intercambia sus preparada.
; Además modifica el estado de la lista a pendiente.
(defrule MutarElemento::Mutar-derecha
        ?aleatorioA <- (aleatorioA ?a)
        ?aleatorioB <- (aleatorioB ?b)
        ?list <- (lista (datos $?izq ?b $?cen ?a $?der) (estado mutando))
        =>
        (retract ?aleatorioA)
        (retract ?aleatorioB)
        (modify ?list (datos $?izq ?a $?cen ?b $?der) (estado preparada))
)

; Regla que se dispara si aleatorioA es igual a aleatorioB. Se modifica el estado de la lista a preparada.
(defrule MutarElemento::Mutar-igual
        ?aleatorioA <- (aleatorioA ?igual)
        ?aleatorioB <- (aleatorioB ?igual)
        ?list <- (lista(estado mutando))
        =>
        (retract ?aleatorioA)
        (retract ?aleatorioB)
        (modify ?list (estado preparada))
)

; Regla que se dispara cuando ya se ha modificado la lista. Se pone fin a la ejecución del módulo.
(defrule MutarElemento::Finalizar
        (not (lista(estado mutando)))
        =>
        (pop-focus)
)