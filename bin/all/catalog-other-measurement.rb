#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

measurements = CatalogOtherMeasurement.joins(:catalog)
                                      .where("catalogue.category1": Collection::Zoology)
                                      .where(part_measured: "total length")

byebug
puts ""

