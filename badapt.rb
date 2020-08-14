#!/usr/bin/env ruby

require 'terminal-table'
require 'optparse'

$INTEL_DIR   = "adapt_run"
$PI_DIR   = "badapt_run"

$INTEL_BENCH = {
  sunflow:"sunflow", 
  jspider:"jspider", 
  crypto:"crypto", 
  findbugs:"findbugs", 
  pagerank:"pagerank",
  batik:"batik",
}

$PI_BENCH = {
  sunflow:"sunflow", 
  crypto:"crypto", 
  camera:"camera", 
  video:"video",
#  batik:"batik",
  javaboy:"javaboy",
}

$DROID_BENCH = {
  NewPipe:"NewPipe", 
  duckduckgo:"duckduckgo", 
  SoundRecorder:"SoundRecorder", 
  MaterialLife:"MaterialLife", 
}

$RUNS = [
  "run_sd_hc",  #0
  "run_sd_mc",  #1
  "run_sd_lc",  #2

  "run_md_hc",  #3
  "run_md_mc",  #4
  "run_md_lc",  #5

  "run_ld_hc",  #6
  "run_ld_mc",  #7
  "run_ld_lc",  #8
  ] 

$DATAS = ["small", "medium", "large"] 
$LITTLEGAP=0.2
$LARGEGAP=1

$SIZE_LABELS = ["small", "medium", "large"]
$CONTXT_LABELS = ["-", "full mean", "full dev", "full rel", 
                       "managed mean", "managed dev", "managed rel",
                       "saver mean", "saver dev", "saver rel"]

$CONTXT_LABELS2 = ["-", "f1d", "f2d", "f3d", "f4d", "",
                        "m1d", "m2d", "m3d", "m4d", "",
                        "s1d", "s2d", "s3d", "s4d", ""]


