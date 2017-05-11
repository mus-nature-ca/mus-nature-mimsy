#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../../environment.rb'
require_relative '../../../lib/export.rb'

include Sinatra::Mimsy::Helpers

ARGV << '-h' if ARGV.empty?

options = {}

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: mapping-check.rb [options]"

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end

  opts.on("-m", "--mimsy", "Produce list of MIMSY columns that are not mapped to EMu columns") do
    options[:mimsy] = true
  end

  opts.on("-e", "--emu", "Produce list of EMu columns that are not mapped to MIMSY columns") do
    options[:emu] = true
  end

end.parse!

emu_fields = []
emu_file = File.join(ENV['PWD'], 'migration_mappings', "emu_fields.csv")
CSV.foreach(emu_file, :headers => true) do |row|
  next if !row["emu_module"] || !row["emu_column"]
  emu_fields << row["emu_module"] + ":" + row["emu_column"]
end

unmapped_fields = []
mapped_fields = []
mappings_dir = File.join(ENV['PWD'], 'migration_mappings', "original")
models = ActiveRecord::Base.descendants
models.delete_if{|m| Export::EXCLUSIONS.include?(m.name)}
models.each do |model|
  if File.file?(File.join(mappings_dir, "#{model.name}.yaml"))
    mappings = YAML.load_file(File.join(mappings_dir, "#{model.name}.yaml"))
    mappings.each do |m|
      if !m.second[:module].empty?
        mapped_fields << m.second[:module] + ":" + m.second[:column]
      else
        unmapped_fields << "#{model.name}.#{m.first.to_s}"
      end
    end
  end
end

if options[:mimsy]
  puts unmapped_fields
  puts "Total: #{unmapped_fields.count}"

elsif options[:emu]
  missing = emu_fields - mapped_fields
  puts missing
  puts "Total: #{missing.count}"
end