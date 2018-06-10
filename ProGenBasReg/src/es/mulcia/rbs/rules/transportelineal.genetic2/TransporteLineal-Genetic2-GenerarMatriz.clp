; TransporteLineal-Genetic2-GenerarMatriz.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

;Todas estas reglas actúan sobre la lista "actual" seleccionada en el módulo "Inicializacion".

; Regla que coge el primer elemento de la lista y lo almacena en q.
(defrule GenerarMatriz::Seleccionar-qElemento
        ?list <- (lista (estado actual)(datos ?q $?resto))
        (not (q ?))
        =>
        (assert (q ?q))
        (modify ?list (datos $?resto))
)

; Regla que calcula i y j en función de q.
(defrule GenerarMatriz::Calcular-valor-bidimensional
        (q ?q)
        (k ?k)
        =>
        (assert (i (div ?q ?k)))
        (assert (j (mod ?q ?k)))
)

; Regla que calcula la cantida de mercancia utilizando i y j.
(defrule GenerarMatriz::Calcular-cantidad-mercancia
        (lista (id ?id)(estado actual))
        (i ?i)
        (j ?j)
        (fuente (id ?i) (mercancia-actual ?f))
        (destino (id ?j) (mercancia-actual ?d))
        (not (fila (idSolucion ?id)(fila ?j)(datos $? / ?i $?)))
        =>
        (assert (mercancia (min ?d ?f)))
)

; Regla que crea una nueva fila si al fila i no existe.
(defrule GenerarMatriz::Crear-fila
        (lista (id ?id)(estado actual))
        (j ?j)
        (not (fila (idSolucion ?id)(fila ?j)))
        =>
        (assert (fila (idSolucion ?id)(fila ?j)))
)

; Regla que rellena la fila de la una solucion.
(defrule GenerarMatriz::Rellenar-fila
        (lista (id ?id)(estado actual))
        ?q <- (q ?)
        ?j2 <- (j ?j)
        ?i2 <- (i ?i)
        ?fuente <- (fuente (id ?i) (mercancia-actual ?f))
        ?destino <- (destino (id ?j) (mercancia-actual ?d))
        ?mercancia2 <- (mercancia ?mercancia)
        ?fila <- (fila (idSolucion ?id)(fila ?j)(datos $?datos))
        =>
        (modify ?fila (datos $?datos / ?i ?mercancia P))
        (modify ?fuente (mercancia-actual (- ?f ?mercancia)))
        (modify ?destino (mercancia-actual (- ?d ?mercancia)))
        (retract ?q)
        (retract ?i2)
        (retract ?j2)
        (retract ?mercancia2)
)

;Regla que de dispara cuando el módulo ha finalizado. Borra la lista actual.
(defrule GenerarMatriz::Finalizar
        (not (q ?))
        ?list <- (lista (estado actual)(datos))
        =>
        (retract ?list)
)

