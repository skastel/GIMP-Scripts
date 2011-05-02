; This is a test script that will create a simple text box somewhere on the screen
; lifted this from http://docs.gimp.org/en/gimp-using-script-fu-tutorial-first-script.html
(define (has-black-pixels theImage theLayer)
	(let*
			(
	     ;select black pixels, if any
			 (gimp-by-color-select theLayer `(0 0 0) 0 CHANNEL-OP-REPLACE FALSE FALSE 0 FALSE)
			 (bounds (gimp-selection-bounds theImage))
			)
		(car bounds)
	)
)

(define (script-fu-fix-neutral-gray theImage)
  (let*
      (
			 (origLayer (car (gimp-image-get-active-layer theImage)))
			 (imageHeight (car (gimp-image-height theImage)))
			 (imageWidth (car (gimp-image-width theImage)))
			 (grayLayer
				(car
				 (gimp-layer-new theImage imageWidth imageHeight RGB-IMAGE "gray layer" 100 DIFFERENCE)
				)
			 )
			 (copyLayer
				(car 
				 (gimp-layer-copy origLayer FALSE)
			  )
			 )
			 (workingLayer)
			 (lowThreshold 0)
			 (hasBlackPixels)
			)
		;Hide the original layer for now
		(gimp-layer-set-visible origLayer FALSE)
		(gimp-image-add-layer theImage copyLayer -1)
		(gimp-context-set-background '(255 255 255))
		(gimp-context-set-foreground '(127 127 127))
		(gimp-drawable-fill grayLayer FOREGROUND-FILL)
		(gimp-image-add-layer theImage grayLayer -1)
		;Merge the layer down, reassigning it to the grayLayer variable
		(set! grayLayer (car (gimp-image-merge-down theImage grayLayer EXPAND-AS-NECESSARY)))
		;Set the thresholds so that we only see things *below* neutral gray
		(set! workingLayer (car (gimp-layer-copy grayLayer 1)))
		(gimp-image-add-layer theImage workingLayer -1)
		(gimp-threshold workingLayer 1 128)
 		(while (> lowThreshold 128)
					 (gimp-image-remove-layer theImage workingLayer)
					 (set! workingLayer (car (gimp-layer-copy grayLayer 1)))
 					 (set! lowThreshold (+ lowThreshold 5))
					 (gimp-image-add-layer theImage workingLayer -1)
 					 (gimp-threshold workingLayer lowThreshold 128)
					 (set! hasBlackPixels (car (gimp-by-color-select workingLayer `(0 0 0) 0 CHANNEL-OP-REPLACE FALSE FALSE 0 FALSE)))
					 (if hasBlackPixels
							 (
							 (gimp-message (string-append "Finished at threshold:" (number->string lowThreshold)))
							 (set! lowThreshold 128)
							 )
					 )
 					 ;(gimp-displays-flush)
 		)
		(gimp-displays-flush)
	)
)
(script-fu-register
 "script-fu-fix-neutral-gray"               ;func name*
 "Find Grays"                                 ;menu label*
 "Find neutral grays on the current image." ;description*
 "Stephen Huenneke"      ;Author*
 "Copyright 2011"        ;Copyright*
 "April 30, 2011"        ;create date*
 "RGB"                      ;image type this works on*
 SF-IMAGE "Image" 0 ;the image we're working on
 SF-DRAWABLE "Layer" 0 ;background layer?
)
(script-fu-menu-register "script-fu-fix-neutral-gray" "<Image>/Image")
