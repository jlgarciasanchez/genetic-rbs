; TransporteLineal-Genetic2-Inicializacion.clp
; Problema Lineal del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; José Luis García Sánchez
; Universidad de Sevilla

;============================================================================

; Regla que fija como mejor solución una lista vacía con esfuerzo -1 y llama a GenerarLista.
(defrule Inicializacion::Inicio
        (not (it ?))
        =>
        (assert(it 0))
        (assert (solucion (id -1)(estado mejor)(esfuerzo -1)))
        (focus GenerarLista)
)

; Regla que se dispara hasta que se hayan generado suficientes listas desordenadas, crea una copia de la lista ordenda 
; y llama a DesordenarLista para que la desordene.
(defrule Inicializacion::Generar-listas-desordenadas
        ?iter <- (it ?x)
        ?list <- (lista (estado ordenada))
        (not (nElementos ?x))
        =>
        (duplicate ?list (id ?x)(estado desordenando))
        (assert (it (+ ?x 1)))
        (retract ?iter)
        (focus DesordenarLista)
)

; Regla que se encarga de rellenar la mercacia actual de las fuentes.
(defrule Inicializacion::Rellenar-fuentes
        ?fuente <- (fuente (mercancia-total ?m)(mercancia-actual 0))
        =>
        (modify ?fuente (mercancia-actual ?m))
)

; Regla que se encarga de rellenar la mercacia actual de los destinos.
(defrule Inicializacion::Rellenar-destinos
        ?destino <- (destino (mercancia-total ?m)(mercancia-actual 0))
        =>
        (modify ?destino (mercancia-actual ?m))
)

; Regla que se dispara hasta que se hayan generado suficientes listas desordenadas, crea una copia de la lista ordenda 
; y llama a DesordenarLista para que la desordene.
(defrule Inicializacion::Generar-matriz
        ?list <- (lista (id ?id) (estado pendiente))
        (not (fuente (mercancia-actual 0)))
        (not (destino (mercancia-actual 0)))
        =>
        (assert (solucion (id ?id) (esfuerzo 0) (estado pendiente)))
        (modify ?list (estado actual))
        (focus GenerarMatriz)
)

; Regla que se dispara una vez haya suficientes listas, se borra la lista ordenada y se pone fin a la ejecución del módulo.
(defrule Inicializacion::Finalizar
        ?iter <- (it ?x)
        ?list <- (lista (id -1))
        (nElementos ?x)
        (not (lista (estado pendiente)))
        =>
        (retract ?iter)
        (retract ?list)
        (pop-focus)
)