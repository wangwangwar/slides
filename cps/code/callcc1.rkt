#lang racket 

(define cc #f)

(* 3 (call/cc (lambda (k)
                (set! cc k)
                (+ 1 2))))

(+ 100 (cc 3))
(+ 100 (cc 10))
