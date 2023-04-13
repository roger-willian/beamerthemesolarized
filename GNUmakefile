################################################################################
#  Makefile para gerar a apresetação de slides e as imagens.
#  É necessário que os seguintes programas estejam instalados:
#  - gnumake      (para processar este arquivo)
#  - texlive-full (para processar os arquivos em LaTeX)
#  Dependendo do tipo de imagens utilizadas, também podem ser necessários:
#  - inkscape     (para converter SVG para LaTeX + PDF)
#  - gnuplot      (para converter plt para LaTeX + PDF)
#  - drawio       (para converter drawio para PDF)
#
#  This file version: 2023-04-13
#  Author: Roger W. P. da Silva (github.com/roger-willian)
################################################################################

################################################################################
#                             V A R I Á V E I S                                #
################################################################################
## Programas
# bash com a expansão de padrão de caminho de arquivos estendida habilitada
SHELL    := /bin/bash -O extglob

# Processador do LaTeX e parâmetros da linha de comando
TEX      := pdflatex
TEXFLAGS := -interaction=batchmode -halt-on-error
# Processador do LaTeX+bibtex e parâmetros da linha de comando
TEXMK      := latexmk
TEXMKFLAGS := -synctex=1 --shell-escape -interaction=nonstopmode \
              -file-line-error -pdf

# Conversor de SVG para PDF+LaTeX e parâmetros da linha de comando
INK      := inkscape
INKV     := $(INK) --version 2>&1 | grep '^Inkscape [0-9.]\+' | sed 's/^Inkscape \([0-9]\).*/\1/'
# as opções da CLI do inkscape para versão 1.* mudaram
MAJORV   := $(shell $(INKV))
ifeq "$(MAJORV)" "1"
    INKPDF := --export-filename
# desabilita alguns avisos
    INKEX_DEPRECATION_LEVEL:=0
    export INKEX_DEPRECATION_LEVEL
else
    INKPDF := --export-pdf
endif
INKFLAGS := --export-dpi=300 --export-area-page --export-latex $(INKPDF)

# gnuplot para converter dados para PDF+LaTeX e parâmetros da linha de comando
GP       := gnuplot
GPFLAGS  := -c

# drawio para converter diagramas para PDF e parâmetros da linha de comando
DRW      := drawio
DRWFLAGS := -x -a -f pdf -o

## Diretórios
# Diagramas em SVG
SVGDIR  := images/svg
# Diagramas do drawio
DRWDIR  := images/drawio
# Imagens finais em PDF
PDFDIR  := images/pdf
# Scripts do gnuplot
PLTDIR  := images/plots
# Dados para os gráficos do gnuplot
DATADIR := $(PLTDIR)/data
# Imagens intermediárias em LaTeX+PDF
TEXDIR  := images/latex

## Arquivos
# Configurações padrão do gnuplot
PLTCFG  := config.gp
# Modelo padrão das imagens intermediárias geradas de arquivos SVG
MODELO  := modelo-svg.tex
# Arquivo para tratar espaçamento incorreto em números com vírgula
VIRGULA := brazilian_comma.ldf
# Arquivo com as informações bibliográficas
BIBLIO  := referencias.bib
# Arquivo principal
SLIDES  := slides.tex

################################################################################
#                   R E G R A S   I M P L I C I T A S                          #
################################################################################
## Desabilita algumas regras implícitas para melhorar a performance e facilitar
## a depuração de erros.
# remove sufixos implícitos
.SUFFIXES:

# remove outras regras implícitas
%: %,v

%: RCS/%,v

%: RCS/%

%: s.%

%: SCCS/s.%

################################################################################
#                               A L V O S                                      #
################################################################################
## alvos falsos
.PHONY: all images svgtex plttex texpdf drwpdf clean clean-latex clean-all debug

