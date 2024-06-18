#lang typed/racket/base

(require typed/racket/class
         plot/utils)

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



















