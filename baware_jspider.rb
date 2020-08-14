#!/usr/bin/env ruby

require 'terminal-table'

$BENCH = {

    jspider:"jspider"
}

$DIR   = "baware_run"
$RUNS = [
  "run_sd_hc.txt",  # 0
  "run_sd_hcu.txt", # 1
  "run_sd_mc.txt",  # 2
  "run_sd_mcu.txt", # 3
  "run_sd_lc.txt",  # 4
  "run_sd_lcu.txt", # 5

  "run_md_hc.txt",  # 6
  "run_md_hcu.txt", # 7
  "run_md_mc.txt",  # 8
  "run_md_mcu.txt", # 9
  "run_md_lc.txt",  # 10
  "run_md_lcu.txt", # 11

  "run_ld_hc.txt",  # 12
  "run_ld_hcu.txt", # 13
  "run_ld_mc.txt",  # 14
  "run_ld_mcu.txt", # 15
  "run_ld_lc.txt",  # 16
  "run_ld_lcu.txt"  # 17
  ]

$DATAS = ["energy_saver", "managed", "full_throttle", "full_throttle"]

$LITTLEGAP=0.2
$LARGEGAP=1

# Build table for energy consumed for each run
consumedtable = {}
$BENCH.each do |bench, path|
  energy = []
  maxe = 0.0
  $RUNS.each do |run|
    m = File.open("./#{path}/#{$DIR}/#{run}").read().scan(/ERun.*:(.*)$/)
    e = 0.0
    for i in 1..m.length-1 do
      e += m[i][0].strip().split()[2].to_f
    end
    e = e / (m.length.to_f-1)
    maxe = e unless maxe > e
    energy << e
  end
  normalize = energy[17]
  energy.map! { |n| n / normalize }
  consumedtable[bench] = energy
end

# Dump tables for gnuplot

consumeddat = File.open("dat/baware_consumed.dat", "w+")
consumeddat.write("xcord\tbench\tdata\tent_managed\tjava_managed\tent_full\tjava_full\tpercent_saved\n")

k = 0
$BENCH.each do |bench, path|
  #xcord = 0*$LITTLEGAP+k*$LARGEGAP
  #consumeddat.write("#{xcord}\t#{bench}\t#{$DATAS[0]}")
  #consumeddat.write("\t0\t0\t#{consumedtable[bench][0]}\t#{consumedtable[bench][1]}\n")

  es_m = consumedtable[bench][11] - consumedtable[bench][10]
  es_me = ((es_m / consumedtable[bench][11]) * 100.0).round(2)

  m_ft = consumedtable[bench][15] - consumedtable[bench][14]
  m_fte = ((m_ft / consumedtable[bench][15]) * 100.0).round(2)

  es_ft = consumedtable[bench][17] - consumedtable[bench][16]
  es_fte = ((es_ft / consumedtable[bench][17]) * 100.0).round(2)

  xcord = 0*$LITTLEGAP+k*$LARGEGAP
  consumeddat.write("#{xcord}\t#{bench}\t#{$DATAS[1]}")
  consumeddat.write("\t#{consumedtable[bench][10]}\t#{consumedtable[bench][11]}\t\t\t#{es_me}\n")

  xcord = 1*$LITTLEGAP+k*$LARGEGAP
  consumeddat.write("#{xcord}\t#{bench}\t#{$DATAS[2]}")
  consumeddat.write("\t#{consumedtable[bench][14]}\t#{consumedtable[bench][15]}\t\t\t#{m_fte}\n")

  xcord = 2*$LITTLEGAP+k*$LARGEGAP
  consumeddat.write("#{xcord}\t#{bench}\t#{$DATAS[3]}")
  consumeddat.write("\t\t\t#{consumedtable[bench][16]}\t#{consumedtable[bench][17]}\t#{es_fte}\n")

  k += 1
end

consumeddat.close
