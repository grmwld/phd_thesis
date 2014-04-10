TEX=pdflatex
TEXFALGS=-synctex=2 -interaction=nonstopmode
DEADTREE="\def\isdeadtree{1} \input{main.tex}"

BIB=bibtex
BIBFILE=Thesis.bib

GLS=makeglossaries

BASENAME=main
BUILD_DATE=$(shell date +'%Y%m%d')
E_OUT_FILENAME=These-Doctorat_AG_$(BUILD_DATE)
DEADTREE_OUT_FILENAME=These-Doctorat_AG_$(BUILD_DATE)-print

main.aux: $(BASENAME).tex
	$(TEX) $(TEXFALGS) $(BASENAME)

main.bbl: $(BASENAME).aux $(BIBFILE)
	$(BIB) $(BASENAME)

main.glsdefs: $(BASENAME).aux
	$(GLS) $(BASENAME)

.PHONY: all electronic deadtree clean

all: electronic deadtree

electronic: $(BASENAME).bbl $(BASENAME).glsdefs
	$(TEX) $(TEXFALGS) $(BASENAME)
	$(TEX) $(TEXFALGS) $(BASENAME)
	mv $(BASENAME).pdf $(E_OUT_FILENAME).pdf

deadtree: $(BASENAME).bbl $(BASENAME).glsdefs
	$(TEX) $(TEXFALGS) $(DEADTREE) $(BASENAME)
	$(TEX) $(TEXFALGS) $(DEADTREE) $(BASENAME)
	mv $(BASENAME).pdf $(DEADTREE_OUT_FILENAME).pdf

clean:
	rm -fv *.acn *.acr *.alg *.idx *.ist *.glsdefs *.aux *.bbl *.blg *.lof *.lot *.toc


