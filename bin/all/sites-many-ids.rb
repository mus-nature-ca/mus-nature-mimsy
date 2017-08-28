#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

sites = Site.pluck(:site_name, :id).map{|v| { site_name: v[0], id: v[1] } }
skeys = sites.group_by{|h| h[:site_name]}.each{|k,v| v.replace(v.map{|h| h[:id]}) }.delete_if{|_,v| v.count == 1}
pbar = ProgressBar.create(title: "Problems", total: skeys.count, autofinish: false, format: '%t %b>> %i| %e')

CSV.open(output_dir(__FILE__) + "/sites-many-ids.csv", 'w') do |csv|
  csv << ["collections", "site_name"]
  skeys.each do |k, v|
    collections = CatalogSite.joins(:catalog).where(site_id: v).pluck(:category1).uniq.sort
    csv << [collections.uniq.join(","), k]
    pbar.increment
  end
end

pbar.finish