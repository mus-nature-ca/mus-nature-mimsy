#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

file = "/Users/dshorthouse/Desktop/2018-02-ix.txt"

def locator_mac(path)
  path.gsub(/\\+/, '/').sub("M:","/Volumes/dept")
end

def dest_path(row, type)
  dest_prefix = "/Volumes/dept/BotanySpecimenImages/BotanyTempLocation/Arctic Digitization"
  "#{dest_prefix}/!#{type}/Vascular/#{row["Scientific name"]}/#{row["Province/Territory (ex. NU)"]}"
end

def copy_file(file)
  source_file = File.join(file[:source_path], file[:file])
  destination_file = File.join(file[:destination_path], file[:file])

  FileUtils::mkdir_p(file[:destination_path]) if !File.directory?(file[:destination_path])

  if !File.exists?(source_file)
    puts "#{file[:file]} does not exist".red
  elsif File.exists?(destination_file)
    puts "#{file[:file]} already exists".yellow
  else
    FileUtils::cp(source_file, destination_file)
    puts file[:file].green
  end

end

start = Time.now

CSV.foreach(file, :headers => true, :col_sep => "\t", :encoding => 'bom|utf-16le:utf-8') do |row|

  jpg = {
    file: row["JPG file name (CAN#.jpg)"],
    source_path: locator_mac(row["JPG source path"]),
    destination_path: dest_path(row, "MXG")
  }

  archive = {
    file: row["Archive file name"],
    source_path: locator_mac(row["Archive source path"]),
    destination_path: dest_path(row, "Archive")
  }

  tif = {
    file: row["Tiff file name"],
    source_path: locator_mac(row["Tiff source path"]),
    destination_path: dest_path(row, "TIF")
  }

  [jpg, archive, tif].each{ |f| copy_file(f) }

end

puts Time.now - start