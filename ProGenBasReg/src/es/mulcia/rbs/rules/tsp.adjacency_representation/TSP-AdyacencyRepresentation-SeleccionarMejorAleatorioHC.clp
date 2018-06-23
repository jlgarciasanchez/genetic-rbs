; TSP-AdyacencyRepresentation-SeleccionarMejorAleatorioHC.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla

;============================================================================

(defrule SeleccionarMejorAleatorioHC::Inicio
        (not (mejor ? ?))
        (lista (estado subgrupo)(datos $? / ?newj ?newesf $?))
        (test (> ?newesf -1))
        =>
        (assert (mejor ?newj ?newesf))
)

(defrule SeleccionarMejorAleatorioHC::SeleccionarMejorAleatorio
        ?mejor <- (mejor ?j ?esfuerzo)
        (lista (estado subgrupo)(datos $? / ?newj ?newesf $?))
        (test (< ?newesf ?esfuerzo))
        (test (> ?newesf -1))
        =>
        (assert (mejor ?newj ?newesf))
        (retract ?mejor)
)