; TSP-OrdinalRepresentation-GenerarListaOrdinal.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que coloca la ciudad 0 en la primera posición de la lista actual y crea una copia vacía
; de la lista y de las ciudades.
(defrule GenerarListaOrdinal::Inicio
        ?list <- (lista (id ?id)(estado actual)(datos $?izq 0 $?der))
        ?ciudades <- (lista (estado ciudades))
        =>
        (modify ?list (datos 0 $?izq $?der))
        (duplicate ?ciudades (estado ciudades-actual))
        (duplicate ?list (estado transformando)(datos))
)

; Regla que extrae el primer elemento de la lista, crea una copia de la copia de ciudades y un iterador.
(defrule GenerarListaOrdinal::Selecciona-elemento
        ?list <- (lista (estado actual) (datos ?elemento $?otros))
        ?ciudades <- (lista (estado ciudades-actual))
        (not (elemento ?))
        =>
        (duplicate ?ciudades (estado ciudades-iteracion-actual))
        (modify ?list (datos $?otros))
        (assert (elemento ?elemento))
        (assert (iter (n 0)))
)

; Regla que se dispara mientras el primer elemento de la copia de la copia de ciudades sea
; distinto del elemento. Aumenta el iterador.
(defrule GenerarListaOrdinal::Contar-posicion
        ?ciudades <- (lista (estado ciudades-iteracion-actual) (datos ?ciudad $?otras))
        ?iter <- (iter (n ?n))
        (elemento ?elemento)
        (test (neq ?ciudad ?elemento))
        =>
        (modify ?ciudades (datos $?otras))
        (modify ?iter (n (+ ?n 1)))
)

; Regla que se dispara cuando el primer elemento de la copia de la copia de ciudades sea
; igual al elemento. Elimina esa ciudad de la copia de ciudades e inserta el valor del iterador
; en la copia de la lista. Elimina la copia de la copia de ciudades, el iterador y el elemento.
(defrule GenerarListaOrdinal::Introducir-elemento
        ?ciudadesiter <- (lista (estado ciudades-iteracion-actual) (datos ?elemento $?otras))
        ?iter <- (iter (n ?n))
        ?ele <- (elemento ?elemento)
        ?list <- (lista (estado transformando) (datos $?datos))
        ?ciudades <- (lista (estado ciudades-actual) (datos $?izq ?elemento $?der))
        =>
        (modify ?list (datos $?datos ?n))
        (modify ?ciudades (datos $?izq $?der))
        (retract ?ciudadesiter)
        (retract ?iter)
        (retract ?ele)
)

; Una vez se han pasado todas las ciudades de la lista a representación ordinal, se cambia el estado
; de la copia de la lista a preparada y se eliminan la lista y la copia de ciudades.
(defrule GenerarListaOrdinal::Finalizar
        ?list <- (lista (estado actual)(datos))
        ?trans <- (lista (estado transformando))
        ?ciudades <- (lista (estado ciudades-actual))
        =>
        (retract ?list)
        (retract ?ciudades)
        (modify ?trans (estado preparada))
)