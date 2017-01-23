
; right-now : -> moment
(define (right-now)
  (call/cc
    (lambda (cc) 
      (cc cc))))

; go-when : moment -> ...
(define (go-when then)
  (then then))


; An infinite loop:
(let ((the-beginning (right-now)))
  (display "Hello, world!")
  (newline)
  (go-when the-beginning))
