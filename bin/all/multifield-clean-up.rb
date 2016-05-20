#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

CatalogMultifield.find_in_batches do |batches|
  batches.each do |cm|
    if cm.descriptor == "substrate" && !cm.note.nil? && cm.term == "n/a"
      puts [cm.mkey, cm.note] 
#      cm.term = cm.note
#      cm.note = nil
#      cm.save
    end
  end
end