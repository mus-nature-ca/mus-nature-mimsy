#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers


type_statuses = {
"? isotype" => "isotype?",
"ISOTYPE" => "isotype",
"ISOTYPE; associated species" => "isotype; associated species",
"ISOTYPE?" => "isotype?",
"LECTOTYPE" => "lectotype",
"LECTOTYPE?" => "lectotype?",
"NEOPARATYPE" => "neoparatype",
"NEOTYPE" => "neotype",
"Neohapantotype" => "neohapantotype",
"PARAHAPANTOTYPE" => "parahapanotype",
"PARALECTO-TYPES" => "paralectotype",
"PARALECTOTYPE" => "paralectotype",
"PARALECTOTYPE ?" => "paralectotype?",
"PARATOPOTYPE" => "paratopotype",
"PARATYPE" => "paratype",
"PARATYPE (MS, unpublished)" => "paratype (ms, unpublished)",
"PARATYPE (UNFIGURED)" => "paratype (unfigured)",
"PARATYPE Eggs" => "paratype eggs",
"PARATYPE of F.c. torridus" => "paratype of F.c. torridus",
"PARATYPE/TOPOTYPE" => "paratype/topotype",
"PARATYPE; HOLOTYPE" => "paratype; holotype",
"PARATYPE?" => "paratype?",
"PARATYPE? (MS, unpublished)" => "paratype? (ms, unpublished)",
"PARATYPES" => "paratype",
"PHOTOTYPE" => "phototype",
"PLASTER TYPE" => "plaster type",
"PLESIOTYPE" => "plesiotype",
"Parasite" => "parasite",
"Paratype" => "paratype",
"Paratype?" => "paratype?",
"Paratypes" => "paratype",
"Plesiotype" => "plesiotype",
"SPERMATOTYPE" => "spermatotype",
"SYNTYPE" => "syntype",
"SYNTYPE (doubtful)" => "syntype (doubtful)",
"SYNTYPE ?" => "syntype?",
"SYNTYPE?" => "syntype?",
"TOPOTYPE" => "topotype",
"TOPOTYPES" => "topotype",
"TYPE" => "type",
"TYPE ?" => "type?",
"TYPE COLLECTION" => "type collection",
"TYPE SERIES" => "type series",
"TYPE?" => "type?",
"TYPES" => "type",
"Topotype" => "topotype",
"Topotypes" => "topotype",
"Type" => "type",
"Type locality" => "type locality",
"Type?" => "type?",
"holotype ?" => "holotype?",
"vouchers" => "voucher"
}

type_statuses.each do |key,value|
  CatalogTaxon.where(affiliation: key).update_all(affiliation: value)
end