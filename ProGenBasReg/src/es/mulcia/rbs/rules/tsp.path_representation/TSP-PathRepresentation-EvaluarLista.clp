; TSP-PathRepresentation-EvaluarLista.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que crea una copia de la lista actual y de las ciudades sin el primer elemento.
; Y coloca el origen con el valor del primer elemento. El primer elemento siempre será 0.
(defrule EvaluarLista::Inicializar
        (not (origen ?))
        ?list <- (lista (estado actual)(datos 0 $?datos))
        =>
        (duplicate ?list (estado evaluando)(datos $?datos))
        (assert (origen 0))
)

; Regla que se dispara cuando existe un camino entre la ciudad origen y la actual.
; Añade el esfuerzo de este camino a la lista actual.
; Elimina la ciudad actual de la lista evaluando y la sitúa como el nuevo origen.
; Elimina el antiguo origen.
(defrule EvaluarLista::Calcular-esfuerzo-ij
        ?list <- (lista (estado actual) (esfuerzo ?esfTotal))
        ?temp <- (lista (estado evaluando) (datos ?j $?datos))
        ?origen <- (origen ?i)
        (esfuerzo (ciudadA ?i) (ciudadB ?j) (esfuerzo ?esfCamino))
        =>
        (modify ?list (esfuerzo (+ ?esfTotal ?esfCamino)))
        (modify ?temp (datos $?datos))
        (retract ?origen)
        (assert (origen ?j))
)

; Regla que se dispara cuando existe un camino entre la ciudad actual y el origen.
; Añade el esfuerzo de este camino a la lista actual.
; Elimina la ciudad actual de la lista evaluando y la sitúa como el nuevo origen.
; Elimina el antiguo origen.
(defrule EvaluarLista::Calcular-esfuerzo-ji
        ?list <- (lista (estado actual) (esfuerzo ?esfTotal))
        ?temp <- (lista (estado evaluando) (datos ?j $?datos))
        ?origen <- (origen ?i)
        (esfuerzo (ciudadA ?j) (ciudadB ?i) (esfuerzo ?esfCamino))
        =>
        (modify ?list (esfuerzo (+ ?esfTotal ?esfCamino)))
        (modify ?temp (datos $?datos))
        (retract ?origen)
        (assert (origen ?j))
)

; Regla que se dispara cuando se han visitado todas las ciudades.
; Se suma al esfuerzo de la lista el esfuerzo de ir desde 0 hasta el último origen.
; Se cambia el estado de la ciudad actual a evaluada.
; Se elimina el último origen y la lista evaluando.
(defrule EvaluarLista::Finalizar
        ?list <- (lista (estado actual) (esfuerzo ?esfTotal))
        ?eva <- (lista (estado evaluando)(datos))
        ?origen <- (origen ?o)
        (esfuerzo (ciudadA 0) (ciudadB ?o) (esfuerzo ?esfCamino))
        =>
        (modify ?list (estado evaluada)(esfuerzo (+ ?esfTotal ?esfCamino)))
        (retract ?eva)
        (retract ?origen)
        (pop-focus)
)