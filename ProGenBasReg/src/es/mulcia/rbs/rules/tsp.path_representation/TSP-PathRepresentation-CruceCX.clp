; TSP-PathRepresentation-CruceCX .clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Regla que inicializa la lista de los hijos, elimina la ciudad 0 de los padres,
; actualiza el contador de hijos y crea una copia temp.
(defrule CruceCX::Inicializacion
        (not (lista (estado hijoA)))
        ?padreA <- (lista (estado padreA)(datos 0 $?datosA))
        ?padreB <- (lista (estado padreB)(datos 0 $?datosB))
        ?nHijos <- (nHijos (n ?nH))
        =>
        (assert (lista (estado hijoA)(id ?nH)(esfuerzo 0)(datos)))
        (assert (lista (estado hijoB)(id (+ ?nH 1))(esfuerzo 0)(datos)))
        (modify ?nHijos (n (+ ?nH 2)))
        (modify ?padreA (datos $?datosA))
        (modify ?padreB (datos $?datosB))
        (duplicate ?padreA (estado temp))
        (assert (primer))
)

; Regla que rellena los datos de los hijos con el elemento X. Se utilzia la lista temp para 
; realizar la iteración.
(defrule CruceCX::Rellenar-equis
        ?hijoA <- (lista (estado hijoA)(datos $?a))
        ?hijoB <- (lista (estado hijoB)(datos $?b))
        ?temp <- (lista (estado temp)(datos ?primer $?t))
        =>
        (modify ?hijoA (datos $?a X))
        (modify ?hijoB (datos $?b X))
        (modify ?temp (datos $?t))
)

; Regla que elimina temp cuando esta vacía.
(defrule CruceCX::Borrar-temp
        ?temp <- (lista (estado temp)(datos))
        =>
        (retract ?temp)
)

; Regla que sólo se dispara una vez por hijo. Se crean copias de los padres y una copia vacía del hijo.
; Se introduce al hijo el primer elemento del padreA y se genera el hecho elemento con el primer elemento del padreB.
(defrule CruceCX::Primer-elemento
        (not (lista (estado temp)))
        ?p <- (primer)
        ?hijo <- (lista (estado hijoA)(datos X $?x))
        ?padreA <- (lista (estado padreA)(datos ?primer $?datosA))
        ?padreB <- (lista (estado padreB)(datos ?segundo $?datosB))
        =>
        (duplicate ?padreA (estado copiaA))
        (duplicate ?padreB (estado copiaB))
        (duplicate ?hijo (estado copiaH)(datos))
        (modify ?hijo (datos ?primer $?x))
        (assert (elemento ?segundo))
        (retract ?p)
)

; Regla que se dispara mientras el primer elemento de la copia de padreA sea distinto del elemento.
; Se elimina el primer elemenoto de las copias de los padres y el del hijo se pasa a su copia.
(defrule CruceCX::Buscar-elemento
        ?ele <- (elemento ?elemento)
        ?hijo <- (lista (estado hijoA)(datos ?h $?datosH))
        ?copiaH <- (lista (estado copiaH)(datos $?datosC))
        ?copiaA <- (lista (estado copiaA)(datos ?a $?datosA))
        ?copiaB <- (lista (estado copiaB)(datos ?b $?datosB))
        (test (neq ?a ?elemento))
        =>
        (modify ?copiaA (datos $?datosA))
        (modify ?copiaB (datos $?datosB))
        (modify ?hijo (datos $?datosH))
        (modify ?copiaH (datos $?datosC ?h))
)

; Regla que se disapra cuando el primer elemnto de la copia del padre A es igual al elemento.
; Se eliminan el elemento y la copia de los padres. Se sustituye el primer elemento del hijo
; por el primer elemento de copiaA y primer elemento de copiaB se vuelve el posible nuevo elemento.
; Se generan nuevas cpias de los padres y se vacía la del hijo.
(defrule CruceCX::Encontrar-elemento
        ?ele <- (elemento ?elemento)
        ?hijo <- (lista (estado hijoA)(datos ?h $?datosH))
        ?copiaH <- (lista (estado copiaH)(datos $?datosC))
        ?copiaA <- (lista (estado copiaA)(datos ?elemento $?datosA))
        ?copiaB <- (lista (estado copiaB)(datos ?b $?datosB))
        ?padreA <- (lista (estado padreA))
        ?padreB <- (lista (estado padreB))
        =>
        (retract ?copiaA)
        (retract ?copiaB)
        (retract ?ele)
        (modify ?hijo (datos $?datosC ?elemento $?datosH))
        (modify ?copiaH (datos))
        (duplicate ?padreA (estado copiaA))
        (duplicate ?padreB (estado copiaB))
        (assert (posible ?b))
)

