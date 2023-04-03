<!-- [![principal](https://github.com/roger-willian/beamerthemesolarized/actions/workflows/principal.yml/badge.svg)](https://github.com/roger-willian/beamerthemesolarized/actions/workflows/principal.yml) -->

# Tema solarized para o Beamer

Esse repositório contém um tema de apresentação do Beamer que utiliza o modelo de cores solarized que pode ser encontrado [aqui](https://ethanschoonover.com/solarized/).

# Gerar o PDF

A seguir, algumas instruções para gerar o PDF com os slides.

## Arquivos estritamente necessários

Os arquivos do estilo do Beamer são esses:

```
beamercolorthemesolarized.sty
beamerfontthemesolarized.sty
beamerinnerthemesolarized.sty
beamerouterthemesolarized.sty
beamerthemesolarized.sty
bg-others.pdf
bg-secao.pdf
bg-titulo.pdf
```

Além desses, é preciso um arquivo em LaTeX com os slides como o arquivo `slides.tex` e, se for usar referências bibliográficas, um arquivo BibTeX como o arquivo `referencias.bib`.

## Arquivos de exemplo

São fornecidos como exemplos alguns arquivos de imagens nos diretórios `images/pdf/` e `images/bitmap/`.
Por fim, também são fornecidos como exemplos, arquivos de códigos fontes na linguagem C no diretório `code/`.

## Sugestões de como gerar

São sugeridas duas maneiras de produzir os slides:

1. Gerar localmente com o latexmk
2. Gerar remotamente com o Overleaf

### Latexmk

Aqui é assumido que o TexLive e o latexmk já estão instalados na máquina.
Se ainda não instalou, veja a seção [Dependências](#dependencias)
Baixe o arquivo compactado com a release desejada [aqui](https://github.com/roger-willian/beamerthemesolarized/releases).
Descompacte o arquivo para um diretório próprio.
Entre no diretório e use o seguinte comando para gerar o PDF:

`latexmk -pdf slides.tex`

### Overleaf

O [Overleaf](https://www.overleaf.com) é um serviço de edição de LaTeX e geração de PDF muito usado no meio acadêmico.

Para copiar os arquivos necessários para um novo projeto no Overleaf e já sair editando esse projeto, basta clicar [aqui](https://www.overleaf.com/docs?snip_uri=https://github.com/roger-willian/beamerthemesolarized/releases/download/v1.0.0/release.zip).

# <a name="dependencias"></a>Dependências

Para instalar o TexLive e o latexmk no Ubuntu, use:

```
apt-get -y update && apt-get install -y \
texlive-latex-extra \
texlive-fonts-extra \
texlive-publishers \
texlive-science \
texlive-lang-portuguese \
latexmk
```

## Dependências adicionais

Essa seção mostra um uso avançado, não é necessária para o uso básico do modelo.

As imagens ilustradas no modelo são geradas automaticamente através de um `Makefile`.
Se souber como usar, pode utilizar com as seguintes dependências:

- gnumake
- pdflatex
- inkscape
- draw.io

Para instalar no ubuntu, basta digitar:

```
apt-get -y update && apt-get install -y \
make \
gnuplot \
inkscape \
drawio \
libxml2-utils

snap install drawio
```

A partir daí pode entrar no diretório `images/` e digitar

`make -B`

assumindo que os arquivos seguem o mesmo padrão dos que já estão lá.