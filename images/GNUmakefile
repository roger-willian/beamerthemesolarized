################################################################################
#  Makefile to generate the images for publishing
#  These programs must be installed:
#  - gnumake  (tested with version 4.2.1)
#  - pdflatex (tested with version 3.14159265-2.6-1.40.20 TeX Live 2019/Debian)
#  - inkscape (tested with versions 0.92 and 1.0)
#  - draw.io  (tested with version 15.84)
#
#  Additionally, tested with
#       GNU bash version 5.0.17(1)-release in a Kubuntu 20.04
#       xmllint using libxml version 20910
#
#  This file version: 2020-12-06
#  Author: Roger W. P. da Silva (williandmn@gmail.com)
################################################################################

################################################################################
#                             V A R I A B L E S                                #
################################################################################
## Programs
# use bash with extended file pattern expansion enabled
SHELL    := /bin/bash -O extglob

# LaTeX processor and command line parameters
TEX      := pdflatex
TEXFLAGS := -interaction=batchmode -halt-on-error

# SVG to PDF+LaTeX converter and command line parameters
INK     := inkscape
INKV    := $(INK) --version 2>&1 | grep '^Inkscape [0-9.]\+' | sed 's/^Inkscape \([0-9]\).*/\1/'
# since version 1.0 inkscape has changed the CLI options
MAJORV   := $(shell $(INKV))
ifeq "$(MAJORV)" "1"
    INKPDF := --export-filename
# reduce the warnings
		INKEX_DEPRECATION_LEVEL:=0
		export INKEX_DEPRECATION_LEVEL
else
    INKPDF := --export-pdf
endif
INKFLAGS := --export-dpi=300 --export-area-page --export-latex $(INKPDF)

# data to PDF+LaTeX plotting software and command line parameters
GP       := gnuplot
GPFLAGS  := -c

# DRAW.IO to PDF converter and command line parameters
DRW     := drawio
DRWFLAGS := -x -a -f pdf -o

## Directories and incude files
# Directories
SVGDIR  := svg
DRWDIR  := drawio
PDFDIR  := pdf
PLOTDIR := plots
DATADIR := $(PLOTDIR)/data
TEXDIR  := latex
# include files
PLOTH   := header.gp
TEMPLATE:= template.tex
TEXINC	:= $(TEMPLATE) brazilian_comma.ldf
SPACE :=
SPACE +=

################################################################################
#                        I M P L I C I T   R U L E S                           #
################################################################################
## Disable these implicit rules for performance and debug purposes
# remove implicit suffixes
.SUFFIXES:

# remove additional implicit rules
%: %,v

%: RCS/%,v

%: RCS/%

%: s.%

%: SCCS/s.%

################################################################################
#                               T A R G E T S                                  #
################################################################################
## phony targets
.PHONY: all clean clean-latex clean-all debug

