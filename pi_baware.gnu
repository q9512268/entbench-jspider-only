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

plot './pi_dat/baware_sunflow_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#8B0000",\
     '' u 4 ti col lc rgb "#0000CD",\
     '' u 5 ti col lc rgb "#00008B",\
     '' u 6 ti col lc rgb "#2E8B57",\
     '' u 7 ti col lc rgb "#006400"

set output "./pi_dat/baware_crypto_consumed.png"

set title "Crypto Battery-Exception Run"

plot './pi_dat/baware_crypto_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#8B0000",\
     '' u 4 ti col lc rgb "#0000CD",\
     '' u 5 ti col lc rgb "#00008B",\
     '' u 6 ti col lc rgb "#2E8B57",\
     '' u 7 ti col lc rgb "#006400"

set output "./pi_dat/baware_camera_consumed.png"

set title "Camera Battery-Exception Run"
set ylabel "Energy Consumed (J)"
set xlabel "Application Data Mode"

plot './pi_dat/baware_camera_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#8B0000",\
     '' u 4 ti col lc rgb "#0000CD",\
     '' u 5 ti col lc rgb "#00008B",\
     '' u 6 ti col lc rgb "#2E8B57",\
     '' u 7 ti col lc rgb "#006400"

set output "./pi_dat/baware_video_consumed.png"

set title "Video Battery-Exception Run"

plot './pi_dat/baware_video_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#8B0000",\
     '' u 4 ti col lc rgb "#0000CD",\
     '' u 5 ti col lc rgb "#00008B",\
     '' u 6 ti col lc rgb "#2E8B57",\
     '' u 7 ti col lc rgb "#006400"

set output "./pi_dat/baware_manual_consumed.png"

set title "Manual Battery-Exception Run"

plot './pi_dat/baware_manual_consumed.dat' using 2:xtic(1) ti col lc rgb "#DC143C" ,\
     '' u 3 ti col lc rgb "#8B0000",\
     '' u 4 ti col lc rgb "#0000CD",\
     '' u 5 ti col lc rgb "#00008B",\
     '' u 6 ti col lc rgb "#2E8B57",\
     '' u 7 ti col lc rgb "#006400"

