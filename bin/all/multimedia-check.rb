#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

files = []

Dir.glob('/Volumes/dept/MIMSY/MMImage/**/*') do |item|
  next if !File.file?(item) || File.extname(item) == ".db" || File.extname(item) == ".lnk"
  files << { media_id: File.basename(item).downcase, file_name: File.basename(item), path: item }
end

missing = (files.map{|f| f[:media_id]} - Medium.pluck(:media_id).map(&:downcase))

=begin
files.each do |f|
  if missing.include?(f[:media_id])
    m = Medium.new
    m.media_id = f[:file_name]
    m.locator = "\\" + File.dirname(f[:path]).sub("\/Volumes\/","/n-nas1.mus-nature.ca/").gsub(/\/+/, '\\') + "\\"
    m.format = File.extname(f[:path]).upcase.sub(".","")
    if [".doc", ".docx", ".pdf", ".xls", ".xlsx", ".txt"].include?(File.extname(f[:path]).downcase)
      m.record_type = "DOCUMENT"
    elsif [".bmp", ".jpg", ".tif", ".png"].include?(File.extname(f[:path]).downcase)
      m.record_type = "IMAGE"
      m.thumbnail = true
      m.media_type = "digital"
      m.media = "digital image"
    elsif [".avi", ".mov", ".obj", ".psi"].include?(File.extname(f[:path]).downcase)
      m.record_type = "MOVIE"
    end
    m.save
  end
end
=end

=begin
missing = []

pbar = ProgressBar.create(title: "Media", total: Medium.count, autofinish: false, format: '%t %b>> %i| %e')

Medium.find_each do |item|
  pbar.increment
  path = item.locator.gsub(/\\+/, '/').sub("n-nas1.mus-nature.ca","Volumes")
  if !File.exists?(File.join(path, item.media_id))
    missing << item.media_id
  end
end
pbar.finish
=end