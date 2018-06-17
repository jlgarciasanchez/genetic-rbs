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

; Regla que inicializa la ruta en la ciudad 0 
; y crea una copia de la lista con las ciudades a vistiar.
(defrule RepararCiclos::Inicio
       (not (ruta))
       ?ciudades <- (lista (estado ciudades))
       =>
       (duplicate ?ciudades (estado ciudades-actual))
       (assert (ruta (ciudades 0)))
)

; Regla que comprueba que añade el elemento actual a la ruta del viajante
; si no se produce un ciclo. (Volviendo a la posición inicial antes de tiempo)
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

; Regla que se dispara cuando se produce un ciclo, se intercambia la ciudad actual
; por una ciudad sin visitar a la izquierda de la actual y se añade a la ruta.
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

; Regla que se dispara cuando se produce un ciclo, se intercambia la ciudad actual
; por una ciudad sin visitar a la derecha de la actual y se añade a la ruta.
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

; Regla que se dispara una vez se hayan visitado todas las ciudades.
; Se borran las variables temporales y se acaba con la ejecución del ciclo.
(defrule RepararCiclos::Finalizar
      ?ciudades <- (lista (estado ciudades-actual)(datos 0))
      ?ruta <- (ruta)
      =>
      (retract ?ciudades)
      (retract ?ruta)
      (pop-focus)
)