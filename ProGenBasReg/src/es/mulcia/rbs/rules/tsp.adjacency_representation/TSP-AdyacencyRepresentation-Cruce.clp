; TSP-AdyacencyRepresentation-Cruce.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que selecciona a un padre como padre-par.
(defrule Cruce::Asignar-padre-par
        (not (lista (estado hijo-actual)))
        ?padre <- (lista (estado padre))
        =>
        (modify ?padre (estado padre-par))
)

; Regla que selecciona al otro padre como padre-impar.
(defrule Cruce::Asignar-padre-impar
        (lista (estado padre-par))
        ?padre <- (lista (estado padre))
        =>
        (modify ?padre (estado padre-impar))
)

; Regla que llama al módulo CruceAEC.
; Se dispara cuando están los dos padres y el hecho AEC.
(defrule Cruce::Cruce-AEC
        (lista (estado padre-par))
        (lista (estado padre-impar))
        (not (lista (estado hijo-actual)))
        (AEC)
        =>
        (focus CruceAEC)
)

; Regla que llama al módulo CruceSCC.
; Se dispara cuando están los dos padres y el hecho SCC.
(defrule Cruce::Cruce-SCC
        (lista (estado padre-par))
        (lista (estado padre-impar))
        (not (lista (estado hijo-actual)))
        (SCC)
        =>
        (focus CruceSCC)
)

; Regla que invierte a los padres, renombra al primer hijo, actualiza el contador de hijos y llama al módulo CruceAEC.
; Se dispara cuando están los dos padres, un hijo y el hecho AEC.
(defrule Cruce::Segundo-cruce-AEC
        ?hijos <- (nHijos (n ?h))
        ?par <- (lista (estado padre-par))
        ?impar <- (lista (estado padre-impar))
        ?hijo <- (lista (estado hijo-actual))
        (AEC)
        =>
        (modify ?hijos (n (+ ?h 1)))
        (modify ?par (estado padre-impar))
        (modify ?impar (estado padre-par))
        (modify ?hijo (estado primer-hijo))
        (focus CruceAEC)
)

; Regla que invierte a los padres, renombra al primer hijo, actualiza el contador de hijos y llama al módulo CruceSCC.
; Se dispara cuando están los dos padres, un hijo y el hecho SCC.
(defrule Cruce::Segundo-cruce-SCC
        ?hijos <- (nHijos (n ?h))
        ?par <- (lista (estado padre-par))
        ?impar <- (lista (estado padre-impar))
        ?hijo <- (lista (estado hijo-actual))
        (SCC)
        =>
        (modify ?hijos (n (+ ?h 1)))
        (modify ?par (estado padre-impar))
        (modify ?impar (estado padre-par))
        (modify ?hijo (estado primer-hijo))
        (focus CruceSCC)
)

; Regla que cambia el estado de padres e hijos y actualiza el contador de hijos.
; Se dispara cuando están los dos padres y los dos hijos.
(defrule Cruce::Finalizar
        ?hijos <- (nHijos (n ?h))
        ?par <- (lista (estado padre-par))
        ?impar <- (lista (estado padre-impar))
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