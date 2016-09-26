#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

collections = ["Fish", "Crustacea", "Bird", "Amphibian and Reptile", "Mollusc"]
measurements = CatalogOtherMeasurement.joins(:catalog).where("catalogue.category1": collections).where(part_measured: "length")

byebug
puts ""

