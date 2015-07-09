#!/usr/bin/gnuplot

reset
set term png
set output "bar.png"
set style line 1 lc rgb "red"
set style line 2 lc rgb "blue"

set style fill solid
set boxwidth 0.5

if (!exists("datafile")) datafile='default.dat'
plot datafile using 1:($1<8 ? $2 : 1/0) with boxes ls 1, \
     datafile using 1:(($1>=8 && $1<16) ? $2 : 1/0) with boxes ls 2, \
     datafile using 1:(($1>=16 && $1<24) ? $2 : 1/0) with boxes ls 1, \
     datafile using 1:(($1>=24 && $1<32) ? $2 : 1/0) with boxes ls 2

#pause -1 "Hit any key to continue"
