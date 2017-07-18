#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

#access_acq = []
#file = "/Users/dshorthouse/Desktop/access_acquisitions.csv"
#CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|
#  access_acq << row["acquisition_id"]
#end

#an = []
#access_acq.in_groups_of(1000) do |group|
#  an.concat Catalog.where.not(acquisition_number: nil).where.not(acquisition_number: group).pluck(:id)
#end

an = Catalog.where.not(acquisition_number: nil).pluck(:id)
acq = AcquisitionCatalog.pluck(:catalog_id)
ids = an - acq

acqs = []
ids.in_groups_of(1000) do |group|
  acqs.concat Catalog.where(id: group).pluck(:acquisition_number)
end

acqs.uniq.each do |acq|
  if /^A[0-9]{4}\.[0-9]{4}$/.match(acq)
    catalogs = Catalog.where(acquisition_number: acq)
    acquisition = Acquisition.find_by_acquisition_number(acq)
    catalogs.each do |catalog|
      if acquisition && !AcquisitionCatalog.where(catalog_id: catalog.id).where(acquisition_id: acquisition.id).exists?
        puts catalog.catalog_number
        acq_new = AcquisitionCatalog.new
        acq_new.catalog_id = catalog.id
        acq_new.acquisition_id = acquisition.id
        acq_new.id_number = catalog.catalog_number
        acq_new.save
      end
    end
  end
end

