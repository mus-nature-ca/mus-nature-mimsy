#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../../environment.rb'

include Sinatra::Mimsy::Helpers

ARGV << '-h' if ARGV.empty?

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: export.rb [options]"

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end

  opts.on("-p", "--processes [processes]", Integer, "Number of processes") do |process|
    options[:processes] = process
  end

  opts.on("-m", "--model [MODEL]", String, "Model to export") do |model|
    options[:model] = model
  end

  opts.on("-a", "--all", "Export all data") do
    options[:all] = true
  end

  opts.on("-f", "--fields", "Export fields only as csv files for each model. Includes mappings to EMu in migration_mappings/original when present.") do
    options[:fields] = true
  end

  opts.on("-s", "--schema-diagram", "Export the schema diagram") do
    options[:schema_diagram] = true
  end

  opts.on("-t", "--migration-templates", "Export default yaml migration templates for all models") do
    options[:migration_templates] = true
  end

  opts.on("-d", "--data [CATALOGS]", String, "Export data for a string of catalogs, eg 'CAN 1234, CAN 1235'") do |catalogs|
    options[:data] = catalogs
  end

  opts.on("-g", "--group [GROUP]", String, "Export data for a group by name, eg 'Floristics (2017)'") do |group|
    options[:group] = group
  end

  opts.on("-x", "--collection [COLLECTION]", String, "Export data for a whole collection (category1) by name, eg 'Vascular Plant'") do |collection|
    options[:collection] = collection
  end

  opts.on("-l", "--lists", "Export categorical values for lists") do
    options[:lists] = true
  end

  opts.on("-c", "--controlled-lists", "Export administrative, controlled lists in MIMSY") do
    options[:admin_lists] = true
  end
end.parse!

dt = DateTime.now.strftime("%Y-%m-%d-%H-%M")
dir_zip = File.join(ENV['PWD'], 'outputs', 'all', 'export', "mimsy-#{dt}")

if options[:model]
  start = Time.now
  export = Export.new(File.join(ENV['PWD'], 'outputs', 'all', 'export',))
  export.model(options[:model])
  puts "Duration " + Time.at(Time.now-start).utc.strftime("%H:%M:%S")

elsif options[:data]
  start = Time.now
  output_dir = File.join(ENV['PWD'], 'outputs', 'all')
  export = Export.new(output_dir)
  export.processes = options[:processes] || 4
  export.catalogs(options[:data])
  puts "Duration " + Time.at(Time.now-start).utc.strftime("%H:%M:%S")

elsif options[:group]
  start = Time.now
  output_dir = File.join(ENV['PWD'], 'outputs', 'all')
  export = Export.new(output_dir)
  export.processes = options[:processes] || 4
  export.group(options[:group])
  puts "Duration " + Time.at(Time.now-start).utc.strftime("%H:%M:%S")

elsif options[:collection]
  start = Time.now
  output_dir = File.join(ENV['PWD'], 'outputs', 'all')
  export = Export.new(output_dir)
  export.processes = options[:processes] || 4
  export.collection(options[:collection])
  puts "Duration " + Time.at(Time.now-start).utc.strftime("%H:%M:%S")

elsif options[:migration_templates]
  start = Time.now
  output_dir = File.join(ENV['PWD'], 'migration_mappings', dt)
  export = Export.new(output_dir)
  export.migration_templates
  puts "Duration " + Time.at(Time.now-start).utc.strftime("%H:%M:%S")

elsif options[:fields]
  start = Time.now
  export = Export.new(dir_zip)
  export.processes = options[:processes] || 4
  export.fields
  puts "Duration " + Time.at(Time.now-start).utc.strftime("%H:%M:%S")

elsif options[:admin_lists]
  export = Export.new(dir_zip)
  export.admin_lists

elsif options[:lists]
  start = Time.now
  export = Export.new(dir_zip)
  export.processes = options[:processes] || 4
  export.lists
  puts "Duration " + Time.at(Time.now-start).utc.strftime("%H:%M:%S")

elsif options[:schema_diagram]
  filename = File.join(ENV['PWD'], 'outputs', "all" , "schema")
  export = Export.new(filename)
  export.schema_diagram

elsif options[:all]
  start = Time.now
  export = Export.new(dir_zip)
  export.processes = options[:processes] || 4
  export.all
  puts "Duration " + Time.at(Time.now-start).utc.strftime("%H:%M:%S")
end