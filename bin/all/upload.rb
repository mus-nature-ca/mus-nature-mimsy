#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

options = {}

separator = "\t"
encoding = "utf-8"

optparse = OptionParser.new do |opts|
  opts.banner = "Usage: upload.rb [options]"

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end

  opts.on("-s", "--separator [separator]", String, "Separator used in the file, default is ','") do |sep|
    separator = sep
  end

  opts.on("-e", "--encoding [encoding]", String, "Character encoding, default is utf-8") do |enc|
    encoding = enc
  end

  opts.on("-f", "--file [file]", String, "File path to csv with header row") do |file|
    options[:file] = file
  end
  
end

begin
  optparse.parse!
  if options[:file]
    raise "File not found" unless File.exists?(options[:file])
    csv_options = { :col_sep => separator, 
                    :quote_char => '"',
                    :headers => :first_row, 
                    :return_headers => false, 
                    :header_converters => :symbol, 
                    :converters => :all,
                    :encoding => encoding}
    CSV.foreach(options[:file], csv_options) do |row|
#      row[:publish] = true
#      site = Site.create(row.to_h)
      puts site.id
    end
  end
  
rescue
  puts $!.to_s
  puts optparse
  exit 
end