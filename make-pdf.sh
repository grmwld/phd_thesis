PDFLATEX="/usr/texbin/pdflatex -synctex=2 -interaction=nonstopmode main.tex"
BIBTEX="/usr/texbin/bibtex main.aux"
GLOS="makeglossaries main"

$PDFLATEX
$BIBTEX
$GLOS
$PDFLATEX
$PDFLATEX
