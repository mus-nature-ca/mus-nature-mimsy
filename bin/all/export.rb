#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

ARGV << '-h' if ARGV.empty?

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: export.rb [options]"

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end

  opts.on("-m", "--model [MODEL]", String, "Model to export") do |model|
    options[:model] = model
  end

  opts.on("-p", "--processes [processes]", Integer, "Number of processes") do |process|
    options[:processes] = process
  end

  opts.on("-a", "--all", "Export all data") do
    options[:all] = true
  end
end.parse!

dt = DateTime.now.strftime("%Y-%m-%d-%H-%M")
dir_zip = output_dir(__FILE__) + "/export/#{dt}"

if options[:model]
  model = options[:model]
  File.write(output_dir(__FILE__) + "/#{model}-#{dt}.csv", model.constantize.to_csv)
elsif options[:all]
  exclusions = ["CatalogAgent"]
  processes = options[:processes] ||= 4
  start = Time.now
  Dir.mkdir(dir_zip)

  models = ActiveRecord::Base.descendants
  models.delete_if{|m| exclusions.include?(m.name)}
  part = models.length/processes

  model_counts = {}
  Parallel.map(0..4, progress: "Sorting", in_threads: 4) do |i|
    ActiveRecord::Base.connection_pool.with_connection do
      sub = models.slice(models.length/4*i, models.length/4)
      sub.each do |model|
        model_counts[model.name] = model.count
      end
    end
  end

  #remove large models from array & later evenly distribute them among available processes
  large_models = model_counts.sort_by{|_key, value| value}.reverse.first(processes).to_h.keys
  models.delete_if{|m| model_counts[m.name] == 0 || large_models.include?(m.name)}.shuffle!
  part = models.length/processes

  Parallel.map(0..processes, progress: "Exporting", in_processes: processes) do |i|
    sub = models.slice(part*i, part)
    sub << large_models[i].constantize if i < processes
    sub.each do |model|
      CSV.open(output_dir(__FILE__) + "/export/#{dt}/#{model.name}.csv", 'w') do |csv|
        csv << model.custom_attribute_names
        model.find_each do |row|
          csv << row.attributes.values
        end
      end
    end
  end

  zf = ZipFileGenerator.new(dir_zip, dir_zip + ".zip")
  zf.write()
  FileUtils.rm_rf(dir_zip)
  puts "Duration " + Time.at(Time.now-start).utc.strftime("%H:%M:%S")
end