def stats_benchmarks(benches, runs, mode)
  # Build table for energy consumed for each run
  front_path = ""
  front_dat = ""
  device = ""
  dir = ""
  case mode
  when :intel_mode
    front_path = "."
    front_dat = "./dat"
    device = "Intel"
    dir = "adapt_run"
  when :pi_mode
    front_path = "./pi_bench"
    front_dat = "./pi_dat"
    device = "Pi"
    dir = "badapt_run"
  when :droid_mode
    front_path = "./android_bench"
    front_dat = "./droid_dat"
    device = "Droid"
    dir = "badapt_run"
  end 

  deviationtable = {}

  totaltable = []
  totals = [0,0,0,0]
  total_runs = 0
  nonsmall_reltotals = [0,0,0]
  reltotals = [0,0,0]
  benches.each do |bench, path|
    dev_stat_rows = []
    dev_stat_cols = [$SIZE_LABELS[0]]
    dev_run_rows = []
    dev_run_cols = [$SIZE_LABELS[0]]

    bench_totals = [0,0,0,0]
    bench_total_runs = 0

    bench_reltotals = [0,0,0]
    nonsmall_bench_reltotals = [0,0,0]

    deviations = []

    for i in 0..runs.length-1 do
      drop_first = false
      num_runs = 0
      
      m = File.open("./#{front_path}/#{path}/#{dir}/#{runs[i]}.txt").read().scan(/^(?!\/\/)ERun.*:(.*)$/)

      case mode
      when :intel_mode
        drop_first = true
        num_runs = m.length-1
      when :pi_mode
        drop_first = true
        num_runs = m.length-1
      when :droid_mode
        drop_first = false
        front_path = "./android_bench"
        num_runs = m.length
      end 

      energies = []
      for j in 0..m.length-1 do
        next if j == 0 && drop_first
        energies << m[j][0].strip().split()[2].to_f
      end
      total_runs += num_runs
      bench_total_runs += num_runs

      # Grab raw deviation statistics
      mean = energies.inject(:+) / (num_runs.to_f)
      dev_stat_cols << mean.round(2)
      variance = energies.inject { |sum,n| sum + ((n - mean) ** 2) } / ((num_runs).to_f)
      deviation = Math.sqrt(variance)
      dev_stat_cols << deviation.round(2)

      deviations << deviation.round(2)

      rel_dev = ((deviation / mean) * 100.0).round(2)
      dev_stat_cols << rel_dev

      if (rel_dev < 2.0) then
        reltotals[0] += 1
        bench_reltotals[0] += 1
        if (i > 2) then
          nonsmall_bench_reltotals[0] += 1
          nonsmall_reltotals[0] += 1
        end
      end

      if (rel_dev < 3.0) then
        reltotals[1] += 1
        bench_reltotals[1] += 1
        if (i > 2) then
          nonsmall_bench_reltotals[1] += 1
          nonsmall_reltotals[1] += 1
        end
      end

      if (rel_dev < 5.0) then
        reltotals[2] += 1
        bench_reltotals[2] += 1
        if (i > 2) then
          nonsmall_bench_reltotals[2] += 1
          nonsmall_reltotals[2] += 1
        end
      end


      # Check runs for within 1 and 2 deviations
      total_within = 0
      for j in 1..4 do
        rmin = mean - (deviation * j)
        rmax = mean + (deviation * j)
        within = 0
        energies.each do |e|
          within = within + 1 if (e >= rmin && e <= rmax)
        end
        within = within - total_within
        dev_run_cols << within
        total_within += within
        totals[j-1] += within
        bench_totals[j-1] += within
      end
      dev_run_cols << ""

      if ((i + 1) % 3 == 0) then
        dev_stat_rows << dev_stat_cols
        dev_stat_cols = [$SIZE_LABELS[(i+1)/3]]

        dev_run_rows << dev_run_cols
        dev_run_cols = [$SIZE_LABELS[(i+1)/3]]
      end
    end

    deviationtable[bench] = deviations

    puts Terminal::Table.new :title => "#{bench} Deviation Statistics", 
      :headings => $CONTXT_LABELS, 
      :rows => dev_stat_rows
    puts "\n"

    dev1 = (bench_totals[0].to_f / bench_total_runs.to_f) * 100.0
    dev2 = (bench_totals[1].to_f / bench_total_runs.to_f) * 100.0
    dev3 = (bench_totals[2].to_f / bench_total_runs.to_f) * 100.0
    dev4 = (bench_totals[3].to_f / bench_total_runs.to_f) * 100.0

    totaltable << ["#{bench}",dev1.round(2),dev2.round(2),dev3.round(2),dev4.round(2), "", (dev1 + dev2).round(2)]

    puts "#{bench} Total Within 1 Deviation: #{dev1}"
    puts "#{bench} Total Within 2 Deviation: #{dev2}"
    puts "#{bench} Total Within 3 Deviation: #{dev3}"
    puts "#{bench} Total Within 4 Deviation: #{dev4}"
    puts "#{bench} Total Within 1 and 2 Deviation: #{dev1 + dev2}"

    puts "#{bench} Total Within 2% Deviation: #{bench_reltotals[0]}"
    puts "#{bench} Total Within 3% Deviation: #{bench_reltotals[1]}"
    puts "#{bench} Total Within 3% Deviation: #{bench_reltotals[2]}"

    puts "#{bench} Nonsmall Total Within 2% Deviation: #{nonsmall_bench_reltotals[0]}"
    puts "#{bench} Nonsmall Total Within 3% Deviation: #{nonsmall_bench_reltotals[1]}"

    puts "#{bench} Nonsmall Percent Total Within 2% Deviation: #{(nonsmall_bench_reltotals[0]/6.0) * 100.0}"
    puts "#{bench} Nonsmall Percent Total Within 3% Deviation: #{(nonsmall_bench_reltotals[1]/6.0) * 100.0}"
    puts "#{bench} Nonsmall Percent Total Within 5% Deviation: #{(nonsmall_bench_reltotals[2]/6.0) * 100.0}"

    puts "\n"
  end

  puts Terminal::Table.new :title => "Overall Deviation Runs", 
      :headings => ["benchmark", "% within 1", "% within 2", "% within 3", "% within 4", "", "% within 1&2"],
      :rows => totaltable
  puts "\n"

  dev1 = (totals[0].to_f / total_runs.to_f) * 100.0
  dev2 = (totals[1].to_f / total_runs.to_f) * 100.0
  dev3 = (totals[2].to_f / total_runs.to_f) * 100.0
  dev4 = (totals[3].to_f / total_runs.to_f) * 100.0

  puts "All Total Within 1 Deviation: #{dev1}"
  puts "All Total Within 2 Deviation: #{dev2}"
  puts "All Total Within 3 Deviation: #{dev3}"
  puts "All Total Within 4 Deviation: #{dev4}"
  puts "All Total Within 1 and 2 Deviation: #{dev1 + dev2}"

  len = benches.length

  puts "All Percent Total Within 2% Deviation: #{(reltotals[0]/(9.0*len)) * 100.0}"
  puts "All Percent Total Within 3% Deviation: #{(reltotals[1]/(9.0*len)) * 100.0}"
  puts "All Percent Total Within 5% Deviation: #{(reltotals[2]/(9.0*len)) * 100.0}"

  puts "Nonsmall Percent Total Within 2% Deviation: #{(nonsmall_reltotals[0]/(6.0*len)) * 100.0}"
  puts "Nonsmall Percent Total Within 3% Deviation: #{(nonsmall_reltotals[1]/(6.0*len)) * 100.0}"
  puts "Nonsmall Percent Total Within 5% Deviation: #{(nonsmall_reltotals[2]/(6.0*len)) * 100.0}"

  return deviationtable
