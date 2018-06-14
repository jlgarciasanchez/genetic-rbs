; TSP-AdyacencyRepresentation-ElementoRepetido.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla

;============================================================================

; Plantilla que se utiliza para almacenar los datos de la ruta del viajante.
(deftemplate RepararCiclos::ruta
        (multislot ciudades)
)

;============================================================================

(defrule RepararCiclos::Inicio
       (not (ruta))
       ?ciudades <- (lista (estado ciudades))
       =>
       (duplicate ?ciudades (estado ciudades-actual))
       (assert (ruta (ciudades 0)))
)

(defrule RepararCiclos::Add-ciudad
        (lista (estado hijo-actual)(datos $? / ?i ?j $?))
        ?ruta <- (ruta (ciudades $?otras ?last))
        ?ciudades <- (lista (estado ciudades-actual)(datos $?izq ?ciudad $?der))
        (test (eq ?i ?last))
        (test (eq ?j ?ciudad))
        (test (neq ?j 0))
        =>
        (modify ?ruta (ciudades $?otras ?last ?j))
        (modify ?ciudades (datos $?izq $?der))
)

(defrule RepararCiclos::Romper-ciclo-izquierda
        ?solucion <- (lista (estado hijo-actual)(datos $?izq2 / ?i2 ?j2 $?centro / ?i ?j $?der2))
        ?ruta <- (ruta (ciudades $?otras ?last))
        ?ciudades <- (lista (estado ciudades-actual)(datos $?izq ?ciudad $?der))
        (test (eq ?i ?last))
        (test (eq ?j 0))
        (test (eq ?j2 ?ciudad))
        =>
        (modify ?solucion (datos $?izq2 / ?i2 ?j $?centro / ?i ?j2 $?der2))
        (modify ?ruta (ciudades $?otras ?last ?j2))
        (modify ?ciudades (datos $?izq $?der))
)

(defrule RepararCiclos::Romper-ciclo-derecha
        ?solucion <- (lista (estado hijo-actual)(datos $?izq2 / ?i ?j $?centro / ?i2 ?j2 $?der2))
        ?ruta <- (ruta (ciudades $?otras ?last))
        ?ciudades <- (lista (estado ciudades-actual)(datos $?izq ?ciudad $?der))
        (test (eq ?i ?last))
        (test (eq ?j 0))
        (test (eq ?j2 ?ciudad))
        =>
        (modify ?solucion (datos $?izq2 / ?i ?j2 $?centro / ?i2 ?j $?der2))
        (modify ?ruta (ciudades $?otras ?last ?j2))
        (modify ?ciudades (datos $?izq $?der))
)

(defrule RepararCiclos::Finalizar
      ?ciudades <- (lista (estado ciudades-actual)(datos 0))
      ?ruta <- (ruta)
      =>
      (retract ?ciudades)
      (retract ?ruta)
      (pop-focus)
)