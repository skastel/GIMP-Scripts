; This is a test script that will create a simple text box somewhere on the screen
; lifted this from http://docs.gimp.org/en/gimp-using-script-fu-tutorial-first-script.html
(define (script-fu-text-box inText inFont inFontSize inTextColor)
  (let*
      (
       ;define some local variables
       (theImageWidth 256)
       (theImageHeight 256)
       ;create a new image:
       (theImage
				(car 
				 (gimp-image-new theImageWidth theImageHeight RGB)
			  )
       )
			 ;empty declaration for use later.
			 (theText)
			 (theLayer
				(car
				 (gimp-layer-new theImage theImageWidth theImageHeight RGB-IMAGE "foobar" 100 NORMAL)
				 )
				)
      )
		(gimp-image-add-layer theImage theLayer 0)
		(gimp-context-set-background '(255 255 255))
		(gimp-context-set-foreground inTextColor)
		(gimp-drawable-fill theLayer BACKGROUND-FILL)
		(set! 
		 theText
		 (car 
			(gimp-text-fontname theImage theLayer 0 0 inText 0 TRUE inFontSize PIXELS "Sans")
		 )
		)
		(set! theImageWidth   (car (gimp-drawable-width  theText) ) )
		(set! theImageHeight  (car (gimp-drawable-height theText) ) )

		(gimp-image-resize theImage theImageWidth theImageHeight 0 0)

		(gimp-layer-resize theLayer theImageWidth theImageHeight 0 0)
		(gimp-display-new theImage)
  )
 )
(script-fu-register
 "script-fu-text-box"                       ;func name*
 "Text Box"                                 ;menu label*
 "Created a simple text box, sized to fit\
    around the user's coice of text,\
    font, font size, and color."            ;description*
 "Stephen Huenneke"      ;Author*
 "copyright never"       ;Copyright*
 "April 30, 2011"        ;create date*
 ""                      ;image type this works on*
 SF-STRING        "TEXT"         "Text Box" ;a string variable
 SF-FONT          "FONT"         "Charter"  ;a font variable
 SF-ADJUSTMENT    "FONT SIZE"    '(50 1 1000 1 10 0 1) ;a spin-button
 SF-COLOR         "COLOR"        '(0 0 0)   ;a color variable
)
(script-fu-menu-register "script-fu-text-box" "<Image>/File/Create/Text")