end

def raw_dump(benches, runs, mode) 
  # Build table for energy consumed for each run
  front_path = ""
  front_dat = ""
  device = ""
  dir = ""
  case mode
  when :intel_mode
    front_path = "."
    front_dat = "./dat"
    device = "Intel"
    dir = "adapt_run"
  when :pi_mode
    front_path = "./pi_bench"
    front_dat = "./pi_dat"
    device = "Pi"
    dir = "badapt_run"
  when :droid_mode
    front_path = "./android_bench"
    front_dat = "./droid_dat"
    device = "Droid"
    dir = "badapt_run"
  end 

  benches.each do |bench, path|
    runs.each do |run| 
      puts "#{bench}-#{run}"
      puts File.read("./#{front_path}/#{path}/#{dir}/#{run}.txt")
    end
    puts "\n"
  end

end

# Build table for energy consumed for each run
def analyze_benchmarks(benches, runs, mode)
  # Build table for energy consumed for each run
  front_path = ""
  front_dat = ""
  device = ""
  dir = ""
  case mode
  when :intel_mode
    front_path = "."
    front_dat = "./dat"
    device = "Intel"
    dir = "adapt_run"
  when :pi_mode
    front_path = "./pi_bench"
    front_dat = "./pi_dat"
    device = "Pi"
    dir = "badapt_run"
  when :droid_mode
    front_path = "./android_bench"
    front_dat = "./droid_dat"
    device = "Droid"
    dir = "badapt_run"
  end 

  consumedtable = {}
  normaltable = {}
  benches.each do |bench, path|
    energy = []
    nenergy = []
    maxe = 0.0
    drop_first = false
    num_runs = 0

    runs.each do |run| 
      m = File.open("./#{front_path}/#{path}/#{dir}/#{run}.txt").read().scan(/^(?!\/\/)ERun.*:(.*)$/)
      e = 0.0

      case mode
      when :intel_mode
        drop_first = true
        num_runs = m.length-1
      when :pi_mode
        drop_first = true
        num_runs = m.length-1
      when :droid_mode
        drop_first=false
        front_path = "./android_bench"
        num_runs = m.length
      end 

      for i in 0..m.length-1 do
        next if i == 0 && drop_first

        e += m[i][0].strip().split()[2].to_f
      end
      e = e / num_runs.to_f
      maxe = e unless maxe > e 
      energy << e
    end
    nenergy = energy.map { |n| n / maxe }
    normalize = energy[6]

    nenergy = energy.map { |n| n / normalize }
    consumedtable[bench] = energy
    normaltable[bench] = nenergy
  end

  # Dump tables for gnuplot
  consumeddat = File.open("#{front_dat}/badapt_consumed.dat", "w+")

  #consumeddat.write("xcord\tbench\tdata\tenergy_saver\tmanaged\tfull_throttle\tlow_percent_saved\tmid_percent_saved\n")
  consumeddat.write("xcord\tbench\tdata\tenergy_saver\tmanaged\tlow_percent_saved\tmid_percent_saved\n")

  k = 0
  benches.each do |bench, path|
    #for i in 0..2 do

      #for j in (((i+1)*3)-1).downto(i*3) do
      #  consumeddat.write("\t#{normaltable[bench][j]}")
      #end

      #top = (((i+1)*3)-1)
    
      saver = (((consumedtable[bench][6]-consumedtable[bench][8]) / consumedtable[bench][6]) * 100.0).round(2)
      managed = (((consumedtable[bench][6]-consumedtable[bench][7]) / consumedtable[bench][6]) * 100.0).round(2)

      xcord = 0*$LITTLEGAP+k*$LARGEGAP
      consumeddat.write("#{xcord}\t#{bench}\t#{$DATAS[2]}\t#{normaltable[bench][8]}\t0\t#{saver}\t\"\"\n")
      xcord = 1*$LITTLEGAP+k*$LARGEGAP
      consumeddat.write("#{xcord}\t#{bench}\t#{$DATAS[2]}\t0\t#{normaltable[bench][7]}\t\"\"\t#{managed}\n")

      k += 1
  end

  #k = 0
  #benches.each do |bench, path|
  #  for i in 0..2 do
  #    xcord = i*$LITTLEGAP+k*$LARGEGAP
  #    consumeddat.write("#{xcord}\t#{bench}\t#{$DATAS[i]}")
  #    for j in (((i+1)*3)-1).downto(i*3) do
  #      consumeddat.write("\t#{normaltable[bench][j]}")
  #    end
