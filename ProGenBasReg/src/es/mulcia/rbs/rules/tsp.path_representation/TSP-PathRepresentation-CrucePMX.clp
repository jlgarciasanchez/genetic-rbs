; TSP-PathRepresentation-CrucePMX.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que elimina las listas padre, crea copias de las listas temp 
; y cambia el estado de la lista hijoA a hijoactual y tempB a padreActual.
(defrule CrucePMX::Inicializacion
        ?padreA <- (lista (estado padreA) (datos))
        ?padreB <- (lista (estado padreB) (datos))
        ?tempB <- (lista (estado tempB))
        ?tempA <- (lista (estado tempA))
        ?hijo <- (lista (estado hijoA))
        =>
        (retract ?padreA)
        (retract ?padreB)
        (duplicate ?tempB (estado pendienteB))
        (duplicate ?tempA (estado pendiente))
        (modify ?tempB (estado padreActual))
        (modify ?hijo (estado hijoActual))
)

; Regla que pasa el primer elemento del padre actual al hijo actual. Se coloca a la izquierda de la parte central.
; Se dispara si el elementoe está en la lista pendiente. Se elimina de dicha lista.
(defrule CrucePMX::Colocar-extremo-izq
        ?padre <- (lista (estado padreActual)(datos ?elemento $?restoIzq / $?restoDer))
        ?pendiente <- (lista (estado pendiente)(datos $?izq ?elemento $?der))
        ?hijo <- (lista (estado hijoActual)(datos $?ext / $?centro /))
        =>
        (modify ?padre (datos $?restoIzq / $?restoDer))
        (modify ?pendiente (datos $?izq $?der))
        (modify ?hijo (datos $?ext ?elemento / $?centro /))
)

; Regla que extrae el primer elemento del padre actual e introduce una X en el hijo actual. Se coloca a la izquierda de la parte central.
; Se dispara si el elemento no se encuentra en la lista pendiente.
(defrule CrucePMX::No-colocar-extremo-izq
        ?padre <- (lista (estado padreActual)(datos ?elemento $?restoIzq / $?restoDer))
        (not (lista (estado pendiente)(datos $?izq ?elemento $?der)))
        ?hijo <- (lista (estado hijoActual)(datos $?ext / $?centro /))
        =>
        (modify ?padre (datos $?restoIzq / $?restoDer))
        (modify ?hijo (datos $?ext X / $?centro /))
)

; Regla que elimina los símbolos para separar los trozos de las listas.
; Se dispara cuando el primer elemento del padre actual es /.
; Se cambia el estado del padre de padreActual a padreActual2
(defrule CrucePMX::Transicion-izquierda-derecha
        ?padre <- (lista (estado padreActual)(datos / $?resto))
        ?pendiente <- (lista (estado pendiente)(datos $?izq / $?der))
        ?hijo <- (lista (estado hijoActual)(datos $?ext / $?centro /))
        =>
        (modify ?padre (estado padreActual2)(datos $?resto))
        (modify ?pendiente (datos $?izq $?der))
        (modify ?hijo (datos $?ext $?centro ))
)

; Regla que pasa el primer elemento del padre actual al hijo actual. Se coloca al final de los elementos.
; Se dispara si el elementoe está en la lista pendiente. Se elimina de dicha lista.
(defrule CrucePMX::Colocar-extremo-der
        ?padre <- (lista (estado padreActual2)(datos ?elemento $?resto))
        ?pendiente <- (lista (estado pendiente)(datos $?izq ?elemento $?der))
        ?hijo <- (lista (estado hijoActual)(datos $?datos))
        =>
        (modify ?padre (datos $?resto))
        (modify ?pendiente (datos $?izq $?der))
        (modify ?hijo (datos $?datos ?elemento))
)

; Regla que extrae el primer elemento del padre actual e introduce una X en el hijo actual. Se coloca al final de los elementos.
; Se dispara si el elemento no se encuentra en la lista pendiente.
(defrule CrucePMX::No-colocar-extremo-der
        ?padre <- (lista (estado padreActual2)(datos ?elemento $?resto))
        (not (lista (estado pendiente)(datos $?izq ?elemento $?der)))
        ?hijo <- (lista (estado hijoActual)(datos $?datos))
        =>
        (modify ?padre (datos $?resto))
        (modify ?hijo (datos $?datos X))
)

; Regla que reemplaza las X en el hijo actual por elementos de la lista pendiente.
; Se dispara cuando el padre actual está vacío.
(defrule CrucePMX::Colocar-ultimos-elementos
        ?padre <- (lista (estado padreActual2)(datos))
        ?pendiente <- (lista (estado pendiente)(datos $?izq ?elemento $?der))
        ?hijo <- (lista (estado hijoActual)(datos $?datosIzq X $?datosDer))
        =>
        (modify ?pendiente (datos $?izq $?der))
        (modify ?hijo (datos $?datosIzq ?elemento $?datosDer))
)

; Regla que elimina al padre actual y a pendiente.
; Se cambia el estado de tempA por padreActual, de pendienteB por pendiente, de hijoActual por hijo y de hijoB por hijoActual.
(defrule CrucePMX::Generar-segundo-hijo
        ?padre <- (lista (estado padreActual2)(datos))
        ?pendiente <- (lista (estado pendiente)(datos))
        ?hijo <- (lista (estado hijoActual))
        ?padre2 <- (lista (estado tempA))
        ?pendiente2 <- (lista (estado pendienteB))
        ?hijo2 <- (lista (estado hijoB))
        =>
        (retract ?padre)
        (retract ?pendiente)
        (modify ?hijo (estado hijo))
        (modify ?padre2 (estado padreActual))
        (modify ?pendiente2 (estado pendiente))
        (modify ?hijo2 (estado hijoActual))
)

; Regla que elimina al padre actual y a pendiente.
; Se cambia el estado de hijoActual por hijo.
(defrule CrucePMX::Finalizar
        ?padre <- (lista (estado padreActual2)(datos))
        ?pendiente <- (lista (estado pendiente)(datos))
        ?hijo <- (lista (estado hijoActual))
        (not (lista (estado tempA)))
        =>
        (retract ?padre)
        (retract ?pendiente)
        (modify ?hijo (estado hijo))
)