## Diagramas SVG
# Descomente essas linhas se existem arquivos *.svg para converter para *.pdf
SVGPDF := $(patsubst $(SVGDIR)/%.svg,$(PDFDIR)/%.pdf,$(wildcard $(SVGDIR)/*.svg))
SVGTEX := $(patsubst $(SVGDIR)/%.svg,$(TEXDIR)/%.tex,$(wildcard $(SVGDIR)/*.svg))

## Diagramas do drawio
# Descomente essas linhas se existem arquivos *.drawio para converter para *.pdf
DRWPDF := $(patsubst $(DRWDIR)/%.drawio,$(PDFDIR)/%.pdf,$(wildcard $(DRWDIR)/*.drawio))

## Gráficos dos gnuplot
# Descomente essas linhas se cada arquivo *.plt deve gerar um arquivo *.pdf
PLTPDF    := $(patsubst $(PLTDIR)/%.plt,$(PDFDIR)/%.pdf,$(wildcard $(PLTDIR)/*.plt))
PLTTEX    := $(patsubst $(PLTDIR)/%.plt,$(TEXDIR)/%.tex,$(wildcard $(PLTDIR)/*.plt))

## Alvos intermediários
# Descomente para evitar que esses arquivos LaTeX intermediários sejam deletados
.PRECIOUS: $(patsubst $(PDFDIR)/%.pdf,$(TEXDIR)/%.tex,$(PLTPDF) $(SVGPDF))

################################################################################
#                                R E G R A S                                   #
################################################################################
## Regra principal: gera o PDF final do LaTeX e das imagens em PDF
#	 Prerequisitos:
#    - images    = as imagens em PDF
#    - $(SLIDES) = o arquivo LaTeX com os slides
#    - $(BIBLIO) = o arquivo BiBTeX com as referências
all: images $(SLIDES) $(BIBLIO)
	$(TEXMK) $(TEXMKFLAGS) $(SLIDES)

## Figuras: gera todas as figuras em PDF
#  Prerequisitos:
#    - $(SVGPDF) = os arquivos PDF gerados dos diagramas SVG
#    - $(DRWPDF) = os arquivos PDF gerados dos diagramas do drawio
#    - $(PLTPDF) = os arquivos PDF gerados dos gráficos do gnuplot
images: svgtex plttex texpdf drwpdf

## SVG para LaTeX+PDF: converte todos os SVGs para LaTeX+PDF
svgtex: $(SVGTEX)

## SVG para LaTeX+PDF: converte um único SVG para LaTeX+PDF usando o modelo
#  Prerequisitos:
#    - $(SVGDIR)/%.svg = um arquivo SVG com o diagrama e texto
#    - $(MODELO)       = um arquivo LaTeX com o modelo de figura completa
#  Alvos:
#    - $(TEXDIR)/%.tex         = um arquivo LaTeX para unir os seguintes:
#    - $(TEXDIR)/%-svg.pdf_tex = um arquivo LaTeX com o texto do diagrama
#    - $(TEXDIR)/%-svg.pdf     = um arquivo PDF com as linhas, cores, etc.
$(TEXDIR)/%.tex $(TEXDIR)/%-svg.pdf_tex $(TEXDIR)/%-svg.pdf: $(SVGDIR)/%.svg $(TEXDIR)/$(MODELO)
	$(INK) $(INKFLAGS) $(TEXDIR)/$(*F)-svg.pdf $< && \
	sed -e "s|<filename>|$(*F)-svg.pdf_tex|" $(TEXDIR)/$(MODELO) > $(TEXDIR)/$(*F).tex
	(pdfinfo $(TEXDIR)/$(*F)-svg.pdf | grep 'Author:' | sed 's/Author:\s\+//' | xargs -I "{}" sed -i "s|<author>|{}|" $(TEXDIR)/$(*F).tex)
	@echo ""

## Gráfico para LaTeX+PDF: converte todos os gráficos para LaTeX+PDF
plttex: $(PLTTEX)

## Gráfico para LaTeX+PDF: converte um único gráfico para LaTeX+PDF usando uma
## configuração comum.
#  Prerequisitos:
#    - $(PLTDIR)/%.plt = um script gnuplot com comandos para gerar o gráfico
#    - $(PLTCFG)       = um script gnuplot com a configuração comum
#  Alvos:
#    - $(TEXDIR)/%.tex     = um arquivo LaTeX com o texto do gráfico
#    - $(TEXDIR)/%-inc.pdf = um arquivo PDF com as linhas, cores, etc.
$(TEXDIR)/%.tex $(TEXDIR)/%-inc.pdf: $(PLTDIR)/%.plt $(PLTDIR)/$(PLTCFG)
	cd $(PLTDIR) && \
	$(GP) $(GPFLAGS) $(*F).plt
	@echo ""

## LaTeX+PDF para PDF: converte todas as figuras LaTeX+PDF para arquivos PDF
texpdf: $(SVGPDF) $(PLTPDF)

## LaTeX+PDF para PDF: converte um único conjunto de dois ou três arquivos em um
## único PDF completo contendo a figura.
#  Prerequisitos:
#    - $(TEXDIR)/%.tex = um arquivo LaTeX que conecta texto e imagens
#    - não incuído     = possivelmente, um arquivo LaTeX que contém só o texto
#  Alvo:
#    - $(PDFDIR)/%.pdf = um arquivo PDF com as linhas, cores, etc
$(PDFDIR)/%.pdf: $(TEXDIR)/%.tex
	pushd $(TEXDIR) > /dev/null && \
	{ $(TEX) $(TEXFLAGS) $(<F) > /dev/null 2>&1 || { grep -e '^!' -A 3 $(*F).log && false; }; } && \
	rm -f $(*F).aux $(*F).log && \
	popd > /dev/null && \
	mv $(TEXDIR)/$(@F) $@
	@echo ""

## drawio para PDF: converte todos os diagramas do drawio para PDF
drwpdf: $(DRWPDF)

## drawio para PDF: converte um único arquivo com diagrama do drawio para PDF
#  Prerequisitos:
#    - $(DRWDIR)/%.drawio = um diagrama do drawio
#  Alvo:
#    - $(PDFDIR)/%.pdf    = o diagrama convertido para PDF com todas as páginas
$(PDFDIR)/%.pdf: $(DRWDIR)/%.drawio
	$(DRW) $(DRWFLAGS) $@ $< --no-sandbox
	@echo ""

## Limpeza leve: deleta os arquivos PDF finais das figuras
clean:
	rm -f $(SVGPDF) $(PLTPDF) $(DRWPDF)

## Limpeza pesada: deleta todos os arquivos das figuras em LaTeX gerados
clean-latex:
	rm -f $(TEXDIR)/!($(VIRGULA)|$(MODELO))

## Limpeza completa: remove todos os arquivos gerados
clean-all: clean clean-latex
	rm -f slides.!(tex)

## Informações de depuração: mostra informações úteis para depuração
TAB:= $(addprefix \n                        ,\b)
debug:
	@echo   ""
	@echo   "ARQUIVOS FONTES"
	@echo   "-----------------------"
	@echo   "LaTeX principal:       $(SLIDES)"
	@echo   "BiBTeX bibliografia:   $(BIBLIO)"
	@echo   "Pasta figuras LaTeX:   $(TEXDIR)/"
	@echo   "Modelo fig. LaTeX:     $(TEXDIR)/$(MODELO)"
	@echo   "Vírgula portugês:      $(TEXDIR)/$(VIRGULA)"
	@echo   "Pasta diagramas SVG:   $(SVGDIR)/"
	@echo   "Pasta gráf. gnuplot:   $(PLTDIR)/"
	@echo   "Pasta dados gnuplot:   $(DATADIR)/"
	@echo   "Pasta diagr. drawio:   $(DRWDIR)/"
	@echo   "Pasta figuras PDF:     $(PDFDIR)/"
	@echo   ""
	@echo   "ARQUIVOS INTERMEDIÁROS"
	@echo   "-----------------------"
	@printf "SVG > LaTeX:           $(addprefix $(TAB),$(SVGTEX))\n"
	@printf "gnuplot > LaTeX:       $(addprefix $(TAB),$(PLTTEX))\n"
	@echo   ""
	@echo   "ARQUIVOS FINAIS"
	@echo   "-----------------------"
	@echo   "PDF principal:         $(patsubst %.tex,%.pdf,$(SLIDES))"
	@printf "SVG > PDF:             $(addprefix $(TAB), $(SVGPDF))\n"
	@printf "gnuplot > PDF:         $(addprefix $(TAB), $(PLTPDF))\n"
	@printf "drawio > PDF:          $(addprefix $(TAB), $(DRWPDF))\n"
	@echo   ""
	@echo   "Versão major Inkscape: $(MAJORV)"
	@echo   ""


## Rodar no Docker: roda toda a compilação em containers no Docker
#  Para rodar é preciso apenas ter o docker instalado
.PHONY: docker
PWD := $(shell pwd)
docker:
	docker run --rm -v $(PWD):$(PWD) -w $(PWD) rogerwillian/latex-figs make svgtex plttex && \
	docker run --rm -v $(PWD):$(PWD) -w $(PWD) rogerwillian/drawio make drwpdf && \
	docker run --rm -v $(PWD):$(PWD) -w $(PWD) texlive/texlive make texpdf && \
	docker run --rm -v $(PWD):$(PWD) -w $(PWD) texlive/texlive latexmk -pdf slides.tex