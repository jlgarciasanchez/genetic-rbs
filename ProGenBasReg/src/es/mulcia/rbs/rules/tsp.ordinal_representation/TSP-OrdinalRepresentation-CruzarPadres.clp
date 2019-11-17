; TSP-OrdinalRepresentation-CruzarPadres.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que crea un pivote con un númro aleatorio entre el tamaño mínimo va a tener cada trozo
; y el número total de elementos menos ese tamaño mínimo. Además inicializa la lista del hijo, el iterador
; y crea una copia de los padres.
(defrule CruzarPadres::Inicializacion
        (p ?p)
        (tamanyo-minimo-cruce ?tcm)
        (nHijos (n ?nH))
        (not (lista (estado hijo-actual)))
        ?padreA <- (lista (estado padreA))
        ?padreB <- (lista (estado padreB))
        =>
        (assert (pivote (+ (mod (random) (- ?p (* ?tcm 2))) ?tcm)))
        (assert (lista (estado hijo-actual)(id ?nH)(esfuerzo 0)))
        (assert (iter (n 0)))
        (duplicate ?padreA (estado tempA))
        (duplicate ?padreB (estado tempB))
)

; Regla que elimina el primer elemento de la copia de los padres e inserta el del padreA en el hijo.
; Esta regla se dispara mientras el iterador sea menor que el pivote.
(defrule CruzarPadres::Anadir-hijos
        ?iter <- (iter (n ?n))
        (pivote ?p)
        ?tempA <- (lista (estado tempA) (datos ?A $?restA))
        ?tempB <- (lista (estado tempB) (datos ? $?restB))
        ?hijo <- (lista (estado hijo-actual) (datos $?datos-hijo))
        (test (< ?n ?p))
        =>
        (modify ?tempA (datos $?restA))
        (modify ?tempB (datos $?restB))
        (modify ?hijo (datos $?datos-hijo ?A))
        (modify ?iter (n (+ ?n 1)))
)

; Regla que introduce en el hijo los elementos restantes de la copia del padreB.
; Elimina las copias de los padres, el iterador y el pivote.
(defrule CruzarPadres::Finalizar
        ?tempA <- (lista (estado tempA) (datos $?))
        ?tempB <- (lista (estado tempB) (datos $?datos))
        ?hijo <- (lista (estado hijo-actual) (datos $?datos-hijo))
        ?pivote <- (pivote ?p)
        ?iter <- (iter (n ?p))
        =>
        (modify ?hijo (datos $?datos-hijo $?datos))
        (retract ?tempA)
        (retract ?tempB)
        (retract ?pivote)
        (retract ?iter)
)

