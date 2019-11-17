; TSP-OrdinalRepresentation-EvaluarLista.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que crea una copia de la lista actual y de las ciudades sin el primer elemento.
; Y coloca el origen con el valor del primer elemento. El primer elemenot siempre será 0.
(defrule EvaluarLista::Inicio
        (not (origen ?))
        ?list <- (lista (estado actual)(datos 0 $?datos))
        ?ciu <- (lista (estado ciudades) (datos 0 $?ciudades))
        =>
        (duplicate ?list (estado evaluando)(datos $?datos))
        (duplicate ?ciu (estado ciudades-actual)(datos $?ciudades))
        (assert (origen 0))
)

; Regla que extrae el primer elemento e la lista evaluando. Inicializa un iterado
; y crea una copia de la copia de ciudades.
(defrule EvaluarLista::Selecciona-elemento
        ?list <- (lista (estado evaluando) (datos ?elemento $?otros))
        ?ciudades <- (lista (estado ciudades-actual))
        (not (elemento ?))
        =>
        (duplicate ?ciudades (estado ciudades-iteracion-actual))
        (modify ?list (datos $?otros))
        (assert (elemento ?elemento))
        (assert (iter (n 0)))
)

; Regla que va eliminando las ciudades de la copia de la copia de ciuades hasta que
; el iterador tenga el valor del elemento.
(defrule EvaluarLista::Contar-posicion
        ?ciudades <- (lista (estado ciudades-iteracion-actual) (datos ? $?otras))
        ?iter <- (iter (n ?n))
        (elemento ?elemento)
        (test (neq ?n ?elemento))
        =>
        (modify ?ciudades (datos $?otras))
        (modify ?iter (n (+ ?n 1)))
)

; Regla que se dispara cuando el iterador tiene el mismo valor que el elemento.
; La siguiente ciudad a visitar es la primera de la copia de la copia de ciudades.
; Se suma al esfuerzo de la lista el esfuerzo de ir del origen a la siguiente ciudad.
; Se elimina esta ciudad de la copia de ciudades y se fija como nuevo origen.
; Se eliminan el iterador, la copia de a copia de ciudades, el elemento y el antiguo origen.
(defrule EvaluarLista::Calcular-esfuerzo-ij
        ?ciudadesiter <- (lista (estado ciudades-iteracion-actual) (datos ?j $?otras))
        ?iter <- (iter (n ?n))
        ?ele <- (elemento ?n)
        ?list <- (lista (estado actual) (esfuerzo ?esfTotal))
        ?ciudades <- (lista (estado ciudades-actual) (datos $?izq ?j $?der))
        ?origen <- (origen ?i)
        (esfuerzo (ciudadA ?i) (ciudadB ?j) (esfuerzo ?esfCamino))
        =>
        (modify ?list (esfuerzo (+ ?esfTotal ?esfCamino)))
        (modify ?ciudades (datos $?izq $?der))
        (retract ?ciudadesiter)
        (retract ?iter)
        (retract ?ele)
        (retract ?origen)
        (assert (origen ?j))
)

; Regla que se dispara cuando el iterador tiene el mismo valor que el elemento.
; La siguiente ciudad a visitar es la primera de la copia de la copia de ciudades.
; Se suma al esfuerzo de la lista el esfuerzo de ir de la siguiente ciudad al origen.
; Se elimina esta ciudad de la copia de ciudades y se fija como nuevo origen.
; Se eliminan el iterador, la copia de a copia de ciudades, el elemento y el antiguo origen.
(defrule EvaluarLista::Calcular-esfuerzo-ji
        ?ciudadesiter <- (lista (estado ciudades-iteracion-actual) (datos ?j $?otras))
        ?iter <- (iter (n ?n))
        ?ele <- (elemento ?n)
        ?list <- (lista (estado actual) (esfuerzo ?esfTotal))
        ?ciudades <- (lista (estado ciudades-actual) (datos $?izq ?j $?der))
        ?origen <- (origen ?i)
        (esfuerzo (ciudadA ?j) (ciudadB ?i) (esfuerzo ?esfCamino))
        =>
        (modify ?list (esfuerzo (+ ?esfTotal ?esfCamino)))
        (modify ?ciudades (datos $?izq $?der))
        (retract ?ciudadesiter)
        (retract ?iter)
        (retract ?ele)
        (retract ?origen)
        (assert (origen ?j))
)

; Regla que se dispara cuando se han visitado todas las ciudades.
; Se suma al esfuerzo de la lista el esfuerzo de ir desde 0 hasta el último origen.
; Se eliminan las copias de ciudades y de la lista y el origen.
(defrule EvaluarLista::Finalizar
        ?list <- (lista (estado actual) (esfuerzo ?esfTotal))
        ?eva <- (lista (estado evaluando)(datos))
        ?ciu <- (lista (estado ciudades-actual)(datos))
        ?origen <- (origen ?o)
        (esfuerzo (ciudadA 0) (ciudadB ?o) (esfuerzo ?esfCamino))
        =>
        (modify ?list (estado evaluada)(esfuerzo (+ ?esfTotal ?esfCamino)))
        (retract ?eva)
        (retract ?ciu)
        (retract ?origen)
        (pop-focus)
)