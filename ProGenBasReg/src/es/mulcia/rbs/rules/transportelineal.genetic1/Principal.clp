; Principal.clp
; Problema del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; Universidad de Sevilla
;============================================================================

; Plantilla que se utiliza para almacenar los datos de cada solución.
(deftemplate lista
        (slot id)
        (multislot datos)
        (slot esfuerzo)
        (slot estado)
)

; Plantilla que se utiliza para almacenar el esfuerzo de cada par fuente-destino.
(deftemplate esfuerzo
        (slot fuente)
        (slot destino)
        (slot esfuerzo)
)

; Plantilla que se utiliza para almacenar los datos de las fuentes.
(deftemplate fuente
        (slot id)
        (slot mercancia-total)
        (slot mercancia-actual)
)

; Plantilla que se utiliza para almacenar los datos de los destinos.
(deftemplate destino
        (slot id)
        (slot mercancia-total)
        (slot mercancia-actual)
)

; Plantilla que se utiliza para el contador de iteraciones.
(deftemplate iteracion
        (slot n)
)

; Plantilla que se utiliza para el contador de hijos generados en cada iteración.
(deftemplate nHijos
        (slot n)
)

;============================================================================

; Regla que inicia el flujo del algoritmo, calcula p e invoca al módulo inicializacion.
(defrule Inicio
        (not (p ?))
        (n ?n)
        (k ?k)
        =>
        (assert (p (* ?n ?k)))
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
        (modify ?hijos (n (+ ?h 2)))
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