; TSP-AdyacencyRepresentation-CruceSCC.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla

;============================================================================

; Regla que crea una lista vacía para el hijo-actual, inicializa el iterador,
; crea una copia de la lista de ciudades a visitar y inicializa el tamaño de los
; trozos con un valor aleatorio entre 1 y p/2.
(defrule CruceSCC::Inicio
        (p ?p)
        (not (lista (estado hijo-actual)))
        ?ciudades <- (lista (estado ciudades))
        =>
        (duplicate ?ciudades (estado ciudades-actual))
        (assert (lista (estado hijo-actual)))
        (assert (tamanyo-trozos (+ (mod (random) (/ ?p 2)) 1)))
        (assert (iter (n 0)))
)

; Regla que se dispara cuando el elemento pertenece a un trozo par de la lista.
; Se crea la dupla i j y se actualiza el iterador.
(defrule CruceSCC::Dupla-par
        (not (dupla $?))
        ?iter <- (iter (n ?i))
        (tamanyo-trozos ?tt)
        ?padrePar <- (lista (estado padre-par)(datos $? / ?i ?j $?))
        (test (eq (mod (div ?i ?tt) 2) 0))
        =>
        (assert (dupla ?i ?j))
        (modify ?iter (n (+ ?i 1)))
)

; Regla que se dispara cuando el elemento pertenece a un trozo impar de la lista.
; Se crea la dupla i j y se actualiza el iterador.
(defrule CruceSCC::Dupla-impar
        (not (dupla $?))
        ?iter <- (iter (n ?i))
        (tamanyo-trozos ?tt)
        ?padreImpar <- (lista (estado padre-impar)(datos $? / ?i ?j $?))
        (test (eq (mod (div ?i ?tt) 2) 1))
        =>
        (assert (dupla ?i ?j))
        (modify ?iter (n (+ ?i 1)))
)

; Regla que se dispara si el elemento j no ha sido visitado. Añade la dupla i j a la lista.
(defrule CruceSCC::Insertar-elemento
        ?dupla<-(dupla ?i ?j)
        ?hijo <- (lista (estado hijo-actual)(datos $?datos))
        ?ciudades <- (lista (estado ciudades-actual)(datos $?izq ?j $?der))
        =>
        (modify ?hijo (datos $?datos / ?i ?j))
        (modify ?ciudades (datos $?izq $?der))
        (retract ?dupla)
)

; Regla que se dispara si el elemento j ha sido visitado. 
; Añade en la posición i una ciudad aleatoria sin visitar.
(defrule CruceSCC::Insertar-elemento-aleatorio
        ?dupla<-(dupla ?i ?j)
        ?hijo <- (lista (estado hijo-actual)(datos $?izq2 / ?i2 ?j $?der2))
        ?ciudades <- (lista (estado ciudades-actual)(datos $?izq ?ciudad $?der))
        =>
        (modify ?hijo (datos $?izq2 / ?i2 ?j $?der2 / ?i ?ciudad))
        (modify ?ciudades (datos $?izq $?der))
        (retract ?dupla)
)

; Una vez se hayan visitado todas las ciudades se llama al módulo RepararCiclos para romper posibles ciclos.
(defrule CruceSCC::Romper-ciclo
        (not (dupla ? ?))
        (p ?i)
        ?iter <- (iter (n ?i))
        ?ciudades <- (lista (estado ciudades-actual))
        =>
        (retract ?iter)
        (retract ?ciudades)
        (focus RepararCiclos)

)