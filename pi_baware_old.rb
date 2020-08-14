#!/usr/bin/env ruby

require 'terminal-table'


$BENCH = {sunflow:"sunflow", crypto:"crypto", camera:"camera", video:"video", manual:"manual"}
$DIR   = "pi_dat"
$DATAS = ['"energy-saver"', '"managed"', '"full-throttle"']

# Build table for energy consumed for each run
consumedtable = {}
$BENCH.each do |bench, path|
  energy = []
  file = File.open("./#{$DIR}/baware_#{bench}_consumed.dat")
  skip = true
  file.each_line do |line|
    if skip
      skip = false
      next
    end
    data = line.split
    energy << data[1].to_f
    energy << data[2].to_f
    energy << data[3].to_f
    energy << data[4].to_f
    energy << data[5].to_f
    energy << data[6].to_f
  end
  consumedtable[bench] = energy 
end 

# Dump energy saved tables
rows = []
rowsp = []
rowse = []
$BENCH.each do |bench, path|
  p bench
  p consumedtable[bench]

  es_m = consumedtable[bench][11] - consumedtable[bench][10]
  es_mp = (es_m / ((consumedtable[bench][11] + consumedtable[bench][10]) / 2.0)) * 100.0
  es_me = (es_m / consumedtable[bench][11]) * 100.0

  m_ft = consumedtable[bench][15] - consumedtable[bench][14]
  m_ftp = (m_ft / ((consumedtable[bench][15] + consumedtable[bench][14]) / 2.0)) * 100.0
  m_fte = (m_ft / consumedtable[bench][15]) * 100.0

  es_ft = consumedtable[bench][17] - consumedtable[bench][16]
  es_ftp = (es_ft / ((consumedtable[bench][17] + consumedtable[bench][17]) / 2.0)) * 100.0
  es_fte = (es_ft / consumedtable[bench][17]) * 100.0
  
  rows << [bench, es_m.round(2), m_ft.round(2), es_ft.round(2)]
  rowsp << [bench, es_mp.round(2), m_ftp.round(2), es_ftp.round(2)]
  rowse << [bench, es_me.round(2), m_fte.round(2), es_fte.round(2)]

  rows << :separator
  rowsp << :separator
  rowse << :separator
end 

table = Terminal::Table.new :title => "Raw Difference", :headings => ["Bench", "saver-managed", "managed-full", "saver-full"], :rows => rows
puts table

#table2 = Terminal::Table.new :title => "Percent Difference", :headings => ["Bench", "saver-managed", "managed-full", "saver-full"], :rows => rowsp
#puts table2

table3 = Terminal::Table.new :title => "Percent Error (Against full-throttle)", :headings => ["Bench", "saver-managed", "managed-full", "saver-full"], :rows => rowse
puts table3


