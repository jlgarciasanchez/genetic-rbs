; TSP-PathRepresentation-CruceOX.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que elimina las listas padre, crea una copia de tempA y dos de tempB
; y cambia el estado de la lista hijoA a hijoActual y tempB a padreActual.
(defrule CruceOX::Inicializacion
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
        (duplicate ?tempB (estado contador))
        (modify ?tempB (estado padreActual))
        (modify ?hijo (estado hijoActual))
)

; Regla que pasa el primer elemento del padre actual al hijo actual. Se coloca a la izquierda de la parte central.
; Se dispara si el elementoe está en la lista pendiente. Se elimina de dicha lista. Se elimina el primer elemento de contador.
(defrule CruceOX::Colocar-extremo-izq
        ?padre <- (lista (estado padreActual)(datos ?elemento $?resto))
        ?contador <- (lista (estado contador)(datos ? $?restoIzq / $?restoDer))
        ?pendiente <- (lista (estado pendiente)(datos $?izq ?elemento $?der))
        ?hijo <- (lista (estado hijoActual)(datos $?ext / $?centro /))
        (test (neq ?elemento /))
        =>
        (modify ?padre (datos $?resto))
        (modify ?contador (datos $?restoIzq / $?restoDer))
        (modify ?pendiente (datos $?izq $?der))
        (modify ?hijo (datos $?ext ?elemento / $?centro /))
)

; Regla que elimina el primer elemenot del padre.
; Se dispara si no existe en la lista pendiente.
(defrule CruceOX::No-colocar-extremo
        ?padre <- (lista (estado padreActual)(datos ?elemento $?resto))
        (not (lista (estado pendiente)(datos $?izq ?elemento $?der)))
        =>
        (modify ?padre (datos $?resto))
)

; Regla que elimina el símbol / del padre.
(defrule CruceOX::Ignorar-separador
        ?padre <- (lista (estado padreActual)(datos / $?resto))
        =>
        (modify ?padre (datos $?resto))
)

; Regla que elimina la lista contador y elimina los símbolos / de las listas pendiente e hijo.
; Se dispara cuando el primer elemento de contador es igual a /.
(defrule CruceOX::Transicion-izquierda-derecha
        ?contador <- (lista (estado contador)(datos / $?))
        ?pendiente <- (lista (estado pendiente)(datos $?izq / $?der))
        ?hijo <- (lista (estado hijoActual)(datos $?ext / $?centro /))
        =>
        (retract ?contador)
        (modify ?pendiente (datos $?izq $?der))
        (modify ?hijo (datos $?ext $?centro ))
)

; Regla que pasa el primer elemento del padre actual al hijo actual. Se coloca al final de los elementos.
; Se dispara si el elementoe está en la lista pendiente. Se elimina de dicha lista.
(defrule CruceOX::Colocar-extremo-der
        ?padre <- (lista (estado padreActual)(datos ?elemento $?resto))
        (not (lista (estado contador)))
        ?pendiente <- (lista (estado pendiente)(datos $?izq ?elemento $?der))
        ?hijo <- (lista (estado hijoActual)(datos $?datos))
        =>
        (modify ?padre (datos $?resto))
        (modify ?pendiente (datos $?izq $?der))
        (modify ?hijo (datos $?datos ?elemento))
)

; Regla que coloca elementos de la lista pendiente en el hijo. Se coloca a la izquierda de la parte central.
; Se dispara cuando el padre actual está vacío y el contador aún existe.
(defrule CruceOX::Colocar-ultimos-elementos-izq
        ?padre <- (lista (estado padreActual)(datos))
        ?contador <- (lista (estado contador)(datos ? $?restoIzq / $?restoDer))
        ?pendiente <- (lista (estado pendiente)(datos $?izq ?elemento $?der))
        ?hijo <- (lista (estado hijoActual)(datos $?ext / $?centro /))
        =>
        (modify ?pendiente (datos $?izq $?der))
        (modify ?contador (datos $?restoIzq / $?restoDer))
        (modify ?hijo (datos $?ext ?elemento / $?centro /))
)

; Regla que coloca elementos de la lista pendiente en el hijo. Se coloca al final de los elementos.
; Se dispara cuando el padre actual está vacío y el contador no existe.
(defrule CruceOX::Colocar-ultimos-elementos-der
        ?padre <- (lista (estado padreActual)(datos))
        (not (lista (estado contador)))
        ?pendiente <- (lista (estado pendiente)(datos $?izq ?elemento $?der))
        ?hijo <- (lista (estado hijoActual)(datos $?datos))
        =>
        (modify ?pendiente (datos $?izq $?der))
        (modify ?hijo (datos $?datos ?elemento))
)

; Regla que elimina al padre actual y a pendiente.
; Se cambia el estado de tempA por padreActual, de pendienteB por pendiente, de hijoActual por hijo y de hijoB por hijoActual.
; Se crea una copia de tempA con estado contador.
(defrule CruceOX::Generar-segundo-hijo
        ?padre <- (lista (estado padreActual)(datos))
        ?pendiente <- (lista (estado pendiente)(datos))
        ?hijo <- (lista (estado hijoActual))
        ?padre2 <- (lista (estado tempA))
        ?pendiente2 <- (lista (estado pendienteB))
        ?hijo2 <- (lista (estado hijoB))
        =>
        (retract ?padre)
        (retract ?pendiente)
        (modify ?hijo (estado hijo))
        (duplicate ?padre2 (estado contador))
        (modify ?padre2 (estado padreActual))
        (modify ?pendiente2 (estado pendiente))
        (modify ?hijo2 (estado hijoActual))
)

; Regla que elimina al padre actual y a pendiente.
; Se cambia el estado de hijoActual por hijo.
(defrule CruceOX::Finalizar
        ?padre <- (lista (estado padreActual)(datos))
        ?pendiente <- (lista (estado pendiente)(datos))
        ?hijo <- (lista (estado hijoActual))
        (not (lista (estado tempA)))
        =>
        (retract ?padre)
        (retract ?pendiente)
        (modify ?hijo (estado hijo))
)