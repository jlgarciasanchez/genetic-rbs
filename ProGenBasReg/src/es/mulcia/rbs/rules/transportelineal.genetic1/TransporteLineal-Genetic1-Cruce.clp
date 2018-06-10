; TransporteLineal-Genetic1-Cruce.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que marca a uno de los padres como padreA para realizar el cruce.
; Se crea una copia pendiente A, para poder engenderar el segundo hijo.
(defrule Cruce::Asignar-padreA
        (not (lista (estado padreA)))
        ?padre <- (lista (estado padre))
        =>
        (duplicate ?padre (estado padreA))
        (modify ?padre (estado pendienteA))
)

; Regla que marca al segundo padre como padreB y crea la copia pendiente B.
; Se invoca al módulo CruzarPadres.
(defrule Cruce::Asignar-padreB
        (lista (estado padreA))
        ?padre <- (lista (estado padre))
        =>
        (duplicate ?padre (estado padreB))
        (modify ?padre (estado pendienteB))
        (focus CruzarPadres)
)

; Regla que invierte los roles de los padres para engenderar el segundo hijo, el primero es renombrado como hijoB.
; Además se crea una copia de los padres para que vuelvan a formar parte de la población de cara a una nueva selección.
; Se invoca al módulo CruzarPadres.
(defrule Cruce::Engendrar-segundo-hijo
        ?pendienteA <- (lista (estado pendienteA))
        ?pendienteB <- (lista (estado pendienteB))
        ?hijo <- (lista (estado hijoA))
        =>
        (duplicate ?pendienteA (estado padreB))
        (duplicate ?pendienteB (estado padreA))
        (modify ?pendienteA (estado evaluada))
        (modify ?pendienteB (estado evaluada))
        (modify ?hijo (estado hijoB))
        (focus CruzarPadres)
)

; Regla que renombra a los hijos y pone fin a la ejecución del módulo.
(defrule Cruce::Finalizar
        ?hijoA <- (lista (estado hijoA))
        ?hijoB <- (lista (estado hijoB))
        =>
        (modify ?hijoA (estado hijo))
        (modify ?hijoB (estado hijo))
        (pop-focus)
)