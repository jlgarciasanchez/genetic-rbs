; TSP-AdyacencyRepresentation-CruceHC.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que crea una lista vacía para el hijo-actual, inicializa el iterador,
; crea una copia de la lista de ciudades a visitar.
(defrule CruceHC::Inicio
        (not (lista (estado hijo-actual)))
        ?ciudades <- (lista (estado ciudades))
        (nHijos (n ?nH))
        =>
        (duplicate ?ciudades (estado ciudades-actual))
        (assert (lista (id ?nH)(esfuerzo 0)(estado hijo-actual)))
        (assert (iter (n 0)))
)

; Regla que calcula los esfuerzos de los primeros elementos de la lista.
; Se dispara si existen los caminos i-par j-par y i-impar j-impar.
(defrule CruceHC::Calcular-esfuerzos-ijij
        (not (dupla $?))
        ?iter <- (iter (n ?i))
        (lista (estado padre-par)(datos $? / ?i ?jpar $?))
        (lista (estado padre-impar)(datos $? / ?i ?jimpar $?))
        (esfuerzo (ciudadA ?i) (ciudadB ?jpar) (esfuerzo ?esfuerzo-par))
        (esfuerzo (ciudadA ?i) (ciudadB ?jimpar) (esfuerzo ?esfuerzo-impar))
        =>
        (assert (esfuerzo-par ?esfuerzo-par))
        (assert (esfuerzo-impar ?esfuerzo-impar))
)

; Regla que calcula los esfuerzos de los primeros elementos de la lista.
; Se dispara si existen los caminos i-par j-par y j-impar i-impar.
(defrule CruceHC::Calcular-esfuerzos-ijji
        (not (dupla $?))
        ?iter <- (iter (n ?i))
        (lista (estado padre-par)(datos $? / ?i ?jpar $?))
        (lista (estado padre-impar)(datos $? / ?i ?jimpar $?))
        (esfuerzo (ciudadA ?i) (ciudadB ?jpar) (esfuerzo ?esfuerzo-par))
        (esfuerzo (ciudadA ?jimpar) (ciudadB ?i) (esfuerzo ?esfuerzo-impar))
        =>
        (assert (esfuerzo-par ?esfuerzo-par))
        (assert (esfuerzo-impar ?esfuerzo-impar))
)

; Regla que calcula los esfuerzos de los primeros elementos de la lista.
; Se dispara si existen los caminos j-par i-par y i-impar j-impar.
(defrule CruceHC::Calcular-esfuerzos-jiij
        (not (dupla $?))
        ?iter <- (iter (n ?i))
        (lista (estado padre-par)(datos $? / ?i ?jpar $?))
        (lista (estado padre-impar)(datos $? / ?i ?jimpar $?))
        (esfuerzo (ciudadA ?jpar) (ciudadB ?i) (esfuerzo ?esfuerzo-par))
        (esfuerzo (ciudadA ?i) (ciudadB ?jimpar) (esfuerzo ?esfuerzo-impar))
        =>
        (assert (esfuerzo-par ?esfuerzo-par))
        (assert (esfuerzo-impar ?esfuerzo-impar))
)

; Regla que calcula los esfuerzos de los primeros elementos de la lista.
; Se dispara si existen los caminos j-par i-par y j-impar i-impar.
(defrule CruceHC::Calcular-esfuerzos-jiji
        (not (dupla $?))
        ?iter <- (iter (n ?i))
        (lista (estado padre-par)(datos $? / ?i ?jpar $?))
        (lista (estado padre-impar)(datos $? / ?i ?jimpar $?))
        (esfuerzo (ciudadA ?jpar) (ciudadB ?i) (esfuerzo ?esfuerzo-par))
        (esfuerzo (ciudadA ?jimpar) (ciudadB ?i) (esfuerzo ?esfuerzo-impar))
        =>
        (assert (esfuerzo-par ?esfuerzo-par))
        (assert (esfuerzo-impar ?esfuerzo-impar))
)

