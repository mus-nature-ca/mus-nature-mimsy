#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

name = "Granfelt, C.E."

Catalog.where(collector: name).find_each do |catalog|
  catalog.collector = "Granfelt, Carl-Eric"
  catalog.save
end