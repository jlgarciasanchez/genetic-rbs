; TransporteLineal-Genetic1-Seleccion.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Plantilla que almacena el número de padres seleccionados. Puede tomar los valores 0, 1 o 2.
(deftemplate Seleccion::nPadres
        (slot n)
)

;============================================================================

; Regla que inica inicializa en 0 el número de padres.
(defrule Seleccion::Inicializar
        (not (nPadres))
        =>
        (assert (nPadres (n 0)))
)

; Regla que marca como padre la lista seleccionada.
(defrule Seleccion::Asignar-padre
        ?list <- (lista (estado seleccionado))
        =>
        (modify ?list (estado padre))
)

; Regla que vuelve a marcar como evaluada las listas que aún no habían sido seleccionadas.
(defrule Seleccion::Quitar-seleccion1
        ?list <- (lista (estado seleccionable))
        =>
        (modify ?list (estado evaluada))
)

; Regla que vuelve a marcar como evaluada las listas no seleccionadas.
(defrule Seleccion::Quitar-seleccion2
        ?list <- (lista (estado no-seleccionado))
        =>
        (modify ?list (estado evaluada))
)

; Regla que invoca al módulo SeleccionarPadre y actualiza el contador de padres.
(defrule Seleccion::Seleccionar-padre
        (not (lista (estado seleccionado)))
        (not (lista (estado no-seleccionado)))
        (not (lista (estado seleccionable)))
        ?nPadres <- (nPadres (n ?n))
        (test (< ?n 2))
        =>
        (modify ?nPadres (n (+ ?n 1)))
        (focus SeleccionarPadre)
)

; Regla que acaba con la ejecución del módulo y elimina el contador de padres.
(defrule Seleccion::Finalizar
        (not (lista (estado seleccionado)))
        (not (lista (estado no-seleccionado)))
        (not (lista (estado seleccionable)))
        ?nPadres <- (nPadres (n 2))
        =>
        (retract ?nPadres)
        (pop-focus)
)