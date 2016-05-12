#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

hash = {
 " type name" => "type name",
 "(mispelled?) previous name" => "(misspelling?) previous name",
 "Figured name" => "figured name",
 "HOLOTYPE" => "holotype",
 "HOLOTYPE; previous  name" => "holotype; previous name",
 "HOLOTYPE; previous name" => "holotype; previous name",
 "Incorrectly assigned name" => "incorrectly assigned name",
 "Object type" => "object type",
 "Old Identification" => "old identification",
 "Old identification" => "old identification",
 "Previous ID" => "previous identification",
 "Previous identification" => "previous identification",
 "Previous name" => "previous name",
 "Previous scientific name" => "previous scientific name",
 "SYNTYPE; previous name" => "syntype; previous name",
 "Scientific name" => "scientific name",
 "Synonym" => "synonym",
 "Type; previous name" => "type; previous name",
 "Typo error" => "typo error",
 "identification conformation" => "identification confirmation",
 "incorrect spelling" => "misspelling",
 "item nam; identification confirmation" => "item name; identification confirmation",
 "item nam; taxonomic update without examination" => "item name; taxonomic update without examination",
 "item name associated species" => "item name; associated species",
 "item name; item name" => "item name",
 "mispelling?" => "misspelling?",
 "most recent attributio; original identification" => "most recent attribution; original identification",
 "original identification; associates species" => "original identification; associated species",
 "original identification; synonyms" => "original identification; synonym",
 "original identification; syonym" => "original identification; synonym",
 "original speilling" => "original spelling",
 "previous name; associated species." => "previous name; associated species",
 "previous names" => "previous name"
}
 
hash.each do |key,value|
  CatalogName.where(type: key).update_all(tna_type: value)
end

