set terminal pngcairo size 1280,480 enhanced font 'Verdana,18'

set auto x

set style data histogram
set style histogram cluster gap 2
set style fill solid border -1
set boxwidth 0.85 relative
set key font ",14"
set key top left
set key width -10
set grid

set output "./dat/baware_sunflow_histo_consumed.png"

set title "Sunflow Battery-Exception Run"
set ylabel "Energy Consumed (J)"
set xlabel "Application Data Mode"

plot './dat/baware_sunflow_histo_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#8B0000",\
