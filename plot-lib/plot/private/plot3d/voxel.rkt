#lang typed/racket/base

(require racket/match typed/racket/class
         (only-in typed/pict pict)
         plot/utils
         "../common/type-doc.rkt"
         "../common/utils.rkt")

(provide (all-defined-out))

;; =====================================================

(: matrix3d-render-proc (-> (Vectorof (Vectorof (Vectorof Boolean)))
                            Plot-Color Plot-Brush-Style
                            Plot-Color Nonnegative-Real Plot-Pen-Style
                            Nonnegative-Real
                            3D-Render-Proc))
(define ((matrix3d-render-proc vs color style line-color line-width line-style alpha) area)
  (send area put-pen line-color line-width line-style)
  (send area put-brush color style)
  (send area put-alpha alpha)
  (send area put-voxels vs))

(:: matrix3d
    (->* [(Vectorof (Vectorof (Vectorof Boolean)))]
         [#:color Plot-Color
          #:style Plot-Brush-Style
          #:line-color Plot-Color
          #:line-width Nonnegative-Real
          #:line-style Plot-Pen-Style
          #:alpha Nonnegative-Real
          #:label (U String pict #f)]
         renderer3d))

(define (matrix3d vs
                #:color [color (rectangle-color)]
                #:style [style (rectangle-style)]
                #:line-color [line-color (rectangle-line-color)]
                #:line-width [line-width (rectangle3d-line-width)]
                #:line-style [line-style (rectangle-line-style)]
                #:alpha [alpha (rectangle-alpha)]
                #:label [label #f])
  (define fail/kw (make-raise-keyword-error 'voxels))
  (cond
    [(not (rational? line-width))  (fail/kw "rational?" '#:line-width line-width)]
    [(or (> alpha 1) (not (rational? alpha)))  (fail/kw "real in [0,1]" '#:alpha alpha)]
    [(null? vs)  empty-renderer3d]
    [else
     (let ([x-min 0]
           [y-min 0]
           [z-min 0]
           [x-max (- (vector-length vs) 1)]
           [y-max (- (vector-length (vector-ref vs 0)) 1)]
           [z-max (- (vector-length (vector-ref (vector-ref vs 0) 0)) 1)])
       (renderer3d (vector (ivl x-min x-max) (ivl y-min y-max) (ivl z-min z-max)) #f
                   default-ticks-fun
                   (and label (λ (_) (rectangle-legend-entry
                                      label color style line-color line-width line-style)))
                   (matrix3d-render-proc vs color style line-color line-width line-style
                                             alpha)))]))















