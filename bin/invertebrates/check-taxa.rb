#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

taxa = [
"Hyperphyscia adglutinata",
"Myriolecis hagenii",
"Phaeocalicium curtisii",
"Lecanora pulicaris",
"Physcia adscendens",
"Physcia aipolia",
"Physcia stellaris",
"Physciella chloantha",
"Catillaria nigroclavata",
"Scoliciosporum chlorococcum",
"Xanthoparmelia plittii",
"Lecanora allophana f. sorediata",
"Bacidia rubella",
"Melanelixia subargentifera",
"Physconia enteroxantha",
"Caloplaca cerina",
"Caloplaca pyracea",
"Protoparmeliopsis muralis",
"Lecanora hybocarpa",
"Lecanora symmicta",
"Physciella melanchra",
"Flavopunctelia flaventior",
"Cladonia cristatella",
"Cladonia scabriuscula",
"Acarospora moenium",
"Sarcogyne regularis",
"Caloplaca feracissima",
"Lecidella stigmatea",
"Xanthomendoza fallax",
"Illosporiopsis christiansenii",
"Physcia millegrana",
"Acarospora fuscata",
"Rhizocarpon obscuratum",
"Trapelia placodioides",
"Graphis scripta",
"Arthonia helvola",
"Lecanora thysanophora",
"Bilimbia sabuletorum",
"Lecania croatica",
"Xanthoparmelia cumberlandia",
"Julella fallaciosa",
"Alyxoria varia",
"Phaeophyscia pusilloides",
"Phaeophyscia rubropulchra",
"Clypeococcum hypocenomycis",
"Hypocenomyce scalaris",
"Hypogymnia physodes",
"Evernia mesomorpha",
"Melanelixia subaurifera",
"Cladonia ochrochlora",
"Cladonia digitata",
"Cladonia incrassata",
"Flavoparmelia caperata"
]

CSV.open("/Users/dshorthouse/Desktop/taxa.csv", 'w') do |csv|
  taxa.each do |taxon|
    tax = Taxon.find_by_scientific_name(taxon.strip)
    #Find a variant if verbatim not found
    if tax.nil?
      tax = TaxonVariation.find_by_scientific_name(taxon.strip).taxon rescue nil
    end
    if tax.nil?
      csv << [taxon, "missing"]
    else
      csv << [taxon, "present"]
    end
  end
end