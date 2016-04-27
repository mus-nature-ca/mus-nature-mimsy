#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

dup_list = CatalogTaxon.select(:mkey, :speckey).group(:mkey,:speckey).having("count(*) > 1")
pbar = ProgressBar.new("DUPS", dup_list.length)
count = 0

CSV.open(output_dir(__FILE__) + "/duplicate-taxonomy-links.csv", 'w') do |csv|
  cols = CatalogTaxon.columns.map(&:name)
  cols.delete("authlinkkey")
  csv << cols
  dup_list.each do |duplicate|
    item_count = Catalog.find(duplicate.mkey).item_count
    if !item_count || item_count == 1
      attribute_set = Set.new
      dups = CatalogTaxon.where(mkey: duplicate.mkey, speckey: duplicate.speckey)
      authlinks = dups.pluck(:authlinkkey)
      dups.each do |dup|
        attributes = dup.attributes
        attributes.delete("authlinkkey")
        attribute_set << attributes
      end
      if attribute_set.size == 1
        authlinks.shift
        authlinks.each{ |x| CatalogTaxon.find_by_authlinkkey(x).delete }
        csv << attribute_set.first.values.to_a
      end
    end
    count += 1
    pbar.set(count)
    
  end
end
pbar.finish