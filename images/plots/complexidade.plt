load 'config.gp'
autor = 'Roger Willian (github.com/roger-willian)'
@terminal

set key w 3.5 h 1 left top

set xrange [0:10]
set yrange [0:100]

set xlabel 'Quantidade de dados, $n$'
set ylabel 'Tempo, $t$'
set samples 501

set output @figura
plot  dados('cubica') w lp ls 5 pi -100 t '$O(n^3)$',\
      x**2     w lp ls 4 pi -100 t '$O(n^2)$',\
      x*log(x) w lp ls 3 pi -100 t '$O(n\log n)$',\
      x        w lp ls 2 pi -100 t '$O(n)$',\
      log(x)   w lp ls 1 pi -100 t '$O(\log n)$'
unset output