#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

group = Group.find_by_name("Annotation updates bounced")

catalog_numbers = [
"CAN 594185",
"CAN 436147",
"CAN 535470",
"CAN 261210",
"CAN 479608",
"CAN 220688",
"CAN 12100",
"CAN 394365",
"CAN 507801",
"CAN 507793",
"CAN 507794",
"CAN 583341",
"CAN 368146",
"CAN 504537",
"CAN 527841",
"CAN 203023",
"CAN 12669",
"CAN 12533",
"CAN 12655",
"CAN 123535",
"CAN 12634",
"CAN 12561",
"CAN 479734",
"CAN 12562",
"CAN 268469",
"CAN 12662",
"CAN 591375",
"CAN 589898",
"CAN 12196",
"CAN 12199",
"CAN 12197",
"CAN 12198",
"CAN 12203",
"CAN 12204",
"CAN 12205",
"CAN 279169",
"CAN 12191",
"CAN 12202",
"CAN 12200",
"CAN 12201",
"CAN 483496",
"CAN 283996",
"CAN 397507",
"CAN 583343",
"CAN 583364",
"CAN 519554",
"CAN 584854",
"CAN 13021",
"CAN 394206",
"CAN 591688",
"CAN 12412",
"CAN 393722",
"CAN 127567",
"CAN 385452",
"CAN 502479",
"CAN 73460",
"CAN 287977",
"CAN 550670",
"CAN 73461",
"CAN 73455",
"CAN 73456",
"CAN 73458",
"CAN 73459",
"CAN 73463",
"CAN 474247",
"CAN 279426",
"CAN 399207",
"CAN 586824",
"CAN 302008",
"CAN 73007",
"CAN 72596"
]

catalog_numbers.each do |n|
  catalog = Catalog.find_by_catalog_number(n)
  if catalog.nil?
    catalog = CatalogOtherNumber.find_by_other_number(n).catalog rescue nil
  end
  if catalog.nil?
    puts n
  else
    gm = GroupMember.new
    gm.table_key = catalog.mkey
    gm.group_id = group.id
    gm.save
  end
end

