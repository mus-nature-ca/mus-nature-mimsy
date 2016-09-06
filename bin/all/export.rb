#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

ARGV << '-h' if ARGV.empty?

options = {}

def interleave(a,*args)
  max_length = args.map(&:size).max
  padding = [nil]*[max_length-a.size, 0].max
  (a+padding).zip(*args)
end

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

  opts.on("-l", "--lists", "Export categorical values for lists") do
    options[:lists] = true
  end

  opts.on("-c", "--controlled-lists", "Export administrative, controlled lists in MIMSY") do
    options[:admin_lists] = true
  end
end.parse!

dt = DateTime.now.strftime("%Y-%m-%d-%H-%M")
dir_zip = output_dir(__FILE__) + "/export/mimsy-#{dt}"

exclusions = [
  "CatalogAgent", "CatalogVessel", "Vessel", "VesselAccessory",
  "VesselComponent", "VesselDescription", "VesselMarking",
  "VesselMeasurement", "VesselMultifield", "VesselName",
  "VesselOtherNumber", "VesselStatus", "VesselType"
]

if options[:model]
  start = Time.now
  model = options[:model]
  File.write(output_dir(__FILE__) + "/#{model}-#{dt}.csv", model.constantize.to_csv)
  puts "Duration " + Time.at(Time.now-start).utc.strftime("%H:%M:%S")

elsif options[:fields]
  start = Time.now
  processes = options[:processes] || 4
  Dir.mkdir(dir_zip)

  models = ActiveRecord::Base.descendants
  models.delete_if{|m| exclusions.include?(m.name)}
  part = models.length/processes

  Parallel.map(0..processes, progress: "Exporting Fields", in_processes: processes) do |i|
    sub = models.slice(part*i, part)
    sub.each do |model|
      CSV.open(dir_zip + "/#{model.name}_fields.csv", 'w') do |csv|
        csv << ["original", "custom"]
        original = model.attribute_names
        custom = model.custom_attribute_names
        pairs = Hash[custom.zip(original)].to_a.map{ |pair| pair.reverse }
        pairs.each do |pair|
          csv << pair
        end
      end
    end
  end
  puts "Duration " + Time.at(Time.now-start).utc.strftime("%H:%M:%S")

elsif options[:admin_lists]
  Dir.mkdir(dir_zip)
  lists = List.all_terms
  CSV.open(dir_zip + "/mimsy_admin_lists.csv", 'w') do |csv|
    csv << lists.keys
    values = lists.values
    interleave(values[0],*values[1..-1]).each{ |i| csv << i }
  end

elsif options[:lists]
  start = Time.now
  processes = options[:processes] || 4
  Dir.mkdir(dir_zip)

  models = ActiveRecord::Base.descendants
  models.delete_if{|m| exclusions.include?(m.name)}
  models.delete_if{|m| m.categorical_columns.empty?}

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

  if processes >= models.length
    processes = models.length
  end
  part = models.length/processes

  Parallel.map(0..processes, progress: "Exporting Lists", in_processes: processes) do |i|
    sub = models.slice(part*i, part)
    sub << large_models[i].constantize if i < processes
    sub.each do |model|
      CSV.open(dir_zip + "/#{model.name}_lists.csv", 'w') do |csv|
        csv << model.categorical_columns
        values = model.categorical_values.values
        if model.categorical_columns.size > 1
          interleave(values[0],*values[1..-1]).each{ |i| csv << i }
        else
          values[0].each{ |i| csv << [i] }
        end
      end
    end
  end
  puts "Duration " + Time.at(Time.now-start).utc.strftime("%H:%M:%S")

elsif options[:all]
  start = Time.now
  processes = options[:processes] || 4
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
      CSV.open(dir_zip + "/#{model.name}.csv", 'w') do |csv|
        csv << model.custom_attribute_names
        model.find_each do |row|
          csv << row.custom_attributes.values
        end
      end
    end
  end

  relation = Taxon.where(collection: "Botany").where("scientific_name LIKE '%×%'")
  output = File.join(dir_zip, "TaxonHybrid.csv")
  taxon_hybrids = HybridParser.new(relation,output)
  taxon_hybrids.export

  relation = TaxonVariation.joins(:taxon).where("taxonomy.taxon_name = 'Botany'").where("variation LIKE '%×%'")
  output = File.join(dir_zip, "TaxonVariationHybrid.csv")
  taxon_variation_hybrids = HybridParser.new(relation,output)
  taxon_variation_hybrids.export

  zf = ZipFileGenerator.new(dir_zip, dir_zip + ".zip")
  zf.write()
  FileUtils.rm_rf(dir_zip)
  puts "Duration " + Time.at(Time.now-start).utc.strftime("%H:%M:%S")
end