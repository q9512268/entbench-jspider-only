#!/usr/bin/env ruby

require 'terminal-table'

$BENCH = {
  sunflow:"sunflow", 
#  jython:"jython", 
#  xalan:"xalan", 
#  findbugs:"findbugs", 
#  pagerank:"pagerank"
}

$DIR   = "tadapt_run"
$RUNS  = ["run_ld_tent.txt","run_ld_tjava.txt"]
$LABELS  = ["'Ent'","'Unadaptive Ent'"]

# Build table for energy consumed for each run
consumedtable = {}
$BENCH.each do |bench, path|
  energy = []
  $RUNS.each do |run| 
    m = File.open("./#{path}/#{$DIR}/#{run}").read().match(/Energy:(.*)$/)
    energies = m[1].strip().split()
    energy << energies[2]
  end
  consumedtable[bench] = energy
end

# Build table for runtime for each run
#timetable = {}
#$BENCH.each do |bench, path|
#  times = []
#  $RUNS.each do |run| 
#    m = File.open("./#{path}/#{$DIR}/#{run}").read().match(/Time:(.*)$/)
#    times << m[1].strip().split()[0]
#  end
#  timetable[bench] = times
#end

$BENCH.each do |bench, path|
  tempsdat = File.open("dat/tadapt_#{bench}_temps.dat", "w+")
  temptable = {}

  temps = []
  $RUNS.each do |run| 
    m = File.open("./#{path}/#{$DIR}/#{run}").read().scan(/Temperature:(.*)$/)
    points = []
    m.each do |t|
      points << t[0]
    end
    temps << points
  end
  for i in 0...temps[0].length
    tempsdat.write("#{i} ")
    for j in 0...temps.length
      tempsdat.write("#{temps[j][i]} ")
    end
    tempsdat.write("\n")
  end
end

j = 0
consumedtable.each do |bench, results|
  consumeddat = File.open("dat/tadapt_#{bench}_consumed.dat", "w+")

  i = 0
  results.each do |run|
    consumeddat.write("#{j} #{$LABELS[i]} #{run}\n")
    i += 1
    j += 1
  end
end
