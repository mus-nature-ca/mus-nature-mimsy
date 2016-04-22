#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: digitization-stats.rb [options]"

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
  
  opts.on("-s", "--start-date [YYYY-MM-DD]", String, "Start date") do |date|
    options[:start_date] = date
  end

  opts.on("-e", "--end-date [YYYY-MM-DD]", String, "End date") do |date|
    options[:end_date] = date
  end

  opts.on("-t", "--type [new, edit, acquisition, all]", String, "New, edit, acquisition, all") do |type|
    options[:type] = type
  end
end

begin
  optparse.parse!
  start_date = 3.months.ago
  end_date = Date.today
  if options[:start_date]
    start_date = Date.parse(options[:start_date])
  end
  if options[:end_date]
    end_date = Date.parse(options[:end_date])
  end
  case options[:type]
  when "new"
    puts Catalog.group("category1").where(create_date: start_date..end_date).order("category1").count
  when "edit"
    puts Catalog.group("category1").where(update_date: start_date..end_date).order("category1").count
  when "acquisition"
    puts Acquisition.group("option1").where(legal_date: start_date..end_date).order("option1").count
    acqs = Acquisition.where(legal_date: start_date..end_date).map{|acq| { acq.option1 => acq.total_approved }}
    puts acqs.inject{|memo, el| memo.merge(el){|k, old_v, new_v| old_v + new_v}}.sort.to_h
  else
    puts "Start date / End date ignored"
    puts Catalog.group("category1").order("category1").count
  end
  
rescue
  puts $!.to_s
  puts optparse
  exit 
end