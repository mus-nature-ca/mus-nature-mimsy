#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

sites = [
"xxCMNPA 1993-0061",
"xxCMNPA 1993-0062",
"xxCMNPA 1993-0063",
"xxCMNPA 1993-0064",
"xxCMNPA 1993-0065",
"CMNPA 1989-0648",
"CMNPA 1989-0487",
"CMNPA 1989-0418",
"CMNPA 1985-0120",
"CMNPA 1985-0115B",
"CMNPA 1985-0116",
"CMNPA 1985-0117",
"CMNPA 1985-0118",
"CMNPA 1985-0119",
"CMNPA 1984-7892",
"xxCMNC 1988-0293",
"xxWES 1932-08 Wainwright",
"xxHBH 1957-07-16",
"xxHBH 1957-07-16 Bay of Quinte",
"xxCMNML 014642",
"xxCMNML 014817",
"xxHBH 1961-06-06 P 1902",
"xxHBH&WHH 1960-06-09_P-1861",
"xxCMNML 039794",
"xxCMNML 019451",
"xxCMNML 019511",
"xxCMNML 031708",
"xxAHC 1961-08-10 c270",
"xxAHC 1961-08-01 C258",
"xxAHC 1961-08-01 c-253",
"xxCMNML 019659",
"xxCMNML 022648",
"xxCMNML 029122",
"xxCMNML 032119",
"xxCMNML 040429",
"xxCMNML 038065",
"xxCMNML 038068",
"xxCMNML 045155",
"xxCMNML 039478",
"xxCMNML 040113",
"xxCMNML 045119",
"xxCMNML 045605",
"xxCMNML 047245",
"xxGBM 1960-07-23 M19B",
"xxCMNML 068977",
"xxCMNML 069058",
"xxCMNML 070349",
"xxCMNML 074477",
"xxWS Oromocto Lake",
"xxWS Oromocto L.",
"xxJM 1978-06-04 Invert 30",
"xxCMNML 085530",
"xxJM 1978-06-23 Invert 75",
"xxCMNML 090710",
"xxCMNML 090721",
"xxFWG 1971-09-23 09317",
"xxLL 1989-09-16 092869",
"xxCMNML 093730",
"xx580745"
]

links = []

sites.each do |id|
  site = Site.find_by_site_id(id)
  if site.catalogs.count > 1
    links << id
  else
    site.destroy
  end
end

byebug
puts ""
