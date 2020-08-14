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

set output "./dat/baware_sunflow_consumed.png"

set title "Sunflow Battery-Exception Run"
set ylabel "Energy Consumed (J)"
set xlabel "Application Data Mode"

plot './dat/baware_sunflow_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#8B0000",\
     '' u 4 ti col lc rgb "#0000CD",\
     '' u 5 ti col lc rgb "#00008B",\
     '' u 6 ti col lc rgb "#2E8B57",\
     '' u 7 ti col lc rgb "#006400"

set output "./dat/baware_crypto_consumed.png"

set title "Crypto Battery-Exception Run"

plot './dat/baware_crypto_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#8B0000",\
     '' u 4 ti col lc rgb "#0000CD",\
     '' u 5 ti col lc rgb "#00008B",\
     '' u 6 ti col lc rgb "#2E8B57",\
     '' u 7 ti col lc rgb "#006400"


set title "Pagerank Battery-Exception Run"
set ylabel "Energy Consumed (J)"
set xlabel "Application Data Mode"


set output "./dat/baware_pagerank_consumed.png"

set yrange [0:6000]
set ytics auto

plot './dat/baware_pagerank_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#8B0000",\
     '' u 4 ti col lc rgb "#0000CD",\
     '' u 5 ti col lc rgb "#00008B",\
     '' u 6 ti col lc rgb "#2E8B57",\
     '' u 7 ti col lc rgb "#006400"


set output "./dat/baware_findbugs_consumed.png"

set title "Findbugs Battery-Exception Run"

plot './dat/baware_findbugs_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#8B0000",\
     '' u 4 ti col lc rgb "#0000CD",\
     '' u 5 ti col lc rgb "#00008B",\
     '' u 6 ti col lc rgb "#2E8B57",\
     '' u 7 ti col lc rgb "#006400"

set output "./dat/baware_jspider_consumed.png"

set title "JSpider Battery-Exception Run"
set ylabel "Energy Consumed in (j)"
set yrange [0:250]
set ytics 50

plot './dat/baware_jspider_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#8B0000",\
     '' u 4 ti col lc rgb "#0000CD",\
     '' u 5 ti col lc rgb "#00008B",\
     '' u 6 ti col lc rgb "#2E8B57",\
     '' u 7 ti col lc rgb "#006400" 

set output "./dat/baware_batik_consumed.png"

set title "Batik Battery-Exception Run"
set ylabel "Energy Consumed in (j)"
set yrange [0:30]
set ytics 5

plot './dat/baware_batik_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#8B0000",\
     '' u 4 ti col lc rgb "#0000CD",\
     '' u 5 ti col lc rgb "#00008B",\
     '' u 6 ti col lc rgb "#2E8B57",\
     '' u 7 ti col lc rgb "#006400"

