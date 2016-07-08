#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

dt = DateTime.now.strftime("%Y-%m-%d-%H-%M")
dir_zip = output_dir(__FILE__) + "/export/#{dt}"

start = Time.now
exclusions = ["CatalogAgent"]
processes = 4
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

Parallel.map(0..processes, progress: "NilAttributes", in_processes: processes) do |i|
  sub = models.slice(part*i, part)
  sub << large_models[i].constantize if i < processes
  sub.each do |model|
    nil_attributes = [:step, :record_view]
    model.attribute_names.each do |attribute|
      nil_attributes << attribute.to_sym if model.pluck(attribute).uniq.compact.empty?
    end
    content = "ignore_columns " + nil_attributes.to_s.gsub(/[\[\]]/,"")
    File.write(output_dir(__FILE__) + "/export/#{dt}/#{model.name}.txt", content)
  end
end