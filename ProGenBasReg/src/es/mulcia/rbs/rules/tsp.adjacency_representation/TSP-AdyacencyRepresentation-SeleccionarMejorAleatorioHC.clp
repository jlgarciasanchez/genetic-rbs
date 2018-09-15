; TSP-AdyacencyRepresentation-SeleccionarMejorAleatorioHC.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que si no existe ningún camino más cercano elige uno al azar.
(defrule SeleccionarMejorAleatorioHC::Inicio
        (not (mejor ? ?))
        (lista (estado subgrupo)(datos $? / ?newj ?newesf $?))
        (test (> ?newesf -1))
        =>
        (assert (mejor ?newj ?newesf))
)

; Regla que selecciona un camino más corto que el más corto encontrado.
(defrule SeleccionarMejorAleatorioHC::SeleccionarMejorAleatorio
        ?mejor <- (mejor ?j ?esfuerzo)
        (lista (estado subgrupo)(datos $? / ?newj ?newesf $?))
        (test (< ?newesf ?esfuerzo))
        (test (> ?newesf -1))
        =>
        (assert (mejor ?newj ?newesf))
        (retract ?mejor)
)