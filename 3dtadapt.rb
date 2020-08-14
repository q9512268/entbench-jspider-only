#!/usr/bin/env ruby

require 'terminal-table'

$BENCH = {
  sunflow:"sunflow", 
  jython:"jython", 
  xalan:"xalan", 
  findbugs:"findbugs", 
  pagerank:"pagerank"
}

$DIR   = "tadapt_run"
$RUNS  = ["run_ld_tent.txt","run_ld_tjava.txt"]
$LABELS  = ["'Ent'","'Unadaptive Ent'"]

$BENCH.each do |bench, path|
  tempsdat = File.open("dat/3dtadapt_#{bench}_temps.dat", "w+")
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
  temptable[bench] = temps

  tempsdat.write("time\tent\t\java\n")
  for i in 0...temps[0].length
    tempsdat.write("#{i.to_f/temps[0].length.to_f}\t#{temps[0][i]}\t#{temps[1][i]}\n")
  end
end

