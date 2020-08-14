#!/usr/bin/env ruby

require 'terminal-table'
require 'optparse'

$DIR   = "baware_run"

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
  #  javaboy is missing some results
}

$DROID_BENCH = {
  NewPipe:"NewPipe", 
  duckduckgo:"duckduckgo", 
  SoundRecorder:"SoundRecorder", 
  MaterialLife:"MaterialLife", 
}

$RUNS = [
  "run_sd_hc",  # 0
  "run_sd_hcu", # 1
  "run_sd_mc",  # 2
  "run_sd_mcu", # 3
  "run_sd_lc",  # 4
  "run_sd_lcu", # 5

  "run_md_hc",  # 6
  "run_md_hcu", # 7
  "run_md_mc",  # 8
  "run_md_mcu", # 9
  "run_md_lc",  # 10
  "run_md_lcu", # 11

  "run_ld_hc",  # 12
  "run_ld_hcu", # 13
  "run_ld_mc",  # 14
  "run_ld_mcu", # 15
  "run_ld_lc",  # 16
  "run_ld_lcu"  # 17
  ]

$DROID_RUNS = [
  "run_sd_hc_p",  # 0
  "run_sd_hc_u", # 1
  "run_sd_mc_p",  # 2
  "run_sd_mc_u", # 3
  "run_sd_lc_p",  # 4
  "run_sd_lc_u", # 5

  "run_md_hc_p",  # 6
  "run_md_hc_u", # 7
  "run_md_mc_p",  # 8
  "run_md_mc_u", # 9
  "run_md_lc_p",  # 10
  "run_md_lc_u", # 11

  "run_ld_hc_p",  # 12
  "run_ld_hc_u", # 13
  "run_ld_mc_p",  # 14
  "run_ld_mc_u", # 15
  "run_ld_lc_p",  # 16
  "run_ld_lc_u"  # 17
  ]

$DATAS = ["energy_saver", "managed", "full_throttle"]

$CONTEXTS = ['"full_throttle"', '"full_throttle silent"', '"managed"', '"managed silent"', '"energy_saver"', '"energy_saver silent"']

$SIZE_LABELS = ["small", "medium", "large"]

$CONTXT_LABELS = ["-",  "full mean", "full rel",
                        "ufull mean",  "ufull rel",
                        "managed mean", "managed rel", 
                        "umanaged mean", "umanaged rel",
                        "saver mean", "saver rel",
                        "usaver mean", "usaver rel" ]


$CONTXT_LABELS2 = ["-", "f1d", "f2d", "f3d", "f4d", "",
                        "uf1d", "uf2d", "uf3d", "uf4d", "",

                        "m1d", "m2d", "m3d", "m4d", "",
                        "um1d", "um2d", "um3d", "um4d", "",

                        "s1d", "s2d", "s3d", "s4d", "",
                        "us1d", "us2d", "us3d", "us4d", ""]



