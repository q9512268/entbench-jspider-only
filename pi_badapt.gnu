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

set title "Sunflow Battery Adapt Run"
set output "./pi_dat/badapt_sunflow_consumed.png"

plot './pi_dat/badapt_sunflow_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#0000CD",\
     '' u 4 ti col lc rgb "#2E8B57",\

set title "Crypto Battery Adapt Run"
set output "./pi_dat/badapt_crypto_consumed.png"

plot './pi_dat/badapt_video_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#0000CD",\
     '' u 4 ti col lc rgb "#2E8B57",\

set title "Video Battery Adapt Run"
set output "./pi_dat/badapt_video_consumed.png"

plot './pi_dat/badapt_video_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#0000CD",\
     '' u 4 ti col lc rgb "#2E8B57",\

set title "Camera Battery Adapt Run"
set output "./pi_dat/badapt_camera_consumed.png"

plot './pi_dat/badapt_camera_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#0000CD",\
     '' u 4 ti col lc rgb "#2E8B57",\



