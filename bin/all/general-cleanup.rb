#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

#lowercase
items = [
 "Paint",
 "Primary",
 "Primary Category",
 "Primary Term",
 "Primary Terms",
 "Specific Variant",
 "Spelling Variant",
 "Spelling Variation",
 "Subtype",
 "Subtype (Contextual:Horse-Derived Haircloth)",
 "Subtype Synonym",
 "Subtype, Spelling Variant",
 "Subtype, Synonym",
 "Synonym",
 "Synonym (Abbreviated Form)",
 "Synonym (Abbreviation)",
 "Synonym (Brand Name)",
# "Synonym (Contextual: British English)",
 "Synonym (Contextual: Broader Application)",
# "Synonym (Contextual: North American English)",
# "Synonym (Contextual:British Usage)",
 "Synonym (Contextual:Non-Biological Material)",
# "Synonym (Contextual:North American English)",
# "Synonym (Contextual:North American Usage)",
# "Synonym (North American/Oceania Usage)",
 "Synonym (Subtype)",
 "Synonym (Trademark)",
 "Synonym (Variety)",
 "Synonym, Spelling Variant",
# "SynonymSynonym (Contextual: North American English)",
 "Synoym",
 "Variant",
 "primary term",
 "synonym"]

items.each do |item|
  ThesaurusVariation.where(variation_type: item).update_all(variation_type: item.downcase)
end


#Duplicates removal
#dups = CatalogTitle.select("mkey, tna_type, title").group(:mkey, :tna_type, :title).having("count(mkey) > 1").size
#
#dups.each do |dup, num|
#  records = CatalogTitle.where(mkey: dup[0], tna_type: dup[1], title: dup[2])
#  records.second.destroy
#end