; Regla que almacena las duplas i j de los padres.
; Se dispara si el del padre par es menor.
(defrule CruceHC::Par-menor
        ?par <- (esfuerzo-par ?esfuerzo-par)
        ?impar <- (esfuerzo-impar ?esfuerzo-impar)
        ?iter <- (iter (n ?i))
        (lista (estado padre-impar)(datos $? / ?i ?j2 $?))
        (lista (estado padre-par)(datos $? / ?i ?j $?))
        (test (< ?esfuerzo-par ?esfuerzo-impar))
        =>
        (modify ?iter (n (+ ?i 1)))
        (assert (dupla ?i ?j))
        (assert (dupla-peor ?i ?j2))
        (retract ?par)
        (retract ?impar)
)

; Regla que almacena las duplas i j de los padres.
; Se dispara si el del padre impar es menor o igual.
(defrule CruceHC::Impar-menor
        ?par <- (esfuerzo-par ?esfuerzo-par)
        ?impar <- (esfuerzo-impar ?esfuerzo-impar)
        ?iter <- (iter (n ?i))
        (lista (estado padre-impar)(datos $? / ?i ?j $?))
        (lista (estado padre-par)(datos $? / ?i ?j2 $?))
        (test (<= ?esfuerzo-impar ?esfuerzo-par))
        =>
        (modify ?iter (n (+ ?i 1)))
        (assert (dupla ?i ?j))
        (assert (dupla-peor ?i ?j2))
        (retract ?par)
        (retract ?impar)
)

; Regla que se dispara si el elemento j del mejor no ha sido visitado.
; Añade la dupla i j-mejor a la lista.
(defrule CruceHC::Insertar-elemento
        ?dupla<-(dupla ?i ?j)
        ?peor <-(dupla-peor ?i ?)
        ?hijo <- (lista (estado hijo-actual)(datos $?datos))
        ?ciudades <- (lista (estado ciudades-actual)(datos $?izq ?j $?der))
        =>
        (modify ?hijo (datos $?datos / ?i ?j))
        (modify ?ciudades (datos $?izq $?der))
        (retract ?dupla)
        (retract ?peor)
)

; Regla que se dispara si el elemento j del mejor ha sido visitado y el elemento j del peor no.
; Añade la dupla i j-peor a la lista.
(defrule CruceHC::Insertar-otro-elemento
        ?dupla<-(dupla ?i ?j)
        ?peor <-(dupla-peor ?i ?j2)
        ?hijo <- (lista (estado hijo-actual)(datos $?datos-izq / ?i2 ?j $?datos-der))
        ?ciudades <- (lista (estado ciudades-actual)(datos $?izq ?j2 $?der))
        =>
        (modify ?hijo (datos $?datos-izq / ?i2 ?j $?datos-der / ?i ?j2))
        (modify ?ciudades (datos $?izq $?der))
        (retract ?dupla)
        (retract ?peor)
)

; Regla que se dispara si los elementos j de los dos padres han sido visitados
; y el del mejor está a la ziquierda. Añade la dupla i j-peor a la lista.
(defrule CruceHC::Insertar-aleatorio-A
        ?dupla<-(dupla ?i ?j)
        ?peor <-(dupla-peor ?i ?j2)
        ?hijo <- (lista (estado hijo-actual)(datos $?datos-izq / ?i2 ?j $?datos-centro / ?i3 ?j2 $?datos-der))
        =>
        (focus SeleccionarAleatorioHC)
        (retract ?dupla)
        (retract ?peor)
)

; Regla que se dispara si los elementos j de los dos padres han sido visitados
; y el del mejor está a la derecha. Añade la dupla i j-peor a la lista.
(defrule CruceHC::Insertar-aleatorio-B
        ?dupla<-(dupla ?i ?j)
        ?peor <-(dupla-peor ?i ?j2)
        ?hijo <- (lista (estado hijo-actual)(datos $?datos-izq / ?i2 ?j2 $?datos-centro / ?i3 ?j $?datos-der))
        =>
        (focus SeleccionarAleatorioHC)
        (retract ?dupla)
        (retract ?peor)
)

; Una vez se hayan visitado todas las ciudades se llama al módulo RepararCiclos para romper posibles ciclos.
(defrule CruceHC::Romper-ciclo
        (not (dupla ? ?))
        (p ?i)
        ?iter <- (iter (n ?i))
        ?ciudades <- (lista (estado ciudades-actual))
        =>
        (retract ?iter)
        (retract ?ciudades)
        (focus RepararCiclos)
)