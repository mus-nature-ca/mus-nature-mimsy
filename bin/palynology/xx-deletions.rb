#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

collection = "Palynology"
xxtaxa = Taxon.search_by_prefix('xx')

pbar = ProgressBar.new("XX-NAMES", xxtaxa.count)
count = 0

candidate_deletions = Set.new

CSV.open(output_dir(__FILE__) + "/xx-obj-deletions.csv", 'w') do |csv|
  csv << ["ID Number", "xx speckey", "xx Scientific Name"]
  xxtaxa.each do |xxtaxon|
    similar = Taxon.find_by_scientific_name(xxtaxon.scientific_name[2..-1])
    if similar
      valid_speckey = similar.speckey
      xxtaxon.catalogs.each do |catalog|
        if catalog.collection == collection
          ct = CatalogTaxon.where(speckey: valid_speckey, mkey: catalog.mkey).first
          xxct = CatalogTaxon.where(speckey: xxtaxon.speckey, mkey: catalog.mkey).first

          if ct && xxct
            if ct.attributor.nil? && xxct.attributor
              ct.attributor = xxct.attributor
            end
            if ct.attrib_date.nil? && xxct.attrib_date
              ct.attrib_date = xxct.attrib_date
            end
            ct.save if ct.changed?
            xxct.delete
            csv << [catalog.id_number, xxtaxon.speckey, xxtaxon.scientific_name]
            candidate_deletions << xxtaxon.speckey
          end

        end
      end
    end
    count += 1
    pbar.set(count)
  end
end
pbar.finish

CSV.open(output_dir(__FILE__) + "/xx-taxa-deletions.csv", 'w') do |csv|
  csv << ["speckey", "Scientific Name", "Parent", "Level Name", "Author/Date"]
  candidate_deletions.each do |candidate|
    xxtaxon = Taxon.find(candidate)
    if xxtaxon.leaf? && xxtaxon.catalogs.empty?
      csv << [xxtaxon.speckey, xxtaxon.scientific_name, xxtaxon.broader_key1, xxtaxon.level_text, xxtaxon.source]
      xxtaxon.destroy
    end
  end
end