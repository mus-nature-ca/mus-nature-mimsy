#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/collectors.txt"

collectors = []

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|
  next if row["CATALOGUE.COLLECTOR"].nil?
  row["CATALOGUE.COLLECTOR"].split(";").each do |collector|
    collectors << collector.strip
  end
  
end

counts = Hash.new(0)
collectors.each{ |name| counts[name] += 1 }

CSV.open("/Users/dshorthouse/Desktop/collectors_counts.csv", 'w') do |csv|
  counts.sort {|a1,a2| a2[1]<=>a1[1]}.each do |count|
    candidates = []
    match = nil
    pers = Person.find_by_preferred_name(count[0].strip) rescue byebug
    if !pers.nil?
      match = pers.preferred_name
    end
    if count[0].include?(",")
      surname = count[0].split(",")[0]
      candidates = Person.where("preferred_name LIKE (?)", "#{surname}%").pluck(:preferred_name).sort
    end
    csv << [count[0], match, count[1], candidates.join(" | ")]
  end
end

