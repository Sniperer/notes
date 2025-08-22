(TeX-add-style-hook
 "main"
 (lambda ()
   (TeX-add-to-alist 'LaTeX-provided-class-options
                     '(("article" "12pt")))
   (TeX-add-to-alist 'LaTeX-provided-package-options
                     '(("geometry" "a4paper" "centering" "scale=0.8") ("authblk" "affil-it")))
   (TeX-run-style-hooks
    "latex2e"
    "../share/macro"
    "../share/cc"
    "article"
    "art12"
    "geometry"
    "authblk")
   (TeX-add-symbols
    "allfiles"))
 :latex)

