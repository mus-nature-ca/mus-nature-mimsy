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

  opts.on("-f", "--fields", "Export fields only") do
    options[:fields] = true
  end

  opts.on("-s", "--schema-diagram", "Export the schema diagram") do
    options[:schema_diagram] = true
  end

  opts.on("-t", "--migration-templates", "Export default yaml migration templates for all models") do
    options[:migration_templates] = true
  end

  opts.on("-l", "--lists", "Export categorical values for lists") do
    options[:lists] = true
  end

  opts.on("-c", "--controlled-lists", "Export administrative, controlled lists in MIMSY") do
    options[:admin_lists] = true
  end
end.parse!

dt = DateTime.now.strftime("%Y-%m-%d-%H-%M")
dir_zip = output_dir(__FILE__) + "/export/mimsy-#{dt}"

if options[:model]
  start = Time.now
  export = Export.new(output_dir(__FILE__))
  export.model(options[:model])
  puts "Duration " + Time.at(Time.now-start).utc.strftime("%H:%M:%S")

#Warning: will overwrite existing yaml mappings
elsif options[:migration_templates]
  start = Time.now
  output_dir = File.join(ENV['PWD'], 'migration_mappings', dt)
  export = Export.new(output_dir)
  export.migration_templates
  puts "Duration " + Time.at(Time.now-start).utc.strftime("%H:%M:%S")

elsif options[:fields]
  start = Time.now
  processes = options[:processes] || 4
  export = Export.new(dir_zip)
  export.fields(processes)
  puts "Duration " + Time.at(Time.now-start).utc.strftime("%H:%M:%S")

elsif options[:admin_lists]
  export = Export.new(dir_zip)
  export.admin_lists

elsif options[:lists]
  start = Time.now
  processes = options[:processes] || 4
  export = Export.new(dir_zip)
  export.lists(processes)
  puts "Duration " + Time.at(Time.now-start).utc.strftime("%H:%M:%S")

elsif options[:schema_diagram]
  filename = File.join(output_dir(__FILE__), "schema")
  export = Export.new(filename)
  export.schema_diagram

elsif options[:all]
  start = Time.now
  processes = options[:processes] || 4
  export = Export.new(dir_zip)
  export.all(processes)
  puts "Duration " + Time.at(Time.now-start).utc.strftime("%H:%M:%S")
end