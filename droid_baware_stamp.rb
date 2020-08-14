#!/usr/bin/env ruby

require 'terminal-table'

$BENCH = {
#  NewPipe:"NewPipe",
# duckduckgo:"duckduckgo",
#  SoundRecorder:"SoundRecorder",
  MaterialLife:"MaterialLife",
}

$DIR   = "baware_run"

$RUNS = [
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

# Input = Date(Day) Date(Time) Timestamp V1 V2 V3
# Output = Timestamp V1 V2 V3
def load_timestamp(fname)
  stamps = []
  File.open(fname).read().each_line do |line|
    parsed = line.strip().split() 
    stamps << [parsed[2].to_f, parsed[3].to_f, parsed[4].to_f, parsed[5].to_f]
  end
  return stamps
end

def within(stamp1,stamp2,compare)
  return (stamp1 <= compare && compare <= stamp2)
end

def get_energy(stamps, tmin, tmax)
  i = 0
  while i < stamps.length && !within(stamps[i][0],stamps[i+1][0],tmin) 
    i += 1
  end
  if i >= stamps.length then
    puts "ERROR: Couldn't find timestamp"
    exit
  end
  indexmin = i

  while i < stamps.length && !within(stamps[i][0],stamps[i+1][0],tmax)
    i += 1
  end
  if i >= stamps.length then
    puts "ERROR: Couldn't find timestamp"
    exit
  end
  indexmax = i

  energy = 0.0
  for j in indexmin..indexmax do
    energy += stamps[j][2]
  end
  
  return energy
end


# Main
if ARGV.length < 1
  puts "pi_baware_stamp.rb [TIMESTAMP FILE]"
  exit
end

timestamp_file = ARGV[0]
stamps = load_timestamp(timestamp_file)

# Build table for energy consumed for each run
$BENCH.each do |bench, path|
  $RUNS.each do |run| 
    refstamps = File.open("./android_bench/#{path}/#{$DIR}/#{run}.stamp").read().scan(/ERun.*:(.*)$/)

    puts "#{bench} #{run}"

    energyfile = File.open("./android_bench/#{path}/#{$DIR}/#{run}.txt", "w")
    energyfile.write("// Created from #{timestamp_file}\n") 

    for i in 0..refstamps.length-1 do
      parsed = refstamps[i][0].strip().split()
      #e += m[i][0].strip().split()[2].to_f
      tmin = parsed[0].to_f
      tmax = parsed[1].to_f

      energy = get_energy(stamps, tmin, tmax)
      energyfile.write("ERun: #{i}: 0 0 #{energy} 0\n")
    end
    energyfile.close

  end
end

