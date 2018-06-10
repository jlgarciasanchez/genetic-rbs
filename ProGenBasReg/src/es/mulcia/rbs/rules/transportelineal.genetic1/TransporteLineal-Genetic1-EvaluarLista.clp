; TransporteLineal-Genetic1-EvaluarLista.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================


; Plantilla que se usa para almacenar los elementos ya evaludos.
(deftemplate EvaluarLista::listaTemp
        (multislot datos)
)

;============================================================================

;Todas estas reglas actúan sobre la lista "actual" seleccionada en el módulo "Evaluacion".

; Regla que genera una listaTemp
(defrule EvaluarLista::Inicializar
        (not(listaTemp))
        (lista (estado actual))
        =>
        (assert (listaTemp))
)

; Regla que Coge el primer elemento de la lista y lo almacena en q y en la lista temporal.
(defrule EvaluarLista::Seleccionar-qElemento
        ?list <- (lista (estado actual)(datos ?q $?resto))
        ?temp <- (listaTemp (datos $?inicio))
        (not (q ?))
        =>
        (assert (q ?q))
        (modify ?temp (datos $?inicio ?q))
        (modify ?list (datos $?resto))
)

; Regla que calcula i y j en función de q.
(defrule EvaluarLista::Calcular-valor-bidimensional
        (q ?q)
        (k ?k)
        =>
        (assert (i (div ?q ?k)))
        (assert (j (mod ?q ?k)))
)

; Regla que calcula la cantida de mercancia utilizando i y j.
(defrule EvaluarLista::Calcular-cantidad-mercancia
        (i ?i)
        (j ?j)
        (fuente (id ?i) (mercancia-actual ?f))
        (destino (id ?j) (mercancia-actual ?d))
        =>
        (assert (mercancia (min ?d ?f)))
)

; Regla que actualiza el esfuerzo de la lista y la mercancia-actual. 
; Además elimina las variables temporales.
(defrule EvaluarLista::Actualizar-valores
        ?qu <- (q ?)
        ?vi <- (i ?i)
        ?vj <- (j ?j)
        ?mercancia <- (mercancia ?v)
        ?list <- (lista (estado actual)(esfuerzo ?et))
        ?fuente <- (fuente (id ?i) (mercancia-actual ?f))
        ?destino <- (destino (id ?j) (mercancia-actual ?d))
        (esfuerzo (fuente ?i)(destino ?j)(esfuerzo ?e))
        =>
        (modify ?list (esfuerzo (+ ?et (* ?v ?e))))
        (modify ?fuente (mercancia-actual (- ?f ?v)))
        (modify ?destino (mercancia-actual (- ?d ?v)))
        (retract ?vi)
        (retract ?vj)
        (retract ?qu)
        (retract ?mercancia)
)

;;Regla que de dispara cuando el módulo ha finalizado. Pasa los datos de la lista temporal a la lista.
(defrule EvaluarLista::Finalizar
        (not (q ?))
        ?list <- (lista (estado actual)(datos))
        ?temp <- (listaTemp (datos $?datos))
        =>
        (modify ?list (estado evaluada)(datos $?datos))
        (retract ?temp)
)

