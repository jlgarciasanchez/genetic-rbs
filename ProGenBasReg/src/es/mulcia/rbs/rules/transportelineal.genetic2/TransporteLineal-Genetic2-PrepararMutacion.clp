; TransporteLineal-Genetic1-PrepararMutacion.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================


; Regla que selecciona una fila y una columna aleatoria como fila y columna inicial de la submatriz.
; Los valores de la fila y columna inicio deben permitir que la totalidad de la submatriz quede
; comprendida dentro de las dimensiones de la matriz.
(defrule PrepararMutacion::Inicio
        (tamanyo-mutacion ?tm)
        (not (columnaInicio ?))
        (k ?k)
        (n ?n)
        =>
        (assert (columnaInicio (mod (random) (- ?n (- ?tm 1)))))
        (assert (filaInicio (mod (random) (- ?k (- ?tm 1)))))
)

; Regla que calcula los valores de la fila y columna final en función de la fila y columna inicial.
(defrule PrepararMutacion::Agregar-fin
        (tamanyo-mutacion ?tm)
        (not (columnaFin ?))
        (columnaInicio ?ci)
        (filaInicio ?fi)
        =>
        (assert (columnaFin (+ ?ci (- ?tm 1))))
        (assert (filaFin (+ ?fi (- ?tm 1))))
)

; Regla que añade un subdestino.
(defrule PrepararMutacion::Agregar-subdestino
        (filaInicio ?fi)
        (filaFin ?ff)
        (fila (fila ?f))
        (test (>= ?f ?fi))
        (test (<= ?f ?ff))
        (not (MutarElemento::subdestino (idViejo ?f)))
        =>
        (assert (MutarElemento::subdestino (idNuevo (- ?f ?fi))(idViejo ?f)(mercancia 0)))
)

; Regla que añade una subfuente.
(defrule PrepararMutacion::Agregar-subfuente
        (columnaInicio ?ci)
        (columnaFin ?cf)
        (fila (datos $? / ?c $?))
        (test (>= ?c ?ci))
        (test (<= ?c ?cf))
        (not (MutarElemento::subfuente (idViejo ?c)))
        =>
        (assert (MutarElemento::subfuente (idNuevo (- ?c ?ci))(idViejo ?c)(mercancia 0)))
)

; Regla que añade la cantidad de mercancia de un elemento a su subfila y subcolumna.
; Se cambia el estado del elemento de P a M.
(defrule PrepararMutacion::Rellenar-subfuente-subdestino
        (solucion (id ?id)(estado mutando))
        ?subfuente <- (MutarElemento::subfuente (idViejo ?c)(mercancia ?mf))
        ?subdestino <- (MutarElemento::subdestino (idViejo ?f)(mercancia ?md))
        ?fila <- (fila (idSolucion ?id) (fila ?f) (datos $?der / ?c ?mer P $?izq))
        =>
        (modify ?subfuente (mercancia (+ ?mf ?mer)))
        (modify ?subdestino (mercancia (+ ?md ?mer)))
        (modify ?fila (datos $?der / ?c ?mer M $?izq))
)