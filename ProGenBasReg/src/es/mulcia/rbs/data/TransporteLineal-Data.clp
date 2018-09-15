; Datos.clp
; Problema del Transporte
; Programación Genética Basada en Reglas
; Master Universitario en Lógica Programación e Inteligencia Artificial
; Universidad de Sevilla
;============================================================================

(deffacts datos-iniciales
        (n 3)
        (k 4)
        (fuente (id 0) (mercancia-total 15)(mercancia-actual 0))
        (fuente (id 1) (mercancia-total 25)(mercancia-actual 0))
        (fuente (id 2) (mercancia-total 5)(mercancia-actual 0))
        (destino (id 0) (mercancia-total 5)(mercancia-actual 0))
        (destino (id 1) (mercancia-total 15)(mercancia-actual 0))
        (destino (id 2) (mercancia-total 15)(mercancia-actual 0))
        (destino (id 3) (mercancia-total 10)(mercancia-actual 0))
        (esfuerzo (fuente 0) (destino 0) (esfuerzo 10))
        (esfuerzo (fuente 0) (destino 1) (esfuerzo 0))
        (esfuerzo (fuente 0) (destino 2) (esfuerzo 20))
        (esfuerzo (fuente 0) (destino 3) (esfuerzo 11))
        (esfuerzo (fuente 1) (destino 0) (esfuerzo 12))
        (esfuerzo (fuente 1) (destino 1) (esfuerzo 7))
        (esfuerzo (fuente 1) (destino 2) (esfuerzo 9))
        (esfuerzo (fuente 1) (destino 3) (esfuerzo 20))
        (esfuerzo (fuente 2) (destino 0) (esfuerzo 0))
        (esfuerzo (fuente 2) (destino 1) (esfuerzo 14))
        (esfuerzo (fuente 2) (destino 2) (esfuerzo 16))
        (esfuerzo (fuente 2) (destino 3) (esfuerzo 18))
)