def stats_benchmarks(benches, runs, mode)
  # Build table for energy consumed for each run
  front_path = ""
  front_dat = ""
  device = ""
  case mode
  when :intel_mode
    front_path = "."
    front_dat = "./dat"
    device = "Intel"
  when :pi_mode
    front_path = "./pi_bench"
    front_dat = "./pi_dat"
    device = "Pi"
  when :droid_mode
    front_path = "./android_bench"
    front_dat = "./droid_dat"
    device = "Droid"
  end 

  deviationtable = {}

  # Go through and dump standard deviations for runs for each benchmark
  totaltable = []
  totals = [0,0,0,0]
  reltotals = [0,0,0]
  nonsmall_reltotals = [0,0,0]
  total_runs = 0
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

      m = File.open("./#{front_path}/#{path}/baware_run/#{runs[i]}.txt").read().scan(/^(?!\/\/)ERun.*:(.*)$/)

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
      variance = energies.inject { |sum,n| sum + ((n - mean) ** 2) } / (num_runs.to_f)
      deviation = Math.sqrt(variance)
      #dev_stat_cols << deviation.round(2)
      rel_dev = ((deviation / mean) * 100.0).round(2)
      dev_stat_cols << rel_dev

      deviations << deviation.round(2)

      if (rel_dev < 2.0) then
        reltotals[0] += 1
        bench_reltotals[0] += 1
        if (i > 5) then
          nonsmall_bench_reltotals[0] += 1
          nonsmall_reltotals[0] += 1
        end
      end

      if (rel_dev < 3.0) then
        reltotals[1] += 1
        bench_reltotals[1] += 1
        if (i > 5) then
          nonsmall_bench_reltotals[1] += 1
          nonsmall_reltotals[1] += 1
        end
      end


      if (rel_dev < 5.0) then
        reltotals[2] += 1
        bench_reltotals[2] += 1
        if (i > 5) then
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

      if ((i + 1) % 6 == 0) then
        dev_stat_rows << dev_stat_cols
        dev_stat_cols = [$SIZE_LABELS[(i+1)/6]]

        dev_run_rows << dev_run_cols
        dev_run_cols = [$SIZE_LABELS[(i+1)/6]]
      end 
    end

    deviationtable[bench] = deviations

    puts Terminal::Table.new :title => "#{bench} Deviation Statistics", 
      :headings => $CONTXT_LABELS, 
      :rows => dev_stat_rows
    puts "\n"

  #  puts Terminal::Table.new :title => "#{bench} Deviation Runs", 
  #    :headings => $CONTXT_LABELS2, 
  #    :rows => dev_run_rows
  #  puts "\n"

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

    puts "#{bench} Nonsmall Total Within 2% Deviation: #{nonsmall_bench_reltotals[0]}"
    puts "#{bench} Nonsmall Total Within 3% Deviation: #{nonsmall_bench_reltotals[1]}"

    puts "#{bench} Nonsmall Percent Total Within 2% Deviation: #{(nonsmall_bench_reltotals[0]/12.0) * 100.0}"
    puts "#{bench} Nonsmall Percent Total Within 3% Deviation: #{(nonsmall_bench_reltotals[1]/12.0) * 100.0}"

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

  puts "All Percent Total Within 2% Deviation: #{(reltotals[0]/(18.0*len)) * 100.0}"
  puts "All Percent Total Within 3% Deviation: #{(reltotals[1]/(18.0*len)) * 100.0}"

  puts "Nonsmall Percent Total Within 2% Deviation: #{(nonsmall_reltotals[0]/(12.0*len)) * 100.0}"
  puts "Nonsmall Percent Total Within 3% Deviation: #{(nonsmall_reltotals[1]/(12.0*len)) * 100.0}"
  puts "Nonsmall Percent Total Within 5% Deviation: #{(nonsmall_reltotals[2]/(12.0*len)) * 100.0}"

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
    dir = "aware_run"
  when :pi_mode
    front_path = "./pi_bench"
    front_dat = "./pi_dat"
    device = "Pi"
    dir = "baware_run"
  when :droid_mode
    front_path = "./android_bench"
    front_dat = "./droid_dat"
    device = "Droid"
    dir = "baware_run"
  end 

  benches.each do |bench, path|
    runs.each do |run| 
      puts "#{bench}-#{run}"
      puts File.read("./#{front_path}/#{path}/#{dir}/#{run}.txt")
    end
    puts "\n"
  end

end

