#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/Lesage3-Aug 302017_people.txt"

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

  person = Person.find_by_preferred_name(row["PEOPLE.PREFERRED_NAME"])

  if !person
    puts row["PEOPLE.PREFERRED_NAME"]
    person = Person.new
    person.preferred_name = row["PEOPLE.PREFERRED_NAME"]
    person.sort_name = row["PEOPLE.SORT_NAME"]
    person.first_name = row["PEOPLE.FIRSTMID_NAME"]
    person.last_name = row["PEOPLE.LASTSUFF_NAME"]
    person.individual = row["PEOPLE.INDIVIDUAL"]
    person.save
  end

end