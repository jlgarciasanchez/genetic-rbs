; TransporteLineal-Genetic2-RealizarMutacion.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

;Todas estas reglas actúan sobre la lista "actual" seleccionada en el módulo "MutarElemento".

; Regla que coge el primer elemento de la lista y lo almacena en q.
(defrule RealizarMutacion::Seleccionar-qElemento
        ?list <- (lista (estado actual)(datos ?q $?resto))
        (not (q ?))
        =>
        (assert (q ?q))
        (modify ?list (datos $?resto))
)

; Regla que calcula i y j en función de q.
(defrule RealizarMutacion::Calcular-valor-bidimensional
        (q ?q)
        (k ?k)
        =>
        (assert (i (div ?q ?k)))
        (assert (j (mod ?q ?k)))
)

; Regla que calcula la cantida de mercancia utilizando i y j.
(defrule RealizarMutacion::Calcular-cantidad-mercancia
        (lista (id ?id)(estado actual))
        (i ?i)
        (j ?j)
        (MutarElemento::subfuente (idNuevo ?i) (mercancia ?f))
        (MutarElemento::subdestino (idNuevo ?j) (mercancia ?d))
        (not (fila (idSolucion ?id)(fila ?j)(datos $? / ?i $?)))
        =>
        (assert (mercancia (min ?d ?f)))
)

; Regla que crea una nueva fila si al fila i no existe.
(defrule RealizarMutacion::Crear-fila
        (lista (id ?id)(estado actual))
        (j ?j)
        (not (fila (idSolucion ?id)(fila ?j)))
        =>
        (assert (fila (idSolucion ?id)(fila ?j)))
)

; Regla que rellena la fila de la una solucion.
(defrule RealizarMutacion::Rellenar-fila
        (lista (id ?id)(estado actual))
        ?q <- (q ?)
        ?j2 <- (j ?j)
        ?i2 <- (i ?i)
        ?fuente <- (MutarElemento::subfuente (idNuevo ?i) (mercancia ?f))
        ?destino <- (MutarElemento::subdestino (idNuevo ?j) (mercancia ?d))
        ?mercancia2 <- (mercancia ?mercancia)
        ?fila <- (fila (idSolucion ?id)(fila ?j)(datos $?datos))
        =>
        (modify ?fila (datos $?datos / ?i ?mercancia P))
        (modify ?fuente (mercancia (- ?f ?mercancia)))
        (modify ?destino (mercancia (- ?d ?mercancia)))
        (retract ?q)
        (retract ?i2)
        (retract ?j2)
        (retract ?mercancia2)
)

; Regla que borra la lista-actual.
(defrule RealizarMutacion::Borrar-lista
        (not (q ?))
        ?list <- (lista (estado actual)(datos))
        =>
        (retract ?list)
)

; Regla que introduce los elementos de de la submatriz dentro de la matriz.
(defrule RealizarMutacion::Modificar-elemento
        (MutarElemento::subfuente (idNuevo ?columnaNueva) (idViejo ?columnaVieja))
        (MutarElemento::subdestino (idNuevo ?filaNueva) (idViejo ?filaVieja))
        ?filaMutando <- (fila (fila ?filaVieja) (datos $?der / ?columnaVieja ? M $?izq))
        ?filaAux <- (fila (idSolucion -2) (fila ?filaNueva)(datos $?der2 / ?columnaNueva ?mercancia P $?izq2))
        =>
        (modify ?filaMutando (datos $?der / ?columnaVieja ?mercancia P $?izq))
        (modify ?filaAux (datos $?der2 $?izq2))
)