def analyze_benchmarks(benches, runs, mode)
  # Build table for energy consumed for each run
  front_path = ""
  front_dat = ""
  device = ""
  case mode
  when :intel_mode
    front_path = "."
    front_dat = "./dat"
    device = "Intel"
  when :pi_mode
    front_path = "./pi_bench"
    front_dat = "./pi_dat"
    device = "Pi"
  when :droid_mode
    front_path = "./android_bench"
    front_dat = "./droid_dat"
    device = "Droid"
  end 

  consumedtable = {}
  benches.each do |bench, path|
    energy = []
    for i in 0..runs.length-1 do
      m = File.open("./#{front_path}/#{path}/#{$DIR}/#{runs[i]}.txt").read().scan(/^(?!\/\/)ERun.*:(.*)$/)
      e = 0.0
      drop_first = false
      num_runs = 0

      case mode
      when :intel_mode
        front_path = "."
        drop_first = true
        num_runs = m.length-1
      when :pi_mode
        front_path = "./pi_bench"
        drop_first = true
        num_runs = m.length-1
      when :droid_mode
        drop_first = false
        front_path = "./android_bench"
        num_runs = m.length
      end 

      for i in 0..m.length-1 do
        next if i == 0 && drop_first

        e += m[i][0].strip().split()[2].to_f
      end
      energy << e / num_runs.to_f
    end
    consumedtable[bench] = energy
  end

  # Dump tables for gnuplot
  benches.each do |bench, path|
    consumeddat = File.open("#{front_dat}/baware_#{bench}_consumed.dat", "w+")

    consumeddat.write("data\tcontext\tenergy\torder\n")

    for i in 0..2 do
      for j in (i*6)...((i+1)*6) do
        consumeddat.write("#{$DATAS[i]}\t#{$CONTEXTS[j%6]}\t#{consumedtable[bench][j]}\t#{(j%6)}\n")
      end
    end
  end 

  puts "\\hline"
  puts "\\textbf{name} & \\textbf{workload mode} & \\textbf{saver boot silent (J)} & \\textbf{saver boot ent (J)} & \\textbf{difference (J)} & \\textbf{energy saved (\\%)} \\\\"

  # Dump energy saved tables
  rows = []
  rowse = []
  benches.each do |bench, path|
    es_m = consumedtable[bench][11] - consumedtable[bench][10]
    es_me = (es_m / consumedtable[bench][11]) * 100.0

    m_ft = consumedtable[bench][15] - consumedtable[bench][14]
    m_fte = (m_ft / consumedtable[bench][15]) * 100.0

    es_ft = consumedtable[bench][17] - consumedtable[bench][16]
    es_fte = (es_ft / consumedtable[bench][17]) * 100.0
    
    rows << [bench, es_m.round(2), m_ft.round(2), es_ft.round(2)]
    rowse << [bench, es_me.round(2), m_fte.round(2), es_fte.round(2)]

    puts "\\hline"
    puts "#{bench} & full & #{consumedtable[bench][17].round(2)} & #{consumedtable[bench][16].round(2)} & #{es_ft.round(2)} & #{es_fte.round(2)}\\% \\\\"

    puts "\\hline"
    puts "#{bench} & managed & #{consumedtable[bench][11].round(2)} & #{consumedtable[bench][10].round(2)} & #{es_m.round(2)} & #{es_me.round(2)}\\% \\\\"

    rows << :separator
    rowse << :separator
  end 

  puts "\\hline"

  puts Terminal::Table.new :title => "#{device} Raw Difference", 
                           :headings => ["Bench", "saver-managed", "managed-full", "saver-full"], 
                           :rows => rows
  puts Terminal::Table.new :title => "#{device} Percent Error (Against silent)", 
                           :headings => ["Bench", "saver-managed", "managed-full", "saver-full"], 
                           :rows => rowse
  return consumedtable
end