#
#      top = (((i+1)*3)-1)
#    
#      saver = (((consumedtable[bench][top-2]-consumedtable[bench][top]) / consumedtable[bench][top-2]) * 100.0).round(2)
#      managed = (((consumedtable[bench][top-2]-consumedtable[bench][top-1]) / consumedtable[bench][top-2]) * 100.0).round(2)
#
#      #if (managed-saver).abs <= 2.0 
#      #  consumeddat.write("\t#{saver}\t")
#      #else
#        consumeddat.write("\t#{saver}\t#{managed}")
#      #end
#
#      consumeddat.write("\n")
#    end
#    k += 1
#  end

  consumeddat.close

  puts "\\hline"
  puts "\\textbf{name} & \\textbf{workload} & \\textbf{full boot (J)} & \\textbf{managed boot saved (J)} & \\textbf{managed boot saved (\\%)} & \\textbf{saver boot saved (J)} & \\textbf{saver boot saved (\\%)} \\\\"

  # Dump energy consumed diff
  rows = []
  rowse = []
  benches.each do |bench, path|
    ld_ft_m = consumedtable[bench][6]-consumedtable[bench][7]
    ld_ft_me = (ld_ft_m / consumedtable[bench][6]) * 100.0

    ld_ft_es = consumedtable[bench][6]-consumedtable[bench][8]
    ld_ft_ese = (ld_ft_es / consumedtable[bench][6]) * 100.0

    md_ft_m = consumedtable[bench][3]-consumedtable[bench][4]
    md_ft_me = (md_ft_m / consumedtable[bench][3]) * 100.0

    md_ft_es = consumedtable[bench][3]-consumedtable[bench][5]
    md_ft_ese = (md_ft_es / consumedtable[bench][3]) * 100.0

    sd_ft_m = consumedtable[bench][0]-consumedtable[bench][1]
    sd_ft_me = (sd_ft_m / consumedtable[bench][0]) * 100.0

    sd_ft_es = consumedtable[bench][0]-consumedtable[bench][2]
    sd_ft_ese = (sd_ft_es / consumedtable[bench][0]) * 100.0

    rows << [bench, ld_ft_m.round(2), ld_ft_es.round(2), md_ft_m.round(2), md_ft_es.round(2), sd_ft_m.round(2), sd_ft_es.round(2)]
    rowse << [bench, ld_ft_me.round(2), ld_ft_ese.round(2), md_ft_me.round(2), md_ft_ese.round(2), sd_ft_me.round(2), sd_ft_ese.round(2)]

    puts "\\hline"
    puts "#{bench} & full & #{consumedtable[bench][6].round(2)} & #{ld_ft_m.round(2)} & #{ld_ft_me.round(2)}\\% & #{ld_ft_es.round(2)} & #{ld_ft_ese.round(2)}\\% \\\\"

    puts "\\hline"
    puts "#{bench} & managed &  #{consumedtable[bench][3].round(2)} & #{md_ft_m.round(2)} & #{md_ft_me.round(2)}\\% & #{md_ft_es.round(2)} & #{md_ft_ese.round(2)}\\% \\\\"

    puts "\\hline" 
    puts "#{bench} & saver &  #{consumedtable[bench][0].round(2)} & #{sd_ft_m.round(2)} & #{sd_ft_me.round(2)}\\% & #{sd_ft_es.round(2)} & #{sd_ft_ese.round(2)}\\% \\\\"

    rows << :separator
    rowse << :separator
  end
  
  puts "\\hline"

  puts Terminal::Table.new :title => "#{device} Raw Difference", 
                           :headings => ["Bench", "ld:full-managed", "ld:full-saver", "md:full-managed", "md:full-saver", "sd:full-managed", "sd:full-saver"], 
                           :rows => rows

  puts Terminal::Table.new :title => "#{device} Percent Error (Against full-throttle)", 
                           :headings => ["Bench", "ld:full-managed", "ld:full-saver", "md:full-managed", "md:full-saver", "sd:full-managed", "sd:full-saver"], 
                           :rows => rowse

  return consumedtable
