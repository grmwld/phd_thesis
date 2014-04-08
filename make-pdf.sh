PDFLATEX="/usr/texbin/pdflatex -synctex=2 -interaction=nonstopmode main.tex"
BIBTEX="/usr/texbin/bibtex main.aux"
GLOS="makeglossaries main"

rm main.acn main.acr main.alg main.idx main.ist main.glsdefs main.aux main.bbl main.blg main.lof main.lot main.toc

$PDFLATEX
$BIBTEX
$GLOS
$PDFLATEX
$PDFLATEX