; Regla que se dispara si el posible elemento no se encuentra ya en el hijo. 
; Se convierte en el nuevo elemento.
(defrule CruceCX::Nuevo-elemento
        ?posible <- (posible ?elemento)
        (not (lista (estado hijoA)(datos $? ?elemento $?)))
        =>
        (retract ?posible)
        (assert (elemento ?elemento))
)

; Regla que se dispara si el posible elemento se encuentra ya en el hijo.
; Se elimina el elemento y la copia del hijo. Se cambia el estado a temp y se crea una nueva copia.
(defrule CruceCX::Ciclo-detectado
        ?posible <- (posible ?elemento)
        ?hijo <- (lista (estado hijoA)(datos $?izq ?elemento $?der))
        ?copiaH <- (lista (estado copiaH))
        =>
        (retract ?posible)
        (retract ?copiaH)
        (modify ?hijo (estado temp))
        (duplicate ?hijo (estado hijoT)(datos))
)

; Regla que se dispara si el primer elemento de temp es una X. En el hijoT se introcue el primer elemento del padreB.
; Se eliminan el primer elemnto de las dos copias y de temp.
(defrule CruceCX::Completar-hijo
        ?hijo <- (lista (estado hijoT)(datos $?datosH))
        ?temp <- (lista (estado temp)(datos X $?datosT))
        ?copiaA <- (lista (estado copiaA)(datos ? $?datosA))
        ?copiaB <- (lista (estado copiaB)(datos ?b $?datosB))
        =>
        (modify ?hijo (datos $?datosH ?b))
        (modify ?temp (datos $?datosT))
        (modify ?copiaA (datos $?datosA))
        (modify ?copiaB (datos $?datosB))
)

; Regla que se dispara si el primer elemento de temp no es una X. En el hijoT se introcue dicho elemento.
; Se eliminan el primer elemnto de las dos copias y de temp.
(defrule CruceCX::Mantener-hijo
        ?hijo <- (lista (estado hijoT)(datos $?datosH))
        ?temp <- (lista (estado temp)(datos ?t $?datosT))
        ?copiaA <- (lista (estado copiaA)(datos ? $?datosA))
        ?copiaB <- (lista (estado copiaB)(datos ? $?datosB))
        (test (neq ?t X))
        =>
        (modify ?hijo (datos $?datosH ?t))
        (modify ?temp (datos $?datosT))
        (modify ?copiaA (datos $?datosA))
        (modify ?copiaB (datos $?datosB))
)

; Regla que se dispara cuando las copias esten vacías al genear el primer hijo.
; Se eliminan las copias, se cambia el estado del hijoT a hijo, del hijoB a hijoA 
; y se intercambia el estado de los padres.
(defrule CruceCX::Cambiar-hijo
        ?hijoA <- (lista (estado hijoT))
        ?copiaA <- (lista (estado copiaA)(datos))
        ?copiaB <- (lista (estado copiaB)(datos))
        ?hijoB <- (lista (estado hijoB))
        ?padreA <- (lista (estado padreA))
        ?padreB <- (lista (estado padreB))
        =>
        (modify ?hijoA (estado hijo))
        (retract ?copiaA)
        (retract ?copiaB)
        (modify ?hijoB (estado hijoA))
        (modify ?padreA (estado padreB))
        (modify ?padreB (estado padreA))
        (assert (primer))
)

; Resgla que se dispara cuando las copias esten vacías al genear el segundo hijo.
; Se cambia el estado de hijoT por hijo y se les añade a ambos el elemento 0 al inicio.
; Se eliminan los padres y sus copias.
(defrule CruceCX::Finalizar
        ?hijo <- (lista (estado hijo)(datos $?datos))
        ?hijoT <- (lista (estado hijoT)(datos $?datosT))
        ?copiaA <- (lista (estado copiaA)(datos))
        ?copiaB <- (lista (estado copiaB)(datos))
        ?padreA <- (lista (estado padreA))
        ?padreB <- (lista (estado padreB))
        =>
        (modify ?hijo (datos 0 $?datos))
        (modify ?hijoT (estado hijo)(datos 0 $?datosT))
        (retract ?copiaA)
        (retract ?copiaB)
        (retract ?padreA)
        (retract ?padreB)
)