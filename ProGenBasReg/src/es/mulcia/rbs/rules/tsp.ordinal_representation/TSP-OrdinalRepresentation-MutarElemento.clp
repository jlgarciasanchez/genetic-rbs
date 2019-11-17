; TSP-OrdinalRepresentation-MutarElemento.clp
; Problema del Viajante
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla
;============================================================================

; Plantilla que se usa para almacenar los elementos ya visitados.
(deftemplate MutarElemento::listaTemp
        (multislot datos)
)

;============================================================================

; Regla que genera dos números aleatorios entre 1 y p-1.
; E inicializa un iterador.
(defrule MutarElemento::Inicio
        (p ?p)
        (not (aleatorioA ?))
        =>
        (assert (listaTemp))
        (assert (iter (n 0)))
        (assert (aleatorioA (+ (mod (random) (- ?p 1))1)))
)

; Regla que genera dos números aleatorios entre 0 y p-a-1.
(defrule MutarElemento::Generar-segundo-aleatorio
        (p ?p)
        (aleatorioA ?a)
        (not (aleatorioB ?))
        =>
        (assert (aleatorioB (mod (random) (- ?p ?a))))
)

; Regla que se dispara mientras el valor del iterador sea menor que a.
; Mueve el primer elemento de la lista a la lista temporal.
(defrule MutarElemento::Contar
        (aleatorioA ?a)
        (aleatorioB ?)
        ?lista <- (lista (estado mutando)(datos ?primero $?otros))
        ?temp <- (listaTemp (datos $?datos))
        ?iter <- (iter (n ?n))
        (test (< ?n ?a))
        =>
        (modify ?lista (datos $?otros))
        (modify ?temp (datos $?datos ?primero))
        (modify ?iter (n (+ ?n 1)))
)

; Regla que se dispara cuando el iterador tiene el valor a.
; Modifica el valor del primer elemento de la lista por b y vuelve a introducir los elementos
; de la lista temporal en su sitio. Elimina los números aleatoros, la lista temporal y el iterador
; y pone fin a la ejecución del módulo.
(defrule MutarElemento::Finalizar
        ?alea <- (aleatorioA ?a)
        ?aleb <- (aleatorioB ?b)
        ?lista <- (lista (estado mutando)(datos ?primero $?otros))
        ?temp <- (listaTemp (datos $?datos))
        ?iter <- (iter (n ?a))
        =>
        (modify ?lista (estado preparada)(datos $?datos ?b $?otros))
        (retract ?alea)
        (retract ?aleb)
        (retract ?iter)
        (retract ?temp)
        (pop-focus)
)