#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

Parallel.each(TaxonVariation.find_in_batches, progress: "VarTypeMess") do |array_of_instances|
  array_of_instances.each do |tv|
    next if tv.var_type.nil?

    if /^[A-Z]{1}\d+/.match tv.var_type
      csv << [tv.taxvarkey, tv.var_type]
      tv.var_type = nil
      tv.save
    end

  end
end