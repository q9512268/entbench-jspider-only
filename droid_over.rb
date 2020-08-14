#!/usr/bin/env ruby

require 'terminal-table'

$BENCH = {
  NewPipe:"NewPipe", 
  duckduckgo:"duckduckgo", 
  SoundRecorder:"SoundRecorder", 
  MaterialLife:"MaterialLife", 
}

$RUNS = [
  ["run_md_mc_ent.txt", "run_md_mc_java.txt"]
]

$DATAS = ['"energy-saver"', '"managed"', '"full-throttle"']

$SIZE  = $RUNS.length

# Build table for energy consumed for each run
consumedtable = {}
puts "bench ent java"
$BENCH.each do |bench, path|
  energy = []
  $RUNS.each do |run| 
    m = File.open("./android_bench/#{path}/over_run/#{run[0]}").read().scan(/^(?!\/\/)ERun.*:(.*)$/)
    e1 = 0.0
    for i in 0..m.length-1 do
      e1 += m[i][0].strip().split()[2].to_f
    end
    ae1 = e1 / (m.length-1).to_f
    energy << e1 / (m.length-1).to_f

    m = File.open("./android_bench/#{path}/over_run/#{run[1]}").read().scan(/^(?!\/\/)ERun.*:(.*)$/)
    e2 = 0.0
    for i in 0..m.length-1 do
      e2 += m[i][0].strip().split()[2].to_f
    end
    energy << e2 / (m.length-1).to_f
    ae2 = e2 / (m.length-1).to_f

    diff = (((ae1-ae2)/ae2)*100.0).round(2)

    puts "#{bench} #{ae1} #{ae2} #{diff}"

    energy << ((ae2 - ae1) / ae2) * 100

  end
  consumedtable[bench] = energy
end

# Dump tables for gnuplot
consumeddat = File.open("dat/pi_over_consumed.dat", "w+")
consumeddat.write('title "ent" "java"')
consumeddat.write("\n")
$BENCH.each do |bench, path|
  consumeddat.write("#{bench} ")
  consumedtable[bench].each do |d|
    consumeddat.write("#{d} ")
  end
  consumeddat.write("\n")
end 
