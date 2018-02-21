#!/usr/bin/env ruby
# encoding: utf-8
require_relative '../../environment.rb'
include Sinatra::Mimsy::Helpers

places = [
"Goose Bay",
"Esker",
"Labrador",
"Northwest Territories",
"Blanc-Sablon",
"North West Riv. (5332N, 6008W)",
"Goose Bay",
"Niger Sound",
"Ashuanipi Lake",
"Muskrat Falls",
"Lake Melville Distr.",
"Hamilton Riv.",
"Labrador West Distr.",
"Grand Falls",
"Belle Isle (5201N, 5517W)",
"Terra Nova National Park",
"Pilley's Island",
"Newfoundland",
"Mulligan Riv.",
"Salmon Bight",
"Hudson Strait",
"St. John's",
"Otter Bay",
"Humber East Distr.",
"Gros Morne National Park",
"Cartwright",
"Labrador City",
"Eagle Riv.",
"Grand Lake",
"Lake Minipi",
"Lake Melville",
"Churchill Falls",
"Cartwright-L'Anse Au Clair Distr.",
"Sandwich Bay",
"Deep Water Creek",
"Pte. Amour",
"Churchill Riv.",
"Battle Harbour",
"Forteau",
"Bonne Bay",
"Grady I.",
"L'Anse aux Meadows National Historic Site",
"St. Barbe Distr.",
"Québec",
"Domino Harbour",
"St. John I.",
"Caplin Bay",
"Sandgirt Lake",
"L'Anse-au-Loup (5131N, 5650W)",
"Saddle I.",
"Gready I.",
"Storm Cove",
"Fraser Riv. (NF)",
"Cape Harrigan",
"Grady Harbour",
"Pointe Saint-Charles",
"Île du Petit Mécatina",
"Nachvak",
"Seal Is.",
"Schefferville",
"Nachvak Fiord",
"Hebron",
"Rowsell Harbour",
"Rock I.",
"Nain",
"Newfoundland and Labrador",
"Attikamagen Lake",
"Petty Harbour",
"Indian I.",
"Red I.",
"Gannet Is.",
"Domino",
"Pointe à Maurier",
"Hope Lake",
"Cut Throat Harbour",
"Nottingham I.",
"Goose Riv.",
"Menihek Lakes",
"Sebaskachu Bay",
"Great Caribou I.",
"Square I.",
"Marble Lake",
"Knob Lake",
"Davis Inlet",
"Hopedale",
"Rigolet",
"Torngat Distr.",
"Lake Tasisuak",
"Komaktorvik Fjord",
"Near I. (NL)",
"Howells Riv.",
"Fort Chimo",
"Brick Cove",
"Cut-Throat I.",
"Snape I.",
"Saglek Fiord",
"Marie Lake",
"Cape Mugford",
"Douglas Harbour",
"Nouveau-Quebec",
"Inukjuak",
"Rodney I.",
"Port Manvers",
"Cape Chidley",
"Digges I.",
"Mackenzie",
"Minipi Lake",
"Makkovik",
"Komaktorvik Riv.",
"Joksut Inlet",
"Richmond Gulf",
"Ivujivik",
"Lake Petitsikapau",
"L'Anse-au-Diable",
"Capstan I.",
"Prince Edward Island",
"L'Anse au Clair",
"Fox Harbour",
"Capstan Cove Pt.",
"Grand Riv.",
"British North America",
"Lake Harbour",
"Cape Jones",
"Hudson Bay",
"Sandy Lake",
"Manicuagau Riv.",
"Placentia",
"Cape Charles",
"Milnikek",
"Razorback Harbour",
"Fort George",
"Île du Gros Mécatina",
"Cape Prince of Wales",
"Molliers",
"Martin Point",
"Cape Broyle",
"Terra Nova Distr.",
"Port au Port Peninsula",
"Curling",
"Avalon Peninsula",
"Corner Brook",
"Gambo",
"Lewisporte Distr.",
"Overs Is.",
"Bay of Islands",
"Humber Valley Distr.",
"Cape Anguille",
"Ferryland Distr.",
"Burgeo and La Poile Distr.",
"Piccadilly",
"Twillingate and Fogo Distr.",
"Carbonear",
"Harbour Main-Whitbourne Distr.",
"St. George's-Stephenville East Distr.",
"Whitbourne",
"Brigus Junction",
"Twillingate",
"Grand Bank Distr.",
"Trinity-Bay de Verde Distr.",
"Stephenville",
"Bonavista South Distr.",
"Fortune Bay-Cape La Hune Distr.",
"Nippers Hbr.",
"Trinity Bay",
"Saint-Pierre-et-Miquelon",
"Conception Bay South Distr.",
"Port au Port",
"Norris Point",
"Exploits Distr.",
"Bay of Islands Distr.",
"Deer Lake",
"Channel-Port aux Basques",
"Notre Dame Bay",
"Norris Arm",
"Port Saunders",
"Port au Choix",
"Stephenville Crossing",
"South Branch (NF)",
"Gander Distr.",
"Englee",
"St. John",
"Cow Head",
"Cook's Hbr.",
"Nicholsville",
"Burgeo",
"The Straits and White Bay Distr.",
"Quirpon",
"Humber West Distr.",
"Black Duck",
"Green Bay Distr. (NF)",
"Bishop's Falls",
"St. John's Distr.",
"Flower's Cove",
"St. Barbe",
"Burin-Placentia West Distr.",
"Main Brook",
"Cormack",
"Baccalieu I.",
"Fogo I.",
"Funk Island",
"Birchy Cove",
"St. Andrews",
"Trinity North Distr. (NF)",
"Pointe Riche",
"Gander",
"Table Mountain",
"Kitty's Brook",
"Lomond",
"St. George's",
"Eddies Cove West",
"Bonavista Bay",
"Renews",
"Placentia and St. Mary's Distr.",
"Bellevue Distr.",
"Ferryland",
"Placentia Bay",
"Bonavista North Distr.",
"St. Anthony",
"Badger",
"Green Bay",
"Cape Ray",
"Pushthrough",
"Gaultois",
"Cape St. Francis Distr.",
"Henley Harbour",
"Holyrood",
"Pass I.",
"Rose Blanche",
"Patrick's Cove",
"Hampden",
"Millertown Junction",
"St. Albans",
"Spruce Brook",
"Come-by-Chance",
"Portugal Cove",
"Port au Port Distr.",
"Springdale",
"Howley",
"Mud Lake",
"Gander Lake",
"Table Mountain (Port au Port)"
]

places.each do |place|
  candidates = Place.where(name: place.strip)
  if candidates.count == 0
    puts place
  elsif candidates.count > 1
    puts place.red
  end
end