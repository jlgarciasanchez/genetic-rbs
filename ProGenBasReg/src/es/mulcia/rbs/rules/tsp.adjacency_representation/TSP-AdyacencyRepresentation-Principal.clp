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