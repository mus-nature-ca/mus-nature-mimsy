#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/inverts-import-objects.csv"

CSV.foreach(file, :headers => true) do |row|
  #TODO
end