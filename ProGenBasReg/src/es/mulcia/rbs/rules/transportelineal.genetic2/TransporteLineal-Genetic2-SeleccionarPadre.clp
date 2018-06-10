; TransporteLineal-Genetic1-SeleccionarPadre.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================


; Plantilla para almacenar la suma del esfuerzo de todas las soluciones.
(deftemplate SeleccionarPadre::vTotal
        (slot valor)
)

; Plantilla para almacenar la suma de la inversa del esfuerzo de todas las soluciones.
(deftemplate SeleccionarPadre::iTotal
        (slot valor)
)

; Plantilla para almacenar un numero generado de forma aleatoria entre 0 y iTotal.
(deftemplate SeleccionarPadre::aleatorio
        (slot valor)
)

;============================================================================

; Regla que inicializa el valor de vTotal y de iTotal en 0.
(defrule SeleccionarPadre::Inicializar
        (not (vTotal))
        (not (iTotal))
        =>
        (assert (vTotal (valor 0)))
        (assert (iTotal (valor 0)))       
)

; Regla que calcula la suma de los esfuerzos de todas las listas.
(defrule SeleccionarPadre::Calcular-esfuerzo-total
        ?solucion <- (solucion (estado pendiente)(esfuerzo ?e))
        ?total <- (vTotal (valor ?t))
        =>
        (modify ?solucion (estado evaluada))
        (modify ?total (valor (+ ?t ?e)))       
)

; Regla que calcula la suma de la deseabilidad de todas las listas.
(defrule SeleccionarPadre::Calcular-deseabilidad-total
        (not (solucion (estado pendiente)))
        ?solucion <- (solucion (estado evaluada)(esfuerzo ?e))
        ?total <- (iTotal (valor ?t))
        (vTotal (valor ?v))
        =>
        (modify ?solucion (estado seleccionable))
        (modify ?total (valor (+ ?t (/ ?v ?e))))       
)

; Regla que genera un número aleatorio entre entre 0 y iTotal.
(defrule SeleccionarPadre::Seleccionar-aleatorio
        (not (solucion (estado evaluada)))
        (not (solucion (estado pendiente)))
        (iTotal (valor ?t))
        (not (aleatorio))
        (test (> ?t 0))
        =>
        (assert (aleatorio (valor (mod (random) ?t))))
)

; Regla que marca una lista como seleccionada si el número aleatorio es menor o igual que su deseabilidad.
(defrule SeleccionarPadre::Seleccionar-padre
        (not (solucion (estado seleccionado)))
        (not (solucion (estado pendiente)))
        (vTotal (valor ?v))
        ?solucion <- (solucion (estado seleccionable)(esfuerzo ?e))
        (aleatorio (valor ?ale))
        (test (<= ?ale (/ ?v ?e)))
        =>
        (modify ?solucion (estado seleccionado))
)

; Regla que marca una lista como no seleccionada si el número aleatorio es mayor que su deseabilidad.
; Además se reduce el número aleatorio en el valor de la deseabilidad de la lista.
(defrule SeleccionarPadre::No-seleccionar-padre
        (not (solucion (estado seleccionado)))
        (not (solucion (estado pendiente)))
        (vTotal (valor ?v))
        ?solucion <- (solucion (estado seleccionable)(esfuerzo ?e))
        ?aleatorio <- (aleatorio (valor ?ale))
        (test (> ?ale (/ ?v ?e)))
        =>
        (modify ?solucion (estado no-seleccionado))
        (modify ?aleatorio (valor (- ?ale (/ ?v ?e))))
)

; Regla que se dispara una vez que se haya seleccionado una lista.
; Finaliza la ejecución y elimina las variables temporales.
(defrule SeleccionarPadre::Finalizar
     (solucion (estado seleccionado))
     ?aleatorio <- (aleatorio)
     ?vTotal <- (vTotal)
     ?iTotal <- (iTotal)
     =>
     (retract ?aleatorio)
     (retract ?vTotal)
     (retract ?iTotal)
     (pop-focus)
)