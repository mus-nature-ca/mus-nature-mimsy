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

  opts.on("-c", "--collection [collection]", String, "Collection to export") do |collection|
    options[:collection] = collection
  end

  opts.on("-a", "--all", "Export all data") do
    options[:all] = true
  end
end.parse!

dt = DateTime.now.strftime("%Y-%d-%m-%H-%M")

if options[:collection]
  catalogs = Catalog.where(collection: options[:collection])
  File.write(output_dir(__FILE__) + "/catalog-#{dt}.csv", catalogs.to_csv)
elsif options[:all]
  models = ActiveRecord::Base.descendants
  pbar = ProgressBar.new("EXPORT", models.size)
  count = 0
  models.each do |model|
    count += 1
    pbar.set(count)
    File.write(output_dir(__FILE__) + "/export/#{model}.csv", model.to_csv)
  end
  directoryToZip = output_dir(__FILE__) + "/export"
  outputFile = output_dir(__FILE__) + "/export-#{dt}.zip"
  zf = ZipFileGenerator.new(directoryToZip, outputFile)
  zf.write()
  pbar.finish
end