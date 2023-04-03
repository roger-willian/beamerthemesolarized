# Limpa o ambiente
reset
set macros

# Cores do tema solarized
base03  = "#002b36"
base02  = "#073642"
base01  = "#586e75"
base00  = "#657b83"
base0   = "#839496"
base1   = "#93a1a1"
base2   = "#eee8d5"
base3   = "#fdf6e3"
yellow  = "#b58900"
orange  = "#cb4b16"
red     = "#dc322f"
magenta = "#d33682"
violet  = "#6c71c4"
blue    = "#268bd2"
cyan    = "#2aa198"
green   = "#859900"

# Paleta de cores
fundo         = base3
neutraA       = base01
neutraB       = base02
neutraC       = base03

primaria      = blue
secundaria    = cyan
terciaria     = green
quarta        = yellow
quinta        = orange
sexta         = red

# Linhas e pontos

## Tamanho do ponto
ponto = 0.5

## Espacinho na volta das amostras
set pointintervalbox 1.75*ponto

## Estilos principais
set style line  1 lt 1 pt 7 ps ponto lw 0.7 dt    1 lc rgbcolor primaria
set style line  2 lt 1 pt 7 ps ponto lw 0.7 dt    1 lc rgbcolor secundaria
set style line  3 lt 1 pt 7 ps ponto lw 0.7 dt    1 lc rgbcolor terciaria
set style line  4 lt 1 pt 7 ps ponto lw 0.7 dt    1 lc rgbcolor quarta
set style line  5 lt 1 pt 7 ps ponto lw 0.7 dt    1 lc rgbcolor quinta
set style line  6 lt 1 pt 7 ps ponto lw 0.7 dt    1 lc rgbcolor sexta

## Estilos secundários
set style line 20 lt 1 pt 0 ps ponto lw 0.5 dt    3 lc rgbcolor neutraA
set style line 21 lt 1 pt 0 ps ponto lw 0.5         lc rgbcolor neutraB


# Caminhos, arquivos e extensões
extdados      = 'dat'
extfig        = 'tex'
dirdados      = './data/'
dirfig        = '../latex/'
figura        = 'dirfig.substr(ARG0,1,strstrt(ARG0,".")).extfig'
dados(nome)   = dirdados.nome.'.'.extdados

# Configurações gerais
set key right bottom box ls 21 samplen 2 spacing 1.2
set grid back ls 20
set border back ls 21
set xtics nomirror
set ytics nomirror
set decimalsign '.'


# Configurações do terminal
proporcao     = 6.0/4.0            # L/A
larguramm     = 97.5               # L em mm
largura       = larguramm/25.4     # L em pol
altura        = largura/proporcao  # A em pol
autor         = 'Fulano de Tal (fulano.de.tal@exemplo.com)'
cabecalho     = '\usepackage[T1]{fontenc}'."\n".\
                '\usepackage[default]{Fira Sans}'."\n".\
                '\usepackage{newtxsf}'."\n".\
                '\usepackage[brazilian]{babel}'."\n".\
                '\input{brazilian_comma.ldf}'."\n"
linha         = 5
fonte         = 'hv,10'
terminal      = 'set terminal cairolatex pdf transparent standalone '.\
                'font fonte size largura,altura lw linha colortext '.\
                'header ''\pdfinfo{/Author (''.autor.'')}''.cabecalho '.\
                'background rgbcolor fundo'

## Reconfigura o terminal
@terminal
