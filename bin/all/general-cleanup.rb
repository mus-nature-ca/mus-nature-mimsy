#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

#lowercase
items = [
  "Assistant & discoverer",
	"(has complete specimen)",
	"Asessor, Collector",
	"Assesor, Excavator",
	"Assessor",
	"Assessor, Collectior",
	"Assessor, Collector",
	"Assessor, Collector,  Excavator",
	"Assessor, Collector, Excavator",
	"Assessor, Excavator, Collector",
	"Assistant",
	"Asssitant",
	"Co-collector?",
	"Collector",
	"Collector (discovered 1924-2)",
	"Collector (with field party)",
	"Collector and claim holder",
	"Collector and discoverer of site",
	"Collector and vendor",
	"Collector, Excavator",
	"Collector, claim holder?",
	"Collector?",
	"Cook",
	"Correspondence",
	"Discovered specimen 8879",
	"Discovered specimen 8882",
	"Discoverer",
	"Discoverer and assistant",
	"Discoverer and teamster",
	"Donator",
	"Employer of above",
	"Exchange",
	"Expedition leader",
	"Expedition member",
	"Expedition sponsor",
	"Identified specimen",
	"Identified specimens",
	"Identifier",
	"Identifier of specimens",
	"Investigator",
	"Investigator, Collector",
	"Miner",
	"Miner/Collector",
	"Miner/collector",
	"Miner?",
	"Owner of property",
	"Permit Holder",
	"Permiting Authority",
	"Permitting Authority",
	"Placer Miner/Collector",
	"Placer mine miner",
	"Placer miner/collector",
	"Presenter",
	"Previous owner",
	"Purchased material",
	"Purchased specimen",
	"Purchaser",
	"Purchaser of specimens",
	"Recipient",
	"Retained counterpart of specimen",
	"Specimen received via",
	"Vendor of specimen"
]
items.each do |item|
  SitePerson.where(relationship: item).update_all(relationship: item.downcase)
end


#Duplicates removal
#dups = CatalogTitle.select("mkey, tna_type, title").group(:mkey, :tna_type, :title).having("count(mkey) > 1").size
#
#dups.each do |dup, num|
#  records = CatalogTitle.where(mkey: dup[0], tna_type: dup[1], title: dup[2])
#  records.second.destroy
#end
