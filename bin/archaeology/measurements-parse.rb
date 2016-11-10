#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

catalogs = [
  "JgMf-0012:000001",
  "JgMf-0013:000001",
  "JgMf-0016:000001",
  "KdLh-0011:000089",
  "KdLh-0025:000001",
  "KdLh-0026:000001",
  "KfJm-0171:000033",
  "KfJm-0171:000034",
  "KfJm-0171:000035",
  "KgJm-0023:000001",
  "KgJm-0024:000001",
  "KgJm-0024:000002",
  "KgJm-0024:000003",
  "KgJm-0024:000005",
  "KgJm-0024:000005",
  "KgJm-0024:000006",
  "KgJm-0024:000007",
  "KgJm-0024:000007",
  "KgJm-0024:000007",
  "KgJm-0024:000007",
  "KgJm-0024:000009",
  "KgJm-0024:000010",
  "KgJm-0024:000011",
  "KgJm-0025:000001",
  "KgJm-0025:000002",
  "KgJm-0025:000003",
  "KgJm-0025:000004",
  "KgJm-0025:000005",
  "KgJm-0025:000006",
  "KgJm-0035:000008",
  "KgJm-0035:000008",
  "KgJm-0056:000001",
  "LcLh-0011:000051",
  "LcLh-0011:000072",
  "LcLh-0023:000009",
  "LfNo-0002:000001",
  "LfNo-0004:000001",
  "LfNo-0004:000002",
  "LfNo-0007:000001",
  "LhNr-0008:000001",
  "LhNr-0009:000001",
  "LhNr-0009:000002",
  "LhNr-0009:000003",
  "LhNr-0009:000004",
  "LhNr-0009:000005",
  "LhNr-0009:000006",
  "LhNr-0009:000007",
  "LhNr-0010:000001",
  "LjNj-0003:000001",
  "LjNj-0003:000002",
  "LjNj-0003:000003",
  "LjNj-0003:000004",
  "LjNj-0006:000001",
  "LjNj-0006:000002",
  "LjNj-0006:000003a&b",
  "ObFt-0006:000001",
  "ObFt-0049:000022",
  "ObFt-0049:000195"
]

measurements = CatalogMeasurement.joins(:catalog)
                                 .where("catalogue.id_number": catalogs)
                                 .where.not(part_measured: nil)

pbar = ProgressBar.create(title: "ARCH", total: measurements.count, autofinish: false, format: '%t %b>> %i| %e')

measurements.each do |measurement|
  pbar.increment
  dimensions = measurement.part_measured.split("x").map{ |d| d.strip.downcase }
  dimensions.each_with_index do |dimension, i|
    i += 1
    if dimension == "weight"
      new_record = {
        mkey: measurement.mkey,
        part_measured: "whole",
        measurement_type: dimension,
        dimension1: measurement.weight1.to_f,
        unit1: measurement.wunit1,
        weight1: measurement.weight1.to_f,
        wunit1: measurement.wunit1
      }
    else
      new_record = {
        mkey: measurement.mkey,
        part_measured: "whole",
        measurement_type: dimension,
        dimension1: measurement.send("dimension#{i}").to_f,
        unit1: measurement.send("unit#{i}")
      }
    end
    CatalogMeasurement.create(new_record)
  end 
end

pbar.finish