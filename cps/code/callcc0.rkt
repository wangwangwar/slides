#lang racket

; Example 1

; CPS is a programming style in which the successive function(s)
; that uses the result of current function is given as an argument
; of the current function.
; In k+ and k*, k is the successive function.

(define (return x)
  x)

(define (k+ a b k)
  (k (+ a b)))

(define (k* a b k)
  (k (* a b)))

; (* 3 (+ 1 2))
; in cps
(k+ 1 2
    (lambda (x)
      (k* x 3 return)))

; ((lambda (x) (k* x 3 return)) (+ 1 2))
; ((lambda (x) (k* x 3 return)) 3)
; (k* 3 3 return)
; (return (* 3 3))
; (return 9)
; 9

; CPS 的好处：
; 如果语言支持尾递归优化(Tail recursion optimization)，那么 CPS 变换可以把不支持尾递归优化的代码变换成支持。
; 误，见 http://stackoverflow.com/questions/6817613/continuation-passing-style-makes-things-tail-recursive

; Recursive Functions written in CPS

;;; normal factorial
(define (fact n)
  (if (= n 1) 
      1
      (* n (fact (- n 1)))))

;;; CPS factorial
(define (kfact n k)
  (if (= n 1) 
      (k 1)
      (kfact (- n 1) (lambda (x) (k (* n x))))))

;(fact 1000000000)
(kfact 1000000000 return)