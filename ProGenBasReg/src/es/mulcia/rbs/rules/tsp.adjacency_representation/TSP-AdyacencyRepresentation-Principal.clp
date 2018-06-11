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

; Plantilla que se utiliza para el contador de hijos generados en cada iteración.
(deftemplate nHijos
        (slot n)
)

;============================================================================

; Regla que inicia el flujo del algoritmo, calcula p e invoca al módulo inicializacion.
(defrule Inicio
        ?inicio <- (inicio)
        =>
        (assert (iteracion (n 0)))
        (retract ?inicio)
        (focus Inicializacion)
)