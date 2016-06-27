#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

duplicates = Taxon.group(:scientific_name).having("count(speckey) > 1").pluck(:scientific_name)

Parallel.map(duplicates.in_groups_of(50, false), progress: "DuplicateTaxa", in_processes: 8) do |group|
  CSV.open(output_dir(__FILE__) + "/duplicate-scientific.csv", 'a') do |csv|
    group.each do |name|
      next if name.downcase.include?("xx")
      dups = Taxon.where(scientific_name: name)
      next if dups.map(&:parent_id).uniq.size > 1
      next if dups.map(&:leaf?).include?(false)
      next if dups.map(&:male_single_parent).join.downcase.include?("xx")
      next if dups.map(&:male_single_parent).uniq.size > 1
      dups.each do |dup|
        ancestors = dup.ancestors.map(&:scientific_name).reverse.join(" | ")
        csv << [dup.speckey,
                dup.parent_id,
                dup.scientific_name,
                dup.collection,
                dup.rank,
                ancestors,
                dup.catalogs.size]
      end
    end
  end
end