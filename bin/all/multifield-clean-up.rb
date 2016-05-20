#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

CSV.open(output_dir(__FILE__) + "/multifield-clean-up.csv", 'w') do |csv|
  csv << ["mkey", "descriptor", "term", "note"]
  CatalogMultifield.find_in_batches do |batches|
    batches.each do |cm|
      if cm.descriptor == "substrate" && !cm.note.nil? && cm.term == "n/a"
        csv << [cm.mkey, cm.descriptor, cm.term, cm.note]
        cm.term = cm.note
        cm.note = nil
        cm.save
      end
    end
  end
end