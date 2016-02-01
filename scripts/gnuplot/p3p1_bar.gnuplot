#!/usr/bin/gnuplot

reset
set term png
set output "p3p1_bar.png"
set style line 1 lc rgb "red"
set style line 2 lc rgb "blue"

set style fill solid
set boxwidth 0.5

if (!exists("datafile")) datafile='default.dat'
#datafile='p3p1-.txt'
plot datafile using 1:($1<10 ? $2 : 1/0) with boxes ls 1, \
     datafile using 1:(($1>=10 && $1<20) ? $2 : 1/0) with boxes ls 2, \
     datafile using 1:(($1>=20 && $1<30) ? $2 : 1/0) with boxes ls 1, \
     datafile using 1:(($1>=30 && $1<40) ? $2 : 1/0) with boxes ls 2

#pause -1 "Hit any key to continue"
