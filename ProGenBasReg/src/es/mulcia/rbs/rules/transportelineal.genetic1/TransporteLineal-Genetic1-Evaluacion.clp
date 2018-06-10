; TransporteLineal-Genetic1-Evaluacion.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que se encarga de rellenar la mercacia actual de las fuentes.
(defrule Evaluacion::Rellenar-fuentes
        ?fuente <- (fuente (mercancia-total ?m)(mercancia-actual 0))
        =>
        (modify ?fuente (mercancia-actual ?m))
)

; Regla que se encarga de rellenar la mercacia actual de los destinos.
(defrule Evaluacion::Rellenar-destinos
        ?destino <- (destino (mercancia-total ?m)(mercancia-actual 0))
        =>
        (modify ?destino (mercancia-actual ?m))
)

; Regla que marca una lista como actual y llama al módulo EvaluarLista.
(defrule Evaluacion::Evaluar-lista
        (not (fuente (mercancia-actual 0)))
        (not (destino (mercancia-actual 0)))
        ?list <- (lista (estado pendiente))
        =>
        (modify ?list (estado actual))
        (focus EvaluarLista)
)

; Regla que llama al módulo EvaluarMejor una vez se hayan evaluado todas las listas.
(defrule Evaluacion::Buscar-mejor
        (not (lista (estado pendiente)))
        =>
        (focus EvaluarMejor)
        (assert (fin))
)

; Regla que de dispara cuando el módulo ha finalizado.
(defrule Evaluacion::Finalizar
        ?fin <- (fin)
        =>
        (retract ?fin)
        (pop-focus)
)
