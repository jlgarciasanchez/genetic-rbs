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


(defrule SeleccionarAleatorioHC::Inicio
        (not (iter2))
        ?ciudades <- (lista (estado ciudades-actual))
        =>
        (assert (iter2 (n 0)))
        (assert (lista (estado subgrupo)))
        (duplicate ?ciudades (estado ciudades-candidatas))
)

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

(defrule SeleccionarAleatorioHC::Seleccionado-unico-elemento
        (lista (estado ciudades-candidatas)(datos))
        (lista (estado subgrupo)(datos / ?j ?))
        =>
        (assert (SeleccionarMejorAleatorioHC::mejor ?j 0))
)

(defrule SeleccionarAleatorioHC::Esfuerzo-elemento-A
        ?subgrupo <- (lista (estado subgrupo)(datos $?izq / ?j -1 $?der))
        (iter (n ?i))
        (esfuerzo (ciudadA ?i1) (ciudadB ?j) (esfuerzo ?esfuerzo))
        (test (eq ?i1 (- ?i 1)))
        =>
        (modify ?subgrupo (datos $?izq / ?j ?esfuerzo $?der))
)

(defrule SeleccionarAleatorioHC::Esfuerzo-elemento-B
        ?subgrupo <- (lista (estado subgrupo)(datos $?izq / ?j -1 $?der))
        (iter (n ?i))
        (esfuerzo (ciudadA ?j) (ciudadB ?i1) (esfuerzo ?esfuerzo))
        (test (eq ?i1 (- ?i 1)))
        =>
        (modify ?subgrupo (datos $?izq / ?j ?esfuerzo $?der))
)

(defrule SeleccionarAleatorioHC::Seleccionar-mejor-A
        (not (lista (datos $? -1 $?)))
        (iter2 (n ?i))
        (tamanyo-subgrupo ?i)
        =>
        (focus SeleccionarMejorAleatorioHC)
)

(defrule SeleccionarAleatorioHC::Seleccionar-mejor-B
        (not (lista (datos $? -1 $?)))
        (lista (estado ciudades-candidatas)(datos))
        =>
        (focus SeleccionarMejorAleatorioHC)
)

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