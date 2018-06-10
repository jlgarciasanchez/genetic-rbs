; TransporteLineal-Genetic1-MutarElemento.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Plantilla que almacena la información de las columnas de la submatriz.
(deftemplate MutarElemento::subfuente
        (slot idNuevo)
        (slot idViejo)
        (slot mercancia)
)

; Plantilla que almacena la información de las filas de la submatriz.
(deftemplate MutarElemento::subdestino
        (slot idNuevo)
        (slot idViejo)
        (slot mercancia)
)

;============================================================================

; Regla que invoca al módulo PrepararMutacion.
(defrule MutarElemento::Inicio
        (solucion (estado mutando))
        (not (columnaInicio ?))
        =>
        (focus PrepararMutacion)
)

; Regla que modifica P y K, almacena una copia para poder restaurar el valor original.
; Invoca al módulo GenerarLista.
(defrule MutarElemento::Generar-lista
        (tamanyo-mutacion ?tm)
        (PrepararMutacion::columnaInicio ?ci)
        (PrepararMutacion::columnaFin ?cf)
        (PrepararMutacion::filaInicio ?fi)
        (PrepararMutacion::filaFin ?ff)
        (not (oldP ?))
        ?p <- (p ?pvalue)
        ?k <- (k ?kvalue)
        =>
        (assert (oldP ?pvalue))
        (assert (oldK ?kvalue))
        (retract ?p)
        (retract ?k)
        (assert (p (* (+ (- ?cf ?ci) 1) (+ (- ?ff ?fi) 1))))
        (assert (k ?tm))
        (focus GenerarLista)
)

; Regla que invoca al módulo DesordenarLista.
(defrule MutarElemento::Desordenar-lista
        ?list <- (lista (estado ordenada))
        =>
        (modify ?list (id -2)(estado desordenando))
        (focus DesordenarLista)
)

; Regla que invoca al módulo RealizarMutacion.
; Se cambia el estado de la solucion de mutando a lista y de la lista de pendiente a actual.
(defrule MutarElemento::Realizar-mutacion
        ?solucion <- (solucion (estado mutando))
        ?list <- (lista (id ?id) (estado pendiente))
        =>
        (modify ?list (estado actual))
        (modify ?solucion (estado lista))
        (focus RealizarMutacion)
)

; Regla que borra las filas de la submatriz.
(defrule MutarElemento::Borrar-filas
        ?filaAux <- (fila(idSolucion -2)(datos))
        =>
        (retract ?filaAux)
)

; Regla que borra los subdestinos.
(defrule MutarElemento::Borrar-subdestinos
        (not (solucion (estado mutando)))
        ?subdestino <- (subdestino)
        =>
        (retract ?subdestino)
)

; Regla que borra las subfuentes.
(defrule MutarElemento::Borrar-subfuentes
        (not (solucion (estado mutando)))
        ?subfuente <- (subfuente)
        =>
        (retract ?subfuente)
)

; Regla que vuelve a fijar el P y K anteriores y borra todas las variables temporales.
(defrule MutarElemento::Finalizar
        (not (solucion (estado mutando)))
        (not (subdestino))
        (not (subfuente))
        ?ci <- (PrepararMutacion::columnaInicio ?)
        ?fi <- (PrepararMutacion::filaInicio ?)
        ?cf <- (PrepararMutacion::columnaFin ?)
        ?ff <- (PrepararMutacion::filaFin ?)
        ?oldP <- (oldP ?pvalue)
        ?oldK <- (oldK ?kvalue)
        ?p <- (p ?)
        ?k <- (k ?)
        =>
        (retract ?ci)
        (retract ?fi)
        (retract ?cf)
        (retract ?ff)
        (retract ?oldP)
        (retract ?oldK)
        (retract ?p)
        (retract ?k)
        (assert (p ?pvalue))
        (assert (k ?kvalue))
        (pop-focus)
)