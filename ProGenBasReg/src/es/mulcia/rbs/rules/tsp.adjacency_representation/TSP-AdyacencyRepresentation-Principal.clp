; TSP-AdyacencyRepresentation-Principal.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; Universidad de Sevilla
;============================================================================

; Plantilla que se utiliza para almacenar las listas aleatorias con las que se inicializan las soluciones.
(deftemplate lista
        (slot id)
        (multislot datos)
        (slot esfuerzo)
        (slot estado)
)

; Plantilla que se utiliza para almacenar el esfuerzo del trayecto de cada par de ciudades.
(deftemplate esfuerzo
        (slot ciudadA)
        (slot ciudadB)
        (slot esfuerzo)
)

; Plantilla que se utiliza para el contador de iteraciones.
(deftemplate iteracion
        (slot n)
)

; Plantilla que se utiliza para almacenar los datos de un iterador auxiliar.
(deftemplate iter
        (slot n)
)

; Plantilla que se utiliza para el contador de hijos generados en cada iteración.
(deftemplate nHijos
        (slot n)
)

;============================================================================

; Regla que inicia el flujo del algoritmo, calcula p e invoca al módulo inicializacion.
(defrule Inicio
        ?inicio <- (inicio)
        =>
        (retract ?inicio)
        (assert (iteracion (n 0)))   
        (assert (evaluacion))
        (focus Inicializacion)
)

; Regla que inicializa el contador de hijos e invoca al módulo de evaluación.
; Se dispara si no se ha alcanzado el máximo de iteraciones.
(defrule Evaluacion
        (nIteraciones ?n)
        ?evaluacion <- (evaluacion)
        ?it <- (iteracion (n ?i))
        (test (< ?i ?n))
        =>
        (retract ?evaluacion)
        (assert (seleccion))
        (assert (nHijos (n 0)))
        (modify ?it (n (+ ?i 1)))
        (focus Evaluacion)
)

; Regla que invoca al módulo de selección. Se dispara si no se ha alcanzado el máximo de hijos.
(defrule Seleccion
        (nElementos ?n)
        ?hijos <- (nHijos (n ?h))
        ?seleccion <- (seleccion)
        (test (< ?h ?n))
        =>
        (retract ?seleccion)
        (assert (cruce))
        (focus Seleccion)
)

; Regla que invoca al módulo de cruce.
(defrule Cruce
        ?cruce <- (cruce)
        =>
        (retract ?cruce)
        (assert (seleccion))
        (focus Cruce)
)

; Regla que se dispara cuando se alcanza el máximo de hijos en una iteración y permite que continue el flujo.
(defrule Fin-Seleccion
        (nElementos ?n)
        ?hijos <- (nHijos (n ?h))
        ?seleccion <- (seleccion)
        (test (= ?n ?h))
        =>
        (retract ?seleccion)
        (retract ?hijos)
        (assert (mutacion))
)

; Regla que invoca al módulo de mutación.
(defrule Mutacion
        ?mutacion <- (mutacion)
        =>
        (retract ?mutacion)
        (assert (evaluacion))
        (focus Mutacion)
)

; Regla que invoca al módulo de evaluación y se prepara para finalizar la ejecución del algoritmo.
; Se dispara cuando se alcanza el máximo de iteraciones.
(defrule Fin-Evaluacion
        (nIteraciones ?n)
        ?evaluacion <- (evaluacion)
        ?it <- (iteracion (n ?i))
        (test (= ?i ?n))
        =>
        (retract ?evaluacion)
        (assert (final))
        (retract ?it)
        (focus Evaluacion)
)

; Regla que elimina todas las listas de la población menos la mejor.
(defrule Borrar-listas
        ?list <- (lista (estado evaluada))
       (final)
        =>
       (retract ?list)
)

; Regla que pone fin a la ejecución del algoritmo.
(defrule Finalizar
        ?final <- (final)
        =>
        (retract ?final)
)