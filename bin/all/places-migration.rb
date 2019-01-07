#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

LEVEL1 = %r{
  \b(?i:
  ocean
  )\b
  }x

LEVEL2 = %r{
  \b(?i:
  ocean|
  lake|
  seamount|
  sea|
  bank|
  shelf|
  strait|
  slope|
  ridge|
  basin|
  canyon
  )\b
  }x

LEVEL3 = %r{
  \b(?i:
  sea|
  strait|
  shelf|
  bay|
  ridge|
  waters|
  gulf|
  basin|
  ridge
  )\b
  }x

LEVEL4 = %r{
  \b(?i:
  bay|
  basin|
  cordillera|
  ridge|
  plain |
  sea|
  zone|
  seamount|
  gulf|
  seachannel|
  channel|
  shelf|
  canyon|
  banks?|
  rise|
  trench|
  golfo|
  firth|
  escarpment|
  strait|
  riv\.|
  lake|
  seamounts|
  mid-pacific mountains|
  rio
  )\b
  }x

LEVEL5 = %r{}x

LEVEL6 = %r{
  \b(
  riv\.|
  gulf|
  sea|
  bay|
  lakes?|
  ceara plain|
  fracture zone|
  shoal|
  channel|
  basin|
  sound|
  knoll|
  bank|
  ledge|
  flemish cap|
  the gully|
  bight|
  shoals|
  slope|
  ground|
  deep|
  bahia|
  fjord|
  firth|
  creek|
  riviere|
  rapids|
  lac|
  reservoir|
  coul(e|é)e|
  baie|
  falls|
  delta|
  arm|
  strait|
  inlet|
  passage|
  ch\.|
  hbr\.|
  fleuve|
  golfe|
  détroit|
  reefs?|
  rio
  )\b
  }x


LEVEL7 = %r{
  \b(?i:
  sound|
  riv.|
  bank|
  bay|
  reefs?|
  lake|
  inlet|
  creek|
  lac|
  ch\.
  )\b
  }x


LEVEL8 = %r{
  \b(?i:
  bay|
  bight|
  delta|
  creek|
  lake|
  riv\.|
  inlet|
  strait|
  channel|
  sound|
  bank|
  entrance|
  ch\.|
  lakes|
  creek|
  discovery passage|
  stream|
  brook|
  pond|
  hbr\.|
  cove|
  fiord|
  shoal|
  swamp
  )\b
  }x

LEVEL9 = %r{
  \b(?i:
  bay|
  riv\.|
  lake|
  creek|
  arm|
  inlet|
  reef|
  harbour|
  sound|
  cove|
  ch\.|
  channel|
  bank|
  fiord|
  marsh|
  lac|
  ruisseau|
  rivière|
  ck\.
  )\b
  }x

LEVEL10 = %r{
  \b(?i:
  bay|
  lake|
  cove|
  inlet|
  riv.|
  lac|
  brook|
  sound|
  passage|
  reef
  )\b
  }x

LEVEL11 = %r{
  \b(?i:
  bay|
  lake|
  ck\.|
  baie|
  lac|
  riv\.
  )\b
  }x

LEVEL12 = %r{
  \b(?i:
  arm|
  bahia|
  baie|
  banks?|
  basin|
  bay|
  brook|
  ch\.|
  channel|
  ck\.|
  cove|
  creek|
  falls|
  fiord|
  fjord|
  harbour|
  inlet|
  lac|
  lake|
  ocean station papa|
  passage|
  pond|
  rapids|
  reservoir|
  rio|
  riv\.|
  rivière|
  ruisseau|
  salton sea|
  strait|
  swamp|
  trough
  )\b
  }x

IGNORED_LEVEL1 = []
IGNORED_LEVEL2 = []
IGNORED_LEVEL3 = []
IGNORED_LEVEL4 = []
IGNORED_LEVEL5 = []
IGNORED_LEVEL6 = []
IGNORED_LEVEL7 = []
IGNORED_LEVEL8 = []
IGNORED_LEVEL9 = []
IGNORED_LEVEL10 = []
IGNORED_LEVEL11 = []
IGNORED_LEVEL12 = []

earth = Place.find(29202)

Place.find_each do |place|

  a1 = nil
  a2 = nil
  if [1,2,3].include? place.hierarchy_level
    a1 = place.ancestors_upto_level(3).map(&:name).join("; ")
  end
  if [4,6,7,8,9,10,11,12].include? place.hierarchy_level
    a2 = place.ancestors_upto_level(4).map(&:name).join("; ")
  end

  place.ancestors.map{|a| { level: a.hierarchy_level, name: a.name }}

  a1 = 

  case place.hierarchy_level
    when 1
      if place.name.match(LEVEL1)
        
      end
    when 2
      if place.name.match(LEVEL2)
      end
    when 3
      if place.name.match(LEVEL3)
      end
    when 4
      if place.name.match(LEVEL4)
      end
    when 5
      if place.name.match(LEVEL5)
      end
    when 6
      if place.name.match(LEVEL6)
      end
    when 7
      if place.name.match(LEVEL7)
      end
    when 8
      if place.name.match(LEVEL8)
      end
    when 9
      if place.name.match(LEVEL9)
      end
    when 10
      if place.name.match(LEVEL10)
      end
    when 11
      if place.name.match(LEVEL11)
      end
    when 12
      if place.name.match(LEVEL12)
        byebug
        puts ""
      end
  end
end
