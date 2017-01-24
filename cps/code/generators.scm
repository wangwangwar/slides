
; current-continuation : -> continuation
(define (current-continuation) 
  (call-with-current-continuation
    (lambda (cc)
      (cc cc))))

; void : -> void
(define (void)
  (if #f #t))

; tree-iterator : tree -> generator
(define (tree-iterator tree)
  (lambda (yield)

    ;; Walk the tree, yielding the leaves.

    (define (walk tree)
      (if (not (pair? tree))
        (yield tree)
        (begin
          (walk (car tree))
          (walk (cdr tree)))))

    (walk tree)))

; make-yield : continuation -> (value -> ...)
(define (make-yield for-cc)
  (lambda (value)
    (let ((cc (current-continuation)))
      (if (procedure? cc)
        (for-cc (cons cc value))
        (void)))))

; (for v in generator body) will execute body 
; with v bound to successive values supplied
; by generator.
(define-syntax for
  (syntax-rules (in)
                ((_ v in iterator body ...)
                 ; => 
                 (let ((i iterator)
                       (iterator-cont #f))
                   (letrec ((loop (lambda ()
                                    (let ((cc (current-continuation)))
                                      (if (procedure? cc)
                                        (if iterator-cont
                                          (iterator-cont (void))
                                          (iterator (make-yield cc)))
                                        (let ((it-cont (car cc))
                                              (it-val  (cdr cc)))
                                          (set! iterator-cont it-cont)
                                          (let ((v it-val))
                                            body ...)
                                          (loop)))))))
                     (loop))))))


; Prints:
; 3
; 4
; 5
; 6
(for v in (tree-iterator '(3 . ( ( 4 . 5 ) . 6 ) )) 
     (display v)
     (newline))

