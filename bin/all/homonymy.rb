#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

processes = 10
taxa = Taxon.all
unit_size = taxa.size/processes

CSV.open(output_dir(__FILE__) + "/homonymy.csv", 'w') do |csv|
  csv << ["speckey", "scientific_name"]
  Parallel.map(0..processes, progress: "Homonymy", in_processes: processes) do |i|
    start = (i == 0) ? 0 : i*unit_size+1
    finish = (i+1)*unit_size
    taxa[start..finish].each do |t|
      next if t.parent.nil?
      if t.collection != t.parent.collection
         csv << [t.speckey.to_i, t.scientific_name]
      end
    end
  end
end