#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

original = "total length longest"

part_measured = "longest"
measurement_type = "total length"

puts CatalogMeasurement.where(part_measured: original)
                  .where(measurement_type: nil)
                  .update_all({part_measured: part_measured, measurement_type: measurement_type})