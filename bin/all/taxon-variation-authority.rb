#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

black_list_note = [
  "(Almquist) Fries ex V.I. Kreczetowicz\n(Almquist) Fries ex V.I. Kreczetowicz\n(Almquist) Fries ex V.I. Kreczetowicz\n(Almquist) Fries ex V.I. Kreczetowicz\n(Almquist) Fries ex V.I. Kreczetowicz\n(Almquist) Fries ex V.I. Kreczetowicz",
  "(Dicks.) Husn. - illeg. acc. TROPICOS",
  "(Hooker) Vasey nom. illeg. TROPICOS \n(Hooker) Vasey nom. illeg. TROPICOS \n(Hooker) Vasey nom. illeg.",
  "(Nees) Lindb.; illegitimate name (later homonym)",
  "(P. Beauv.) Crundw.; www.itis.gov/index.html",
  "1001991",
  "1025301",
  "1025317",
  "A European species; North American records are B. pikei",
  "Acc. North American Checklist (2012): X. hypopsila (Müll. Arg.) Hale = misidentifications for North America; most specimens are X. angustiphylla",
  "All former species of Rimelia have been put in the genus Parmotrema. See Blanco et al. 2005.",
  "Bartsch, MS, Berry, 1907 nomen nudem",
  "British Mosses and Liverworts - A Field Guide",
  "Carex peckii Howe f. elongata Lepage",
  "Carex salina G. Wahlenberg v. tristigmatica G. Kukenthal",
  "For North American reports refer to L. pseudofurfuraceum, acc. North American Lichen Checklist",
  "Initially assigned to the male of the species",
  "Invalid name proposed in Lutzoni M.Sc. thesis, 1990.",
  "MS name",
  "MS name?",
  "McDonald’s rockcress was named in honor of Captain Ja\nmes M. McDonald and was \noriginally published as \nArabis mcdonaldiana\n. The spelling of the species’ name was later \nchanged to \"\nmacdonaldiana\n\" to reflect a recommended change in international \nbotanical naming conventions (http://www.oregon.gov/oda/shared/Documents/Publications/PlantConservation/ArabisMacdonaldianaProfile.pdf)",
  "North American",
  "Not a synonym in FNA - see note below",
  "SECTION",
  "SUPERFAMILY",
  "Sarg. nom illeg.",
  "Schwaegr.; NOT SYNONYM, but Anderson et al. 1990 (Bryologist 93:448-499) excluded Mnium lycopodioides from North America, and stated that most North American material can be referred to M. ambiguum. common error in North American specimens.",
  "Stafford, 1905 misspelling",
  "Stage : Cysticercous",
  "Type name for forma glabrum.",
  "[Carex aquatilis × C. salina]",
  "[Carex aquatilis × C. stricta]",
  "alt. spelling",
  "as subclass",
  "auct non (R. Br.) Dcne.",
  "auct non R. Br.",
  "auct. [non L.]",
  "auct. non (Willd.) Britton",
  "auct. non Grisebach.",
  "auct. non Jussieu",
  "auct. non L.",
  "auct. non Michaux",
  "auct. non Schkuhr ex Willdenow",
  "auct. non Willd.",
  "auct., non Brid.",
  "e.g. Bruce Allen's \"Maine Mosses\"",
   "for North American records, acc. North  American Lichen Checklist",
   "for North American reports; Jørgensen 1997, acc. North American Lichen Checklist",
   "for Sphagnum brevifolium",
   "for all North American records",
   "illeg.",
   "illeg. name",
   "included under Stenotephanos",
   "incorrect spelling",
   "invalid",
   "invalid name",
   "invalid subgroup",
   "may be senior name",
   "misspelled",
   "misspelling",
   "misspelling of Cyprogenia popenoi",
   "nom illeg.",
   "nom. ill.",
   "nom. illeg.",
   "nomen dubium",
   "non (Mulhenberg) de Candolle",
   "non Rottbøll",
   "not a subspecies but a provisional identification",
   "not a valid name",
   "now included under Kraglievichia",
   "now included under Prodinoceras",
   "of Carus, 1885",
   "partial?",
   "section",
   "see note below",
   "sensu A. Gray, non Willd.",
   "sensu House non (Willd.) Roth",
   "sensu auctt. non Bory",
   "sensu auctt. non Desf.",
   "sensu auctt. non Willd. ex Spreng.",
   "sometimes applied to intermediates between E. angustifolium subsp. angustifolium & E. angustifolium subsp. triste (=E. triste)",
   "specimen determined as n. sp. by A.H. Brinkman",
   "subgenus",
   "superfamily",
   "table # Myers & Lowry, 2003",
   "unaccepted name",
   "variation",
   "was speckey 1148813",
   "www.itis.gov/index.html"
]

