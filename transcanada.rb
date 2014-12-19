#!/usr/bin/env ruby
# ©2014 Jean-Hugues Roy. GNU GPL v3.

require "csv"
require "coordinate-converter"

fichierAvant = "TransCanadaQC-UTM.csv"
fichierApres = "TransCanadaQC-LatLong.csv"

transcanada = CSV.read(fichierAvant, headers:true)
tout = []

transcanada.each do |point|
	nouv = {}
	ref = "WGS-84"
	easting = point[2][point[2].index("E ")+2..point[2].index("\nN ")-2].gsub(",",".").to_f
	northing = point[2][point[2].index("\nN ")+3..-1].gsub(",",".").to_f
	zone = point[2][0..2]
	coord = Coordinates.utm_to_lat_long(ref,northing,easting,zone)
	lat = coord[:lat]
	long = coord[:long]
	puts coord, lat, long, easting, northing, zone
	puts "="*50
	nouv["Nom"] = point[0]
	nouv["Description"] = point[1].gsub("\n","")
	nouv["UTM"] = point[2]
	nouv["Zone"] = zone
	nouv["Easting"] = easting
	nouv["Northing"] = northing
	nouv["Latitude"] = lat
	nouv["Longitude"] = long
	tout.push nouv
end

puts tout

CSV.open(fichierApres, "wb") do |csv|
  csv << tout.first.keys
  tout.each do |hash|
    csv << hash.values
  end
end