end

def paper_dump(dev,ens,benchs,runs)

  benchs.each do |bench,path| 
    puts "\\hline"
    puts "#{bench.to_s} & full & #{ens[bench][6].round(2)} & #{dev[bench][6].round(2)} & #{ens[bench][7].round(2)} & #{dev[bench][7].round(2)} & #{ens[bench][8].round(2)} & #{dev[bench][8].round(2)} \\\\"

    puts "\\hline"
    puts "#{bench.to_s} & managed & #{ens[bench][3].round(2)} & #{dev[bench][3].round(2)} & #{ens[bench][4].round(2)} & #{dev[bench][4].round(2)} & #{ens[bench][5].round(2)} & #{dev[bench][5].round(2)} \\\\"

    puts "\\hline"
    puts "#{bench.to_s} & saver & #{ens[bench][0].round(2)} & #{dev[bench][0].round(2)} & #{ens[bench][1].round(2)} & #{dev[bench][1].round(2)} & #{ens[bench][2].round(2)} & #{dev[bench][2].round(2)} \\\\"

  end
  puts "\\hline"

end

if __FILE__ == $0
  options = {}
  options[:mode] = :intel_mode
  options[:stats] = false
  options[:raw] = false
  options[:paper] = false

  optparse = OptionParser.new do |opts|
    opts.banner = "Usage: analyze.rb [options]"

    opts.on("-p", "--pi-mode", "Run analysis on pi device.") do |p|
      options[:mode] = :pi_mode
    end 

    opts.on("-d", "--droid-mode", "Run analysis on droid device.") do |p|
      options[:mode] = :droid_mode
    end 

    opts.on("-i", "--intel-mode", "Run analysis on intel device.") do |p|
      options[:mode] = :intel_mode
    end 

    opts.on("-s", "--stat-mode", "Run stats analysis.") do |p|
      options[:stats] = true
    end 

    opts.on("-r", "--raw-mode", "Run dump of data.") do |p|
      options[:raw] = true
    end 

    opts.on("-b", "--publish-mode", "Run dump of data.") do |p|
      options[:paper] = true
    end 
  end

  optparse.parse!

  case options[:mode]
  when :intel_mode
    if options[:stats] then
      stats_benchmarks($INTEL_BENCH, $RUNS, options[:mode])
    elsif options[:raw]
      raw_dump($INTEL_BENCH, $RUNS, options[:mode])
    elsif options[:paper]
      devs = stats_benchmarks($INTEL_BENCH, $RUNS, options[:mode])
      ens  = analyze_benchmarks($INTEL_BENCH, $RUNS, options[:mode])
      paper_dump(devs,ens, $INTEL_BENCH, $RUNS)
    else
      analyze_benchmarks($INTEL_BENCH, $RUNS, options[:mode])
    end
  when :pi_mode
    if options[:stats] then
      stats_benchmarks($PI_BENCH, $RUNS, options[:mode])
    elsif options[:raw]
      raw_dump($PI_BENCH, $RUNS, options[:mode])
    elsif options[:paper]
      devs = stats_benchmarks($PI_BENCH, $RUNS, options[:mode])
      ens  = analyze_benchmarks($PI_BENCH, $RUNS, options[:mode])
      paper_dump(devs,ens, $PI_BENCH, $RUNS)
    else
      analyze_benchmarks($PI_BENCH, $RUNS, options[:mode])
    end
  when :droid_mode
    if options[:stats] then
      stats_benchmarks($DROID_BENCH, $RUNS, options[:mode])
    elsif options[:raw] 
      raw_dump($DROID_BENCH, $RUNS, options[:mode])
    elsif options[:paper]
      devs = stats_benchmarks($DROID_BENCH, $RUNS, options[:mode])
      ens  = analyze_benchmarks($DROID_BENCH, $RUNS, options[:mode])
      paper_dump(devs,ens,$DROID_BENCH, $RUNS)
    else
      analyze_benchmarks($DROID_BENCH, $RUNS, options[:mode])
    end
  end

end 
