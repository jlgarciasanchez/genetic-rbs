; TSP-OrdinalRepresentation-Cruce.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que selecciona a un padre como padreA.
(defrule Cruce::Asignar-padreA
        (not (lista (estado hijo-actual)))
        ?padre <- (lista (estado padre))
        =>
        (modify ?padre (estado padreA))
)

; Regla que selecciona al otro padre como padreB.
(defrule Cruce::Asignar-padreB
        (lista (estado padreA))
        ?padre <- (lista (estado padre))
        =>
        (modify ?padre (estado padreB))
)

; Regla que llama al módulo CruzarPadres
(defrule Cruce::Cruce
        (lista (estado padreA))
        (lista (estado padreB))
        (not (lista (estado hijo-actual)))
        =>
        (focus CruzarPadres)
)

; Regla que invierte a los padres, renombra al primer hijo, actualiza el contador de hijos y llama al módulo CruzarPadres.
(defrule Cruce::Segundo-cruce
        ?hijos <- (nHijos (n ?h))
        ?par <- (lista (estado padreA))
        ?impar <- (lista (estado padreB))
        ?hijo <- (lista (estado hijo-actual))
        =>
        (modify ?hijos (n (+ ?h 1)))
        (modify ?par (estado padreB))
        (modify ?impar (estado padreA))
        (modify ?hijo (estado primer-hijo))
        (focus CruzarPadres)
)

; Regla que cambia el estado de padres e hijos y actualiza el contador de hijos.
; Se dispara cuando están los dos padres y los dos hijos.
(defrule Cruce::Finalizar
        ?hijos <- (nHijos (n ?h))
        ?par <- (lista (estado padreA))
        ?impar <- (lista (estado padreB))
        ?hijoA <- (lista (estado hijo-actual))
        ?hijoB <- (lista (estado primer-hijo))
        =>
        (modify ?hijos (n (+ ?h 1)))
        (modify ?par (estado evaluada))
        (modify ?impar (estado evaluada))
        (modify ?hijoA (estado hijo))
        (modify ?hijoB (estado hijo))
        (pop-focus)
)