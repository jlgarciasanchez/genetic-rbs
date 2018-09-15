; TSP-AdyacencyRepresentation-SeleccionarAleatorioHC.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Plantilla que se utiliza para almacenar los datos de un segundo iterador auxiliar.
(deftemplate SeleccionarAleatorioHC::iter2
        (slot n)
)

;============================================================================

; Regla que crea inicializa el iterador, el subgrupo de ciudades y crea una copia de la lista
; de ciudades sin seleccionar.
(defrule SeleccionarAleatorioHC::Inicio
        (not (iter2))
        ?ciudades <- (lista (estado ciudades-actual))
        =>
        (assert (iter2 (n 0)))
        (assert (lista (estado subgrupo)))
        (duplicate ?ciudades (estado ciudades-candidatas))
)

; Regla que seleccionar un elemento "al azar" de las ciudades sin seleccionar hasta
; que se alcance el número de iteraciones.
(defrule SeleccionarAleatorioHC::Seleccionar-elemento
        (tamanyo-subgrupo ?ts)
        ?iter <- (iter2 (n ?n))
        ?ciudades <- (lista (estado ciudades-candidatas)(datos $?izq ?candidato $?der))
        ?subgrupo <- (lista (estado subgrupo)(datos $?datos))
        (test (< ?n ?ts))
        =>
        (modify ?ciudades (datos $?izq $?der))
        (modify ?subgrupo (datos $?datos / ?candidato -1))
        (modify ?iter (n (+ ?n 1)))
)
 
 ; Regla que se dispara si la ciudad seleccionada es la única ciudad restante.
(defrule SeleccionarAleatorioHC::Seleccionado-unico-elemento
        (lista (estado ciudades-candidatas)(datos))
        (lista (estado subgrupo)(datos / ?j ?))
        =>
        (assert (SeleccionarMejorAleatorioHC::mejor ?j 0))
)

; Regla que calcula el esfuerzo del camino entre la ciudad origen y el elemento seleccionado.
(defrule SeleccionarAleatorioHC::Esfuerzo-elemento-A
        ?subgrupo <- (lista (estado subgrupo)(datos $?izq / ?j -1 $?der))
        (iter (n ?i))
        (esfuerzo (ciudadA ?i1) (ciudadB ?j) (esfuerzo ?esfuerzo))
        (test (eq ?i1 (- ?i 1)))
        =>
        (modify ?subgrupo (datos $?izq / ?j ?esfuerzo $?der))
)

; Regla que calcula el esfuerzo del camino entre el elemento seleccionado y la ciudad origen.
(defrule SeleccionarAleatorioHC::Esfuerzo-elemento-B
        ?subgrupo <- (lista (estado subgrupo)(datos $?izq / ?j -1 $?der))
        (iter (n ?i))
        (esfuerzo (ciudadA ?j) (ciudadB ?i1) (esfuerzo ?esfuerzo))
        (test (eq ?i1 (- ?i 1)))
        =>
        (modify ?subgrupo (datos $?izq / ?j ?esfuerzo $?der))
)

; Regla que modifica el esfuerzo del elemento j si es igual a i-1
(defrule SeleccionarAleatorioHC::Esfuerzo-elemento-C
        ?subgrupo <- (lista (estado subgrupo)(datos $?izq / ?i1 -1 $?der))
        (iter (n ?i))
        (test (eq ?i1 (- ?i 1)))
        =>
        (modify ?subgrupo (datos $?izq / ?i1 -2 $?der))
)

; Regla que se dispara si se alcanza el limite de iteraciones.
; Se invoca al módulo SeleccionarMejorAleatorioHC.
(defrule SeleccionarAleatorioHC::Seleccionar-mejor-niteraciones
        (not (lista (datos $? -1 $?)))
        (iter2 (n ?i))
        (tamanyo-subgrupo ?i)
        =>
        (focus SeleccionarMejorAleatorioHC)
)

; Regla que se dispara si no quedan más ciudades candidatas.
; Se invoca al módulo SeleccionarMejorAleatorioHC.
(defrule SeleccionarAleatorioHC::Seleccionar-mejor-candidatas-vacio
        (not (lista (datos $? -1 $?)))
        (lista (estado ciudades-candidatas)(datos))
        =>
        (focus SeleccionarMejorAleatorioHC)
)

; Regla que pone fin a la ejecución del móudlo. Añade a la solución hija el camino
; más corto entre los seleccionados al azar y borra las variables temporales.
(defrule SeleccionarAleatorioHC::Finalizar
        ?subgrupo <- (lista (estado subgrupo))
        ?ciudades <- (lista (estado ciudades-candidatas))
        ?mejor <- (SeleccionarMejorAleatorioHC::mejor ?j ?)
        ?iter2 <- (iter2)
        (iter (n ?i))
        ?hijo <- (lista (estado hijo-actual)(datos $?datos))
        =>
        (modify ?hijo (datos $?datos / (- ?i 1) ?j))
        (retract ?subgrupo)
        (retract ?ciudades)
        (retract ?mejor)
        (retract ?iter2)
        (pop-focus)
)