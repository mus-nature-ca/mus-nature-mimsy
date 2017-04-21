#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

catalog_numbers = [
"CAN 298911",
"CAN 318163",
"CAN 282575",
"CAN 311562",
"CAN 87520",
"CAN 87524",
"CAN 310643",
"CAN 261974",
"CAN 298331",
"CAN 311125",
"CAN 298330",
"CAN 87680",
"CAN 474258",
"CAN 362411",
"CAN 404391",
"CAN 383015",
"CAN 404390",
"CAN 87633",
"CAN 87634",
"CAN 474254",
"CAN 87626",
"CAN 474255",
"CAN 273918",
"CAN 271688",
"CAN 87635",
"CAN 298332",
"CAN 330172",
"CAN 330166",
"CAN 330163",
"CAN 258498",
"CAN 87681",
"CAN 330162",
"CAN 298333",
"CAN 564912",
"CAN 356623",
"CAN 87538",
"CAN 87529",
"CAN 285198",
"CAN 383223",
"CAN 362412",
"CAN 330164",
"CAN 330168",
"CAN 275184",
"CAN 318144",
"CAN 87698",
"CAN 291614",
"CAN 87696",
"CAN 87798",
"CAN 303696",
"CAN 87809",
"CAN 87799",
"CAN 375956",
"CAN 318362",
"CAN 283731",
"CAN 576641",
"CAN 269828",
"CAN 277475",
"CAN 312565",
"CAN 87795",
"CAN 288005",
"CAN 271694",
"CAN 303214",
"CAN 525158",
"CAN 330168",
"CAN 318144",
"CAN 87719",
"CAN 200159",
"CAN 87697",
"CAN 216007",
"CAN 211358",
"CAN 226133",
"CAN 87800",
"CAN 87796",
"CAN 283730",
"CAN 280257",
"CAN 279463",
"CAN 87797",
"CAN 563170"
]

catalog_numbers.each do |cn|
  puts cn
  catalog = Catalog.find_by_catalog_number(cn)
  if catalog.catalog_taxa.count > 1
    byebug
    puts ""
  else
    ct = catalog.catalog_taxa.first
    ct.taxvarkey = nil
    ct.save
  end
end