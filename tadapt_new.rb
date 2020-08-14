#!/usr/bin/env ruby

require 'terminal-table'

$BENCH = {sunflow:"sunflow"}
$DIR   = "tadapt_run"

# Build table for energy consumed for each run
def load_temps(bench,path,file)
  file = File.open("./#{path}/#{$DIR}/#{file}").read()
  temps = []
  temp = []
  file.each_line do |line|
    parsed = line.strip().split()
    if parsed[0].include?("ERun") then
      temps << temp
      temp = []
    else
      temp << parsed[0].to_f
    end
  end

  # Sanity check
  should_be = temps[0].length
  for i in 0..temps.length-1 do
    if temps[i].length != should_be then
      puts "Different number of points per run!"
      exit
    end
  end

  enttemp = []
  count = temps.length

  for i in 0..should_be-1 do
    tempsum = 0.0
    for j in 0..count-1 do 
      tempsum += temps[j][i]
    end
    enttemp << (tempsum / count.to_f)
  end

  return enttemp
end

$BENCH.each do |bench, path|
  enttemp = load_temps(bench,path,"run_ld_tent.txt")
  javatemp = load_temps(bench,path,"run_ld_tjava.txt")

  # Sanity check
  if enttemp.length != javatemp.length then
    puts "ent and java not equal for #{bench}"
    exit
  end

  file = File.open("dat/tadapt_#{bench}.dat", "w+")
  file.write("xcord\tent\tjava\n")
  for i in 0..enttemp.length do
    file.write("#{i}\t#{enttemp[i]}\t#{javatemp[i]}\n")
  end
  file.close
end