black_list_authority = %r{
  [{}\\/<>],
  (?i:Acutifolia)|
  (?i:var)\.\s+|
  (?i:fungi|subsecunda)
}x

def nested_hash_value(obj,key)
  if obj.respond_to?(:key?) && obj.key?(key)
    obj[key]
  elsif obj.respond_to?(:each)
    r = nil
    obj.find{ |*a| r = nested_hash_value(a.last,key) }
    r
  end
end

=begin
#composite families
ids = %w(
1132458
1132490
1132497
1132565
1132572
1132586
1132795
1132821
1132826
1132866
1143128
1143200
1143222
1143294
1143315
1143321
1143457
1143486
1143497
1143522
1140212
1132890
1139106
1139115
1143651
1143654
1143665
1143668
1141334
1143928
1143938
1143948
1143981
1143986
1143994
1143997
1144157
1144163
1132606
)
=end

CSV.foreach("/Users/dshorthouse/Desktop/authority_fixes.csv") do |row|
  tv = TaxonVariation.find(row[0])
  tv.authority = row[1]
  tv.attributor = nil
  tv.attrib_date = nil
  tv.save
end

=begin
parser = ScientificNameParser.new

CSV.open(output_dir(__FILE__) + "/taxon-variation-authority.csv", 'w') do |csv|
  csv << TaxonVariation.attribute_names
  TaxonVariation.where("variation like '% var. %'").where(authority: nil).find_each do |tv|
    parsed = parser.parse(tv.scientific_name) rescue {}
    details = parsed.dig(:scientificName, :details) || []
    authority = nested_hash_value(details, :authorship)
    if authority
      if authority.length == 1
        csv << tv.attributes.values
        next
      elsif authority == authority.upcase && authority !~ /[\.|\&]/
        csv << tv.attributes.values
        next
      elsif authority =~ black_list_authority
        csv << tv.attributes.values
        next
      else
        original = tv.scientific_name.dup
        tv.scientific_name.slice!(authority)
        tv.scientific_name.strip!
        if original != tv.scientific_name
          tv.authority = authority
          tv.save
        end
      end
    end
  end
end

=begin
pbar = ProgressBar.create(title: "TVs", total: TaxonVariation.count, autofinish: false, format: '%t %b>> %i| %e')

parser = ScientificNameParser.new

authorities = []
problems = []

CSV.open(output_dir(__FILE__) + "/taxon-variation-authority.csv", 'w') do |csv|
  csv << TaxonVariation.attribute_names
  TaxonVariation.where(authority: nil).find_each do |tv|
    pbar.increment
    next if tv.variation_type && tv.variation_type.downcase.match("common")
    parsed = parser.parse(tv.scientific_name) rescue {}
    details = parsed.dig(:scientificName, :details) || []
    authority = nested_hash_value(details, :authorship)
    if authority
      if authority.length == 1
        csv << tv.attributes.values
        next
      elsif authority == authority.upcase && authority !~ /[\.|\&]/
        csv << tv.attributes.values
        next
      elsif authority =~ black_list_authority
        csv << tv.attributes.values
        next
      else
        original = tv.scientific_name.dup
        tv.scientific_name.slice!(authority)
        tv.scientific_name.strip!
        if original != tv.scientific_name
          tv.authority = authority
          tv.save
        end
      end
    end
  end
end
pbar.finish

#Move note to authority when not in black_list_note
=begin
tvs = TaxonVariation.where.not(note: black_list_note).where.not(note: nil).where(attributor: nil)
tvs.find_each do |tv|
  tv.authority = tv.note
  tv.note = nil
  tv.save
end
=end