## real targets type A (svg diagrams)
# uncomment this if there are *.svg files to be converted to *.pdf
SVGPDF := $(patsubst $(SVGDIR)/%.svg,$(PDFDIR)/%.pdf,$(wildcard $(SVGDIR)/*.svg))

## real targets type B (drawio diagrams)
# uncomment this if there are *.drawio files to be converted to *.pdf
DRWPDF := $(patsubst $(DRWDIR)/%.drawio,$(PDFDIR)/%.pdf,$(wildcard $(DRWDIR)/*.drawio))

## real targets option C (single plots)
# uncomment this if each *.plt file must generate only one *.pdf file
PLOTS    := $(patsubst $(PLOTDIR)/%.plt,$(PDFDIR)/%.pdf,$(wildcard $(PLOTDIR)/*.plt))

## intermediate targets
# uncomment this to avoid deleting these LaTeX intermediate files
.PRECIOUS: $(patsubst $(PDFDIR)/%.pdf,$(TEXDIR)/%.tex,$(PLOTS) $(SVGPDF) $(PLOTS))

################################################################################
#                                R U L E S                                     #
################################################################################
## Main rule: generates all the PDF images.
#  Prerequisites:
#    - $(SVGPDF) = the PDF files with the diagrams initially from SVGs
all: $(SVGPDF) $(DRWPDF) $(PLOTS)

## SVG to LaTeX: converts an SVG image into LaTeX and PDF using a LaTeX template.
#  Prerequisites:
#    - $(SVGDIR)/%.svg = an SVG file with line art and text
#    - $(TEMPLATE)     = a LaTeX file with the template model
#  Targets:
#    - $(TEXDIR)/%.tex         = a LaTeX file joining the two bellow:
#    - $(TEXDIR)/%-svg.pdf_tex = a LaTeX include file with the text
#    - $(TEXDIR)/%-svg.pdf     = a PDF file with the line art
$(TEXDIR)/%.tex $(TEXDIR)/%-svg.pdf_tex $(TEXDIR)/%-svg.pdf: $(SVGDIR)/%.svg $(TEXDIR)/$(TEMPLATE)
	$(INK) $(INKFLAGS) $(TEXDIR)/$(*F)-svg.pdf $< && \
	sed -e "s|<filename>|$(*F)-svg.pdf_tex|" $(TEXDIR)/$(TEMPLATE) > $(TEXDIR)/$(*F).tex
	(xmllint --xpath '//*[name()="dc:creator"]//*[name()="dc:title"]/text()' $< | xargs -I "{}" sed -i "s|<author>|{}|" $(TEXDIR)/$(*F).tex)
	@echo ""

## LaTeX to PDF: converts LaTeX and PDF files into self-contained PDF files.
#  Prerequisites:
#    - $(TEXDIR)/%.tex = a LaTeX file including the text and the line art
#  Targets:
#    - $(PDFDIR)/%.pdf = a final PDF file including the text and the line art
$(PDFDIR)/%.pdf: $(TEXDIR)/%.tex
	pushd $(TEXDIR) > /dev/null && \
	{ $(TEX) $(TEXFLAGS) $(<F) > /dev/null 2>&1 || { grep -e '^!' -A 3 $(*F).log && false; }; } && \
	rm $(*F).aux $(*F).log && \
	popd > /dev/null && \
	mv $(TEXDIR)/$(@F) $@
	@echo ""

## draw.io to PDF: converts a draw.io diagram to a PDF file
#  Prerequisites:
#    - $(DRWDIR)/%.drawio = a draw.io diagram
#  Targets:
#    - $(PDFDIR)/%.pdf    = a final PDF file including the text and the line art
$(PDFDIR)/%.pdf: $(DRWDIR)/%.drawio
	$(DRW) $(DRWFLAGS) $@ $<
	@echo ""

## Gnuplot to LaTeX: converts a gnuplot script and a data file into LaTeX using
#    a common configuration.
#  Prerequisites:
#    - $(PLOTDIR)/%.plt = a GNUPLOT script with instructions to generate the plot
#    - $(PLOTH)         = a GNUPLOT include file with some common configuration
#  Targets:
#    - $(TEXDIR)/%.tex     = a LaTeX file with the text of the plot
#    - $(TEXDIR)/%-inc.pdf = a PDF file with the line art of the plot
$(TEXDIR)/%.tex $(TEXDIR)/%-inc.pdf: $(PLOTDIR)/%.plt $(PLOTDIR)/$(PLOTH)
	cd $(PLOTDIR) && \
	$(GP) $(GPFLAGS) $(*F).plt
	@echo ""

## Soft cleaning: deletes the final PDF files generated.
clean:
	rm -f $(SVGPDF) $(DRWPDF)

## LaTeX cleaning: deletes all files in the latex directory except the template.
clean-latex:
	rm -f $(TEXDIR)/!($(subst $(SPACE),|,$(TEXINC)))

## Full cleaning: removes the final PDFs and cleans the latex directory.
clean-all: clean-latex
	rm -f $(PDFDIR)/*.pdf

## Debug info: displays useful debugging information.
debug:
	@echo "Inkscape major ver.:   $(MAJORV)"
	@echo ""
	@echo "LaTeX diagrams folder: $(TEXDIR)/"
	@printf "LaTeX template:      $(addprefix \n                       ,$(TEMPLATE))"
	@echo ""
	@echo "PDF images folder:     $(PDFDIR)/"
	@echo ""
	@printf "SVG > PDF:           $(addprefix \n                       ,$(SVGPDF))"
	@echo ""
	@printf "draw.io > PDF:       $(addprefix \n                       ,$(DRWPDF))"
	@echo ""
