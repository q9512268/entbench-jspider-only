set terminal pngcairo size 1280,480 enhanced font 'Verdana,18'

set auto x

set style data histogram
set style histogram cluster gap 2
set style fill solid border -1
set boxwidth 0.85 relative
set key top left
set grid
set ylabel "Energy Consumed (J)"
set xlabel "Data Mode"

set output "./dat/badapt_sunflow_consumed.png"

set title "Sunflow Battery Adapt Run"

plot './dat/badapt_sunflow_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#0000CD",\
     '' u 4 ti col lc rgb "#2E8B57",\

set output "./dat/badapt_batik_consumed.png"

set title "Batik Battery Adapt Run"

plot './dat/badapt_batik_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#0000CD",\
     '' u 4 ti col lc rgb "#2E8B57",\

set output "./dat/badapt_pagerank_consumed.png"

set title "Pagerank Battery Adapt Run"

plot './dat/badapt_pagerank_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#0000CD",\
     '' u 4 ti col lc rgb "#2E8B57",\

set output "./dat/badapt_crypto_consumed.png"

set title "Crypto Battery Adapt Run"

plot './dat/badapt_crypto_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#0000CD",\
     '' u 4 ti col lc rgb "#2E8B57",\


set output "./dat/badapt_monte_carlo_consumed.png"

set title "Montecarlo Battery Adapt Run"

plot './dat/badapt_monte_carlo_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#0000CD",\
     '' u 4 ti col lc rgb "#2E8B57",\

set output "./dat/badapt_findbugs_consumed.png"

set title "Findbugs Battery Adapt Run"

plot './dat/badapt_findbugs_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#0000CD",\
     '' u 4 ti col lc rgb "#2E8B57",\

set title "Pagerank Battery Adapt Run"

plot './dat/badapt_pagerank_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#0000CD",\
     '' u 4 ti col lc rgb "#2E8B57",\

set output "./dat/badapt_crypto_consumed.png"


set output "./dat/badapt_jspider_consumed.png"

set title "JSpider Battery Adapt Run"

plot './dat/badapt_jspider_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#0000CD",\
     '' u 4 ti col lc rgb "#2E8B57",\


