#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

taxon_names = CatalogName.joins(:catalog)
  .where("catalogue.category1 = 'Vascular Plant' OR catalogue.category1 = 'Bryophyte' OR catalogue.category1 = 'Lichen'")
  .where.not(attrib_type: nil)

taxon_names.each do |tn|
  type = "attribution_type:"+tn.attrib_type
  if !tn.attrib_comment.nil?
    attrib_comment = [tn.attrib_comment, type].join(" | ")
  else
    attrib_comment = type
  end
#  tn.update_all({attrib_type: nil, attrib_comment: attrib_comment})
end