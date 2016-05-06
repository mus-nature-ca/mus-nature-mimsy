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
exclusions = ["CatalogAgent"]

if options[:collection]
  catalogs = Catalog.where(collection: options[:collection])
  File.write(output_dir(__FILE__) + "/catalog.csv", catalogs.to_csv)
elsif options[:all]
  Dir.mkdir(output_dir(__FILE__) + "/export/#{dt}")
  models = ActiveRecord::Base.descendants
  count = 0
  models.each do |model|
    next if exclusions.include? model.name
    pbar = ProgressBar.new("#{model}", model.count)
    count = 0
    CSV.open(output_dir(__FILE__) + "/export/#{dt}/#{model}.csv", 'w') do |csv|
      csv << model.custom_attribute_names
      model.find_each do |row|
        count += 1
        pbar.set(count)
        csv << row.attributes.values
      end
    end
    pbar.finish
  end
  dir_zip = output_dir(__FILE__) + "/export/#{dt}"
  output_file = output_dir(__FILE__) + "/export/#{dt}.zip"
  zf = ZipFileGenerator.new(dir_zip, output_file)
  zf.write()
end