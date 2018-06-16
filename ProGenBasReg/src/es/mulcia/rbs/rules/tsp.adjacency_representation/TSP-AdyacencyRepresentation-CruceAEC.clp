; TSP-AdyacencyRepresentation-CruceAEC.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla

;============================================================================

; Plantilla que se utiliza para almacenar los datos de un iterador.
(deftemplate CruceAEC::iter
        (slot n)
)

;============================================================================

(defrule CruceAEC::Inicio
        (not (lista (estado hijo-actual)))
        ?ciudades <- (lista (estado ciudades))
        =>
        (duplicate ?ciudades (estado ciudades-actual))
        (assert (lista (estado hijo-actual)))
        (assert (iter (n 0)))
)

(defrule CruceAEC::Dupla-par
        (not (dupla $?))
        ?iter <- (iter (n ?i))
        ?padrePar <- (lista (estado padre-par)(datos $? / ?i ?j $?))
        (test (= (mod ?i 2) 0))
        =>
        (assert (dupla ?i ?j))
        (modify ?iter (n (+ ?i 1)))
)

(defrule CruceAEC::Dupla-impar
        (not (dupla $?))
        ?iter <- (iter (n ?i))
        ?padreImpar <- (lista (estado padre-impar)(datos $? / ?i ?j $?))
        (test (= (mod ?i 2) 1))
        =>
        (assert (dupla ?i ?j))
        (modify ?iter (n (+ ?i 1)))
)

(defrule CruceAEC::Insertar-elemento
        ?dupla<-(dupla ?i ?j)
        ?hijo <- (lista (estado hijo-actual)(datos $?datos))
        ?ciudades <- (lista (estado ciudades-actual)(datos $?izq ?ciudad $?der))
        (test (eq ?j ?ciudad))
        =>
        (modify ?hijo (datos $?datos / ?i ?j))
        (modify ?ciudades (datos $?izq $?der))
        (retract ?dupla)
)

(defrule CruceAEC::Insertar-elemento-aleatorio
        ?dupla<-(dupla ?i ?j)
        ?hijo <- (lista (estado hijo-actual)(datos $?izq2 / ?i2 ?j2 $?der2))
        ?ciudades <- (lista (estado ciudades-actual)(datos $?izq ?ciudad $?der))
        (test (eq ?j ?j2))
        =>
        (modify ?hijo (datos $?izq2 / ?i2 ?j2 $?der2 / ?i ?ciudad))
        (modify ?ciudades (datos $?izq $?der))
        (retract ?dupla)
)

(defrule CruceAEC::Romper-ciclo
        (not (dupla ? ?))
        (p ?p)
        ?iter <- (iter (n ?i))
        (test (eq ?p ?i))
        ?ciudades <- (lista (estado ciudades-actual))
        =>
        (retract ?iter)
        (retract ?ciudades)
        (focus RepararCiclos)

)