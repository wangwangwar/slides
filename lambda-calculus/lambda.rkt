#lang racket

(define cons
  (lambda (h)
    (lambda (l)
      (lambda (c)
        (lambda (n)
          ((c h) ((c l) n)))))))


(define true
  (lambda (x)
    (lambda (y)
      x)))

(define false
  (lambda (x)
    (lambda (y)
      y)))

(define c true)

(define nil false)

(define head
  (lambda (l)
    ((l true) false)))

(define l ((cons 1) false))

(head l)

(define isnil
  (lambda (l)
    (define return-false (lambda (_) (lambda (_) false)))
    ((l return-false)
     true)))

(isnil l)
(isnil nil)

