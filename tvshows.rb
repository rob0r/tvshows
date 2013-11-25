#!/usr/bin/env ruby
# ruby script to display TV shows
# fetches information from tv.heapslol.com in XML format and displays in term
# author: Rob Orford
# date  : 9/Nov/2013

begin
  require 'HTTParty'
rescue LoadError
  puts "Failed to load HTTParty, run: gem install httparty"
  exit
end

# url's to grab data from
url_for_today     = "http://today.tv.heapslol.com/?xml"
url_for_tomorrow  = "http://tomorrow.tv.heapslol.com/?xml"
url_for_week      = "http://next.seven.days.tv.heapslol.com/?xml"

case ARGV[0]
when "today" then url = url_for_today; puts "Todays Shows"; puts "-" * 15 + "\n"
when "tomorrow" then url = url_for_tomorrow; puts "Tomorrows Shows"; puts "-" * 15 + "\n"
when "week" then url = url_for_week ; puts "This Weeks Shows"; puts "-" * 15 + "\n"
when "--help", "-h" then puts "Run ./tvshows.rb [today(default)|tomorrow|week]"; exit
else url = url_for_today; puts "Todays Shows"; puts "-" * 15 + "\n"
end

# header to use
header = {"User-Agent" => "Ruby_TVScript"}

# fetch the data
tvdata = HTTParty.get(url, :headers => header)

tvdata["tvdata"]["episodes"]["entry"].each do |ep|
  # formatting cleanup
  # seasons and episodes < 10 get padded with a 0
  # e.g S03E05 rather than S3E5
  case
  when ep["season"].to_i < 10 then ep["season"] = 'S0' + ep["season"]
  else ep["season"] = 'S' + ep["season"]
  end

  case
  when ep["episode"].to_i < 10 then ep["episode"] = 'E0' + ep["episode"]
  else ep["episode"] = 'E' + ep["episode"]
  end

  # display in console
  puts ep["show_name"] + ' ' + ep["season"] + ep["episode"]
end