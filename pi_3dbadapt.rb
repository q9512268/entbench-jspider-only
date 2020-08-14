#!/usr/bin/env ruby

require 'terminal-table'

$BENCH = {crypto:"crypto", sunflow:"sunflow", video:"video", manual:"manual", javaboy:"javaboy"}
$DIR   = "pi_dat"

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

# Build table for energy consumed for each run
consumedtable = {}
normalizer = {}

# Build table for energy consumed for each run
consumedtable = {}
$BENCH.each do |bench, path|
  energy = []
  file = File.open("./#{$DIR}/badapt_#{bench}_consumed.dat")
  skip = true
  max = 0.0
  file.each_line do |line|
    if skip
      skip = false
      next
    end
    data = line.split
    energy << data[1].to_f
    energy << data[2].to_f
    energy << data[3].to_f
    energy.each do |x|
      if x > max
        max = x
      end
    end
  end
  consumedtable[bench] = energy 
  normalizer[bench] = max
end 

# Dump tables for gnuplot
consumeddat = File.open("dat/pi_3dbadapt.dat", "w+")
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
