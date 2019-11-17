; TSP-PathRepresentation-Cruce.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que crea copia de los padres, cambia su estado a evaluada e invoca al módulo CruceCX.
(defrule Cruce::CruceCX
        ?padreA <- (lista (id ?idA)(estado padre))
        ?padreB <- (lista (id ?idB)(estado padre))
        (test (neq ?idA ?idB))
        (CX)
        =>
        (modify ?padreA (estado evaluada))
        (modify ?padreB (estado evaluada))
        (duplicate ?padreA(estado padreA))
        (duplicate ?padreB(estado padreB))
        (focus CruceCX)
)

; Regla que crea copia de los padres, cambia su estado a evaluada e invoca al módulo CruceCentro.
(defrule Cruce::CruceCentroOX
        ?padreA <- (lista (id ?idA)(estado padre))
        ?padreB <- (lista (id ?idB)(estado padre))
        (test (neq ?idA ?idB))
        (OX)
        =>
        (modify ?padreA (estado evaluada))
        (modify ?padreB (estado evaluada))
        (duplicate ?padreA(estado padreA))
        (duplicate ?padreB(estado padreB))
        (assert (OX2))
        (focus CruceCentro)
)

; Regla que invoca al módulo CruceOX.
(defrule Cruce::CruceOX
        (OX)
        ?OX2 <- (OX2)
        =>
        (retract ?OX2)
        (focus CruceOX)
)

; Regla que crea copia de los padres, cambia su estado a evaluada e invoca al módulo CruceCentro.
(defrule Cruce::CruceCentroPMX
        ?padreA <- (lista (id ?idA)(estado padre))
        ?padreB <- (lista (id ?idB)(estado padre))
        (test (neq ?idA ?idB))
        (PMX)
        =>
        (modify ?padreA (estado evaluada))
        (modify ?padreB (estado evaluada))
        (duplicate ?padreA(estado padreA))
        (duplicate ?padreB(estado padreB))
        (assert (PMX2))
        (focus CruceCentro)
)

; Regla que invoca al módulo CrucePMX.
(defrule Cruce::CrucePMX
        (PMX)
        ?PMX2 <- (PMX2)
        =>
        (retract ?PMX2)
        (focus CrucePMX)
)