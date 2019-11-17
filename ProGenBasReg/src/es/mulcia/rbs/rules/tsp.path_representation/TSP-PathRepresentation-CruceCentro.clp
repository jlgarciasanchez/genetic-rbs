; TSP-PathRepresentation-CruceCentro.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que inicializa el tamaño de los extremos entre el rango definido por el usuario.
; Se inicializan las dos soluciones hijas. Se crean copias de los padres.
; Se actualiza el contador de hijos y se iniializa un iterador.
(defrule CruceCentro::Inicializacion
        (not (tamanyo-extremos ?))
        (tamanyo-minimo-extremos ?min)
        (tamanyo-maximo-extremos ?max)
        ?padreA <- (lista (estado padreA))
        ?padreB <- (lista (estado padreB))
        ?nHijos <- (nHijos (n ?nH))
        =>
        (assert (tamanyo-extremos (+ (mod (random) (- ?max (- ?min 1))) ?min)))
        (assert (lista (estado hijoA)(id ?nH)(esfuerzo 0)))
        (assert (lista (estado hijoB)(id (+ ?nH 1))(esfuerzo 0)))
        (modify ?nHijos (n (+ ?nH 2)))
        (duplicate ?padreA (estado tempA)(datos))
        (duplicate ?padreB (estado tempB)(datos))
        (assert (iter (n 0)))
)

; Regla que se dispara mientras el iterador sea menor que el tamaño de los extremos.
; Se pasan los elementos de los padres a sus copias.
(defrule CruceCentro::Mover-izquierda
        ?padreA <- (lista (estado padreA) (datos ?a $?restA))
        ?padreB <- (lista (estado padreB) (datos ?b $?restB))
        ?tempA <- (lista (estado tempA) (datos $?restTA))
        ?tempB <- (lista (estado tempB) (datos $?restTB))
        ?iter <- (iter (n ?n))
        (tamanyo-extremos ?te)
        (test (< ?n ?te))
        =>
        (modify ?iter(n (+ ?n 1)))
        (modify ?padreA (datos $?restA))
        (modify ?padreB (datos $?restB))    
        (modify ?tempA (datos  $?restTA ?a))
        (modify ?tempB (datos  $?restTB ?b))
)

; Regla que se dispara cuando el iterador es igual que el tamaño de los extremos.
; Se empiezan a pasar los elementos de los padres a los hijos.
; Se coloca el símbolo / para marcar la posición.
(defrule CruceCentro::Transicion-izquierda-centro
        ?padreA <- (lista (estado padreA) (datos ?a $?restA))
        ?padreB <- (lista (estado padreB) (datos ?b $?restB))
        ?hijoA <- (lista (estado hijoA))
        ?hijoB <- (lista (estado hijoB))
        ?tempA <- (lista (estado tempA) (datos $?restTA))
        ?tempB <- (lista (estado tempB) (datos $?restTB))
        ?iter <- (iter (n ?n))
        (tamanyo-extremos ?n)
        =>
        (modify ?iter(n (+ ?n 1)))
        (modify ?padreA (datos $?restA))
        (modify ?padreB (datos $?restB))
        (modify ?hijoA (datos / ?a))
        (modify ?hijoB (datos / ?b))
        (modify ?tempA (datos  $?restTA /))
        (modify ?tempB (datos  $?restTB /))
)

; Regla que se dispara cuando el iterador es mayor que el tamaño de los extremos y menor que
; p menos el tamaño de los extremos. Se pasan los elementos de los padres a sus hijos.
(defrule CruceCentro::Mover-centro
        (p ?p)
        ?padreA <- (lista (estado padreA) (datos ?a $?restA))
        ?padreB <- (lista (estado padreB) (datos ?b $?restB))
        ?hijoA <- (lista (estado hijoA)(datos $?restHA))
        ?hijoB <- (lista (estado hijoB)(datos $?restHB))
        ?iter <- (iter (n ?n))
        (tamanyo-extremos ?te)
        (test (> ?n ?te))
        (test (< ?n (- ?p ?te)))
        =>
        (modify ?iter(n (+ ?n 1)))
        (modify ?padreA (datos $?restA))
        (modify ?padreB (datos $?restB))
        (modify ?hijoA (datos $?restHA ?a))
        (modify ?hijoB (datos $?restHB ?b))
)

; Regla que se dispara cuando el iterador es igual que p menos el tamaño de los extremos.
; Se vuelven a pasar los elementos de los padres a sus copias.
; Se coloca el símbolo / para marcar la posición.
(defrule CruceCentro::Transicion-centro-derecha
        (p ?p)
        ?padreA <- (lista (estado padreA) (datos ?a $?restA))
        ?padreB <- (lista (estado padreB) (datos ?b $?restB))
        ?hijoA <- (lista (estado hijoA)(datos $?restHA))
        ?hijoB <- (lista (estado hijoB)(datos $?restHB))
        ?tempA <- (lista (estado tempA) (datos $?restTA))
        ?tempB <- (lista (estado tempB) (datos $?restTB))
        ?iter <- (iter (n ?n))
        (tamanyo-extremos ?te)
        (test (eq ?n (- ?p ?te)))
        =>
        (modify ?iter(n (+ ?n 1)))
        (modify ?padreA (datos $?restA))
        (modify ?padreB (datos $?restB))
        (modify ?hijoA (datos $?restHA /))
        (modify ?hijoB (datos $?restHB /))
        (modify ?tempA (datos  $?restTA ?a))
        (modify ?tempB (datos  $?restTB ?b))
)

; Regla que se dispara cuando el iterador es mayor que p menos el tamaño de los extremos.
; Se pasan los elementos de los padres a sus copias.
(defrule CruceCentro::Mover-derecha
        (p ?p)
        ?padreA <- (lista (estado padreA) (datos ?a $?restA))
        ?padreB <- (lista (estado padreB) (datos ?b $?restB))
        ?tempA <- (lista (estado tempA) (datos $?restTA))
        ?tempB <- (lista (estado tempB) (datos $?restTB))
        ?iter <- (iter (n ?n))
        (tamanyo-extremos ?te)
        (test (> ?n (- ?p ?te)))
        =>
        (modify ?iter(n (+ ?n 1)))
        (modify ?padreA (datos $?restA))
        (modify ?padreB (datos $?restB))    
        (modify ?tempA (datos  $?restTA ?a))
        (modify ?tempB (datos  $?restTB ?b))
)

; Regla que se dispara cuando el iterador es igual a p.
; Se elimina el tamaño de los extremos y el iterador.
(defrule CruceCentro::Finalizar
        (p ?p)
        ?te <- (tamanyo-extremos ?t)
        ?iter <- (iter (n ?p))
        =>
        (retract ?te)
        (retract ?iter)
        (pop-focus)
)