def paper_dump(dev,ens,benchs,runs)

  puts "\\textbf{name} & \\textbf{workload} & \\textbf{full boot (J)} & \\textbf{full deviation (J)} & \\textbf{silent full boot (J)} & \\textbf{silent full deviation (J)} \\\\"

  benchs.each do |bench,path| 
    puts "\\hline"
    puts "#{bench.to_s} & full & #{ens[bench][12].round(2)} & #{dev[bench][12].round(2)} & #{ens[bench][13].round(2)} & #{dev[bench][13].round(2)} \\\\"
    puts "\\hline"
    puts "#{bench.to_s} & managed & #{ens[bench][6].round(2)} & #{dev[bench][6].round(2)} & #{ens[bench][7].round(2)} & #{dev[bench][7].round(2)} \\\\"
    puts "\\hline"
    puts "#{bench.to_s} & saver & #{ens[bench][0].round(2)} & #{dev[bench][0].round(2)} & #{ens[bench][1].round(2)} & #{dev[bench][1].round(2)} \\\\"
  end

  puts "\\hline"
  puts "\\textbf{name} & \\textbf{workload} & \\textbf{managed boot (J)} & \\textbf{managed deviation (J)} & \\textbf{silent managed boot (J)} & \\textbf{silent managed deviation (J)} \\\\"

  benchs.each do |bench,path| 
    puts "\\hline"
    puts "#{bench.to_s} & full & #{ens[bench][14].round(2)} & #{dev[bench][14].round(2)} & #{ens[bench][15].round(2)} & #{dev[bench][15].round(2)} \\\\"
    puts "\\hline"
    puts "#{bench.to_s} & managed & #{ens[bench][8].round(2)} & #{dev[bench][8].round(2)} & #{ens[bench][9].round(2)} & #{dev[bench][9].round(2)} \\\\"
    puts "\\hline"
    puts "#{bench.to_s} & saver & #{ens[bench][2].round(2)} & #{dev[bench][2].round(2)} & #{ens[bench][3].round(2)} & #{dev[bench][3].round(2)} \\\\"
  end

  puts "\\hline"
  puts "\\textbf{name} & \\textbf{workload} & \\textbf{saver boot (J)} & \\textbf{saver deviation (J)} & \\textbf{silent saver boot (J)} & \\textbf{silent saver deviation (J)} \\\\"

  benchs.each do |bench,path| 
    puts "\\hline"
    puts "#{bench.to_s} & full & #{ens[bench][16].round(2)} & #{dev[bench][16].round(2)} & #{ens[bench][17].round(2)} & #{dev[bench][17].round(2)} \\\\"
    puts "\\hline"
    puts "#{bench.to_s} & managed & #{ens[bench][10].round(2)} & #{dev[bench][10].round(2)} & #{ens[bench][11].round(2)} & #{dev[bench][11].round(2)} \\\\"
    puts "\\hline"
    puts "#{bench.to_s} & saver & #{ens[bench][4].round(2)} & #{dev[bench][4].round(2)} & #{ens[bench][5].round(2)} & #{dev[bench][5].round(2)} \\\\"
  end
  puts "\\hline"

end

if __FILE__ == $0
  options = {}
  options[:mode] = :intel_mode
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

    opts.on("-b", "--paper-mode", "Run dump of data.") do |p|
      options[:paper] = true
    end 
  end

  optparse.parse!

  case options[:mode]
  when :intel_mode
    if options[:stats] then
      stats_benchmarks($INTEL_BENCH, $RUNS, options[:mode])
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
    elsif options[:paper]
      devs = stats_benchmarks($PI_BENCH, $RUNS, options[:mode])
      ens  = analyze_benchmarks($PI_BENCH, $RUNS, options[:mode])
      paper_dump(devs,ens, $PI_BENCH, $RUNS)
    else
      analyze_benchmarks($PI_BENCH, $RUNS, options[:mode])
    end
  when :droid_mode
    if options[:stats] then
      stats_benchmarks($DROID_BENCH, $DROID_RUNS, options[:mode])
    elsif options[:raw]
      raw_dump($DROID_BENCH, $DROID_RUNS, options[:mode])
    elsif options[:paper]
      devs = stats_benchmarks($DROID_BENCH, $DROID_RUNS, options[:mode])
      ens  = analyze_benchmarks($DROID_BENCH, $DROID_RUNS, options[:mode])
      paper_dump(devs,ens,$DROID_BENCH, $RUNS)
    else
      analyze_benchmarks($DROID_BENCH, $DROID_RUNS, options[:mode])
    end
  end

end 
