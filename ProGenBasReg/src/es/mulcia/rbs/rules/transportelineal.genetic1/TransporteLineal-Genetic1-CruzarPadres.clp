; TransporteLineal-Genetic1-CruzarPadres.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Plantilla que almacena la posición de los pivotes con los que "se trocea" cada lista.
(deftemplate CruzarPadres::pivote
        (slot id)
        (slot valor)
)

;============================================================================

; Regla que inicializa el valor de los dos pivotes, con un número aleatorio entre 0 y p-1.
(defrule CruzarPadres::Obtener-pivotes
        (p ?p)
        (not (pivote))
        =>
        (assert (pivote (id 0) (valor (mod (random) ?p))))
        (assert (pivote (id 1) (valor (mod (random) ?p))))
)

; Regla que se dispara cuando el valor de los pivotes es distinto.
; Genera una lista hijoA con el valor central de la lista del padreA.
(defrule CruzarPadres::Cruce-genes-padreA-distinto
        (pivote (valor ?inicio))
        (pivote (valor ?fin))
        ?padre <- (lista (estado padreA)(datos $?izquierda ?inicio $?centro ?fin $?derecha))
        =>
        (duplicate ?padre (estado hijoA)(datos / ?inicio $?centro ?fin)(esfuerzo 0))
        (modify ?padre (datos $?izquierda / $?derecha))       
)

; Regla que se dispara cuando el valor de los pivotes es igual.
; Genera una lista hijoA con el valor central de la lista del padreA.
(defrule CruzarPadres::Cruce-genes-padreA-igual
        (pivote (id 0)(valor ?centro))
        (pivote (id 1)(valor ?centro))
        ?padre <- (lista (estado padreA)(datos $?izquierda ?centro $?derecha))
        =>
        (duplicate ?padre (estado hijoA)(datos / ?centro)(esfuerzo 0))
        (modify ?padre (datos $?izquierda / $?derecha))       
)

; Regla que se activa cuando el primer elemento del padreB ya está en el hijo.
; Se elimina dicho elemento.
(defrule CruzarPadres::Cruce-no-anadir
        ?padre <- (lista (estado padreB) (datos ?primerElemento $?restoElementos))
        (lista (estado hijoA) (datos $? ?primerElemento $?))
        =>
        (modify ?padre (datos $?restoElementos))   
)

; Regla se activa para añadir el primer elemento del padreB a la parte izquierda del hijoA.
; Se elimina el primer elemento del padreB para poder añadir el siguiente y el del padre A para llevar la cuenta.
(defrule CruzarPadres::Cruce-anadir-izquierda
        ?padreA <- (lista (estado padreA) (datos ? $?restoIzq / $?restoDer))
        ?padreB <- (lista (estado padreB) (datos ?primerElemento $?restoElementos))
        ?hijo <- (lista (estado hijoA) (datos $?elementosIzq / $?elementosDer))
        (not (lista (estado hijoA) (datos $? ?primerElemento $?)))
        =>
        (modify ?padreA (datos $?restoIzq / $?restoDer))
        (modify ?padreB (datos $?restoElementos)) 
        (modify ?hijo (datos $?elementosIzq ?primerElemento / $?elementosDer)) 
)

; Regla que se dispara cuando se han eliminado todos los elementos de la parte izquierda del padreA. Se elimina el padreA.
(defrule CruzarPadres::Cruce-transicion-izqder
        ?padreA <- (lista (estado padreA) (datos / $?elementosPadre))
        ?hijo <- (lista (estado hijoA) (datos $?elementosI / $?elementosD))
        =>
        (retract ?padreA)
        (modify ?hijo (datos $?elementosI $?elementosD))
)

; Regla se activa para añadir el primer elemento del padreB a la parte izquierda del hijoA. Se elimina el primer elemento del padreB.
(defrule CruzarPadres::Cruce-anadir-derecha
        (not (lista (estado padreA)))
        ?padreB <- (lista (estado padreB) (datos ?primerElemento $?restoElementos))
        ?hijo <- (lista (estado hijoA) (datos $?elementos))
        (not (lista (estado hijoA) (datos $? ?primerElemento $?)))
        =>
        (modify ?padreB (datos $?restoElementos)) 
        (modify ?hijo (datos $?elementos ?primerElemento))      
)

; Regla que pone fin a la ejecución del módulo. Se eliminan los pivotes y el padreB.
(defrule CruzarPadres::Finalizar
        (not (lista (estado padreA)))
        ?pivote0 <- (pivote (id 0))
        ?pivote1 <- (pivote (id 1))
        ?padreB <- (lista (estado padreB) (datos))
        =>
        (retract ?padreB)
        (retract ?pivote0)
        (retract ?pivote1)
        (pop-focus)
)