#!/usr/bin/env ruby

require 'terminal-table'

$BENCH = {crypto:"crypto", batik:"batik", jspider:"jspider", findbugs:"findbugs", pagerank:"pagerank", sunflow:"sunflow"}

$DIR   = "adapt_run"
$RUNS = [
  "run_sd_hc.txt",
  "run_sd_mc.txt",
  "run_sd_lc.txt",

  "run_md_hc.txt",
  "run_md_mc.txt",
  "run_md_lc.txt",

  "run_ld_hc.txt",
  "run_ld_mc.txt",
  "run_ld_lc.txt",
  ]

$DATAS = [
  "a",
  "b",
  "c",

  "d",
  "e",
  "f",

  "g",
  "h",
  "i",
  ]

$SIZE  = $RUNS.length

$PP = false
if ARGV.first == "-pp"
  $PP = true
end

# Build table for energy consumed for each run
consumedtable = {}
normalizer = {}
$BENCH.each do |bench, path|
  energy = []
  max = 0.0
  $RUNS.each do |run| 
    m = File.open("./#{path}/#{$DIR}/#{run}").read().scan(/ERun.*:(.*)$/)
    e = 0.0
    for i in 1..m.length-1 do
      e += m[i][0].strip().split()[2].to_f
    end
    e = e / (m.length-1).to_f
    max = max > e ? max : e
    energy << e 
  end
  consumedtable[bench] = energy
  normalizer[bench] = max
end

# Dump tables for gnuplot
consumeddat = File.open("dat/3dbadapt.dat", "w+")
consumeddat.write("run ")
$DATAS.each do |d|
  consumeddat.write("#{d} ")
end
consumeddat.write("\n")

$BENCH.each do |bench, path|
  consumeddat.write("#{bench} ")
  for i in 0...9 do
    consumeddat.write("#{consumedtable[bench][i]/normalizer[bench]} ")
  end
  consumeddat.write("\n")
end

#$BENCH.each do |bench, path| 
#  consumeddat.write('title "full-throttle ent" "untyped ent" "mid-throttle ent" "untyped ent" "energy-saver ent" "untyped ent"') 
#  consumeddat.write("\n")
#  for i in 0..2 do
#    consumeddat.write("#{$DATAS[i]} ")
#    for j in (i*6)...((i+1)*6) do
#      consumeddat.write("#{consumedtable[bench][j]} ")
#    end
#    consumeddat.write("\n")
#  end
#end 
