; TransporteLineal-Genetic1-DesordenarLista.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

;Todas estas reglas actúan sobre la lista "desordenando" seleccionada en el módulo "Inicializacion".

; Regla que crea una lista vacía con el mismo id que la lista desordenando.
(defrule DesordenarLista::Inicializar
        (lista (id ?id)(estado desordenando))
        (not (lista (id ?id)(estado pendiente)))
        =>
        (assert (lista (id ?id)(esfuerzo 0)(estado pendiente)))
)

; Regla que selecciona un numero aleatorio entre 0 y p-1.
(defrule DesordenarLista::Seleccionar-aleatorio
        (p ?p)
        (not (aleatorio ?))
        =>
        (assert (aleatorio (mod (random) ?p)))
)

; Regla que elimina el número aletoario de la lista ordenada y lo introduce en la desordenada.
(defrule DesordenarLista::Mover-dato-aleatorio
        ?aleatorio <- (aleatorio ?e)
        ?listaO <- (lista (id ?id)(datos $?inico ?e $?fin)(estado desordenando))
        ?listaD <- (lista (id ?id)(datos $?resto)(estado pendiente))
        =>
        (modify ?listaO (datos $?inico $?fin))
        (modify ?listaD (datos $?resto ?e))
        (retract ?aleatorio)
)
; Regla que se disapara si el numero aleatorio ya esta en la lista desordenada y evita que la ejecución se bloqué.
(defrule DesordenarLista::Elemento-no-encontrado
        (lista (id ?id)(datos $?inico ?e $?fin)(estado pendiente))
        (not (lista (datos)(estado desordenando)))
        ?aleatorio <- (aleatorio ?e)
        =>
        (retract ?aleatorio)
)

; Regla que se dispara cuando la lista ordenada se encuentra vacía,
; finalizando la ejecución del módulo y eliminando las variables temporales.
(defrule DesordenarLista::Finalizar
        ?aleatorio <- (aleatorio ?)
        ?list <- (lista (datos)(estado desordenando))
        =>
        (retract ?list)
        (retract ?aleatorio)
        (pop-focus)
)