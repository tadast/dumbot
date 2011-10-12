require 'scamp'
require 'yuno'
require 'net/http'
require 'json'

scamp = Scamp.new(:api_key => "YOUR API KEY", :subdomain => "your subdomain", :verbose => true)

def yuno
  @yuno ||= Yuno.new(:yuno)
end

scamp.behaviour do
  # matches Jenkins notifier success message https://github.com/thickpaddy/jenkins_campfire_plugin
  match /(.)*SUCCESS(.)*/ do
    say "http://ragefac.es/faces/7c5b930e2a57df597acf02f4bea0e252.png"
    play "yeah"
  end

  # matches Jenkins notifier failure message https://github.com/thickpaddy/jenkins_campfire_plugin
  match /(.)*FAILURE(.)*/ do
    say "http://ragefac.es/faces/b6e647d23bf1c62c0cd8f7fe98a42823.png"
    play "drama"
  end

  match /^Y U NO(?<action>.+)$/ do
    if action
      link = yuno.generate "Y U NO", action
      say link
    end
  end

  match "LOL" do
    say "http://ragefac.es/faces/6bba77c8b9326aef8230886e16d66b0e.png"
  end

  match "tea break?" do
    say "http://ragefac.es/faces/fb903729364ffe73f7f693d529d58b14.png"
    say "I don't see why not, gentlemen"
  end

  match "not bad" do
    say "http://ragefac.es/faces/f4c6f874966279c091de3056ac0f1a33.png"
  end

  match "facepalm" do
    say "http://knowyourmeme.com/system/icons/554/original/facepalm.jpg"
  end

  match /^[f]+[u]+$/ do
    say "http://ragefac.es/faces/medium_b801183d49d9a7a5491df449d78bceb3.png"
  end

  # useful stuff

  match /^geminfo (?<gemname>.+)/ do
    say "hang on, looking for #{gemname} info..."
    begin
      response = Net::HTTP.get(URI.parse("http://rubygems.org/api/v1/versions/#{gemname}.json"))
      gem_info = JSON.parse(response).to_a
      recent = gem_info.first
      say "The most recent version is #{recent['number']}, released #{recent['built_at']}. Gem summary: #{recent['summary']}"
      say "gem '#{gemname}', '~> #{recent['number']}'"
    rescue
      say "Oh crap, some error. Try http://rubygems.org/search?query=#{gemname}"
    end
  end

  match /^last (?<someone>.+)'s tweet/ do
    begin
      response = Net::HTTP.get(URI.parse("http://api.twitter.com/1/users/show.json?screen_name=#{someone}"))
      json = JSON.parse(response)
      say "http://twitter.com/#!/#{someone}/status/#{json['status']['id_str']}"
    rescue
      say "pfffch pfffch"
    end
  end

  match /^weather!$/ do
    begin
      response = Net::HTTP.get(URI.parse("http://weather.yahooapis.com/forecastjson?w=44418&u=c")) #London
      json = JSON.parse(response)
      say "Now #{json["condition"]["temperature"]} C, #{json["condition"]["text"]}. Wind #{json["wind"]["speed"]}km/h #{json["wind"]["direction"]}"
      tomorrow = json["forecast"].find{|x| x["day"] = "Tomorrow"}
      say "Tomorrow #{tomorrow["condition"]}, temperature #{tomorrow["low_temperature"]} - #{tomorrow["high_temperature"]} C"
    rescue
      say "no weather :("
    end
  end
end

# Connect and join some rooms
scamp.connect!(["your room name"])