#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'

sql = "SELECT * FROM (
SELECT 
    c.uuid AS 'occurrenceID', 
    c.item_name || ' (' || c.id_number || ')' AS 'bibliographicCitation', 
    c.id_number AS 'catalogNumber', 
    c.id_prefix AS 'collectionCode', 
    'country', 
    'county', 
    c.category1 AS 'datasetName', 
    CASE WHEN jt.taxonomy = c.item_name THEN jt.attrib_date ELSE NULL END AS 'dateIdentified',
    s.start_latitude_dec AS 'decimalLatitude', 
    s.start_longitude_dec AS 'decimalLongitude', 
    c.date_collected AS 'eventDate', 
    s.geodetic_datum AS 'geodeticDatum', 
    CASE WHEN jt.taxonomy = c.item_name THEN t.male_single_parent ELSE NULL END AS 'higherClassification', 
    CASE WHEN jt.taxonomy = c.item_name THEN jt.attributor ELSE NULL END AS 'identifiedBy',
    c.item_count AS 'individualCount', 
    c.language AS 'language', 
    s.description AS 'locality', 
    s.site_id AS 'locationID', 
    s.recommendations AS 'locationRemarks', 
    c.update_date AS 'modified', 
    'municipality', 
    c.description AS 'occurrenceRemarks', 
    c.materials AS 'preparations', 
    c.collector AS 'recordedBy', 
    'recordNumber', 
    c.item_name AS 'scientificName', 
    CASE WHEN jt.taxonomy = c.item_name THEN t.source ELSE NULL END AS 'scientificNameAuthorship', 
    c.sex AS 'sex', 
    'stateProvince', 
    CASE WHEN jt.taxonomy = c.item_name THEN t.level_text ELSE NULL END AS 'taxonRank', 
    CASE WHEN jt.taxonomy = c.item_name THEN jt.affiliation ELSE NULL END AS 'typeStatus', 
    s.elevation AS 'verbatimElevation', 
    c.date_collected AS 'verbatimEventDate', 
    s.start_latitude AS 'verbatimLatitude', 
    s.start_longitude AS 'verbatimLongitude', 
    ROW_NUMBER() OVER (PARTITION BY c.uuid ORDER BY (CASE WHEN jt.taxonomy = c.item_name THEN 1 ELSE 0 END) DESC) AS 'ROW_ID' 
FROM 
    CATALOGUE c 
INNER JOIN 
    ITEMS_TAXONOMY jt ON (jt.mkey = c.mkey) 
INNER JOIN 
    TAXONOMY t ON (t.speckey = jt.speckey) 
LEFT JOIN 
    (SELECT mkey, LISTAGG(other_number,'|') WITHIN GROUP (ORDER BY other_number) AS 'recordNumber' FROM OTHER_NUMBERS WHERE on_type = 'collector no./field no.' GROUP BY mkey) o ON (o.mkey = c.mkey) 
LEFT JOIN 
    (SELECT js.mkey, x.site_id, x.start_latitude, x.start_longitude, x.start_latitude_dec, x.start_longitude_dec, x.geodetic_datum, x.description, x.elevation, x.recommendations, x.publish FROM SITES x INNER JOIN ITEMS_SITES js ON (js.skey = x.skey) WHERE x.publish = 'Y') s ON (s.mkey = c.mkey) 
LEFT JOIN 
    (SELECT mkey, 'country', 'stateProvince', 'county', 'municipality' FROM (SELECT a.place1, a.hierarchy_level, b.mkey FROM (SELECT c.placekey, c.place1, c.hierarchy_level, CONNECT_BY_ROOT c.placekey AS root_placekey FROM PLACES c CONNECT BY NOCYCLE c.placekey = PRIOR c.broader_key) a INNER JOIN ITEMS_PLACES_COLLECTED b ON (a.root_placekey = b.placekey) WHERE b.prior_attribution <> 'Y') PIVOT (LISTAGG(place1, '') WITHIN GROUP (ORDER BY place1 DESC) FOR hierarchy_level IN (3 as 'country', 5 as 'stateProvince', 7 AS 'county', 12 AS 'municipality'))) d ON (d.mkey = c.mkey) 
WHERE c.publish = 'Y' AND c.id_prefix IN ('CAN', 'CANA', 'CANM', 'CANL')
) WHERE ROW_ID = 1"

results = ActiveRecord::Base.connection.execute(sql)

log = "/Users/dshorthouse/Desktop/botany_ipt.csv"

CSV.open(log, 'w') do |csv|
  results.find_each do |r|
    puts r.id
    csv << r.to_a
  end
end
