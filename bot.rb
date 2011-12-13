require 'scamp'
require 'yuno'
require 'net/http'
require 'json'
require 'cgi'
require './bot_config.rb'

@config = BotConfig.new
scamp = Scamp.new(:api_key => @config['api_key'], :subdomain => @config['subdomain'], :verbose => true)

def yuno
  @yuno ||= Yuno.new(:yuno)
end

scamp.behaviour do
  # match /help/ do
  #   puts "#{scamp.command_list.map(&:to_s).join("\n-")}"
  # end
  
  match /^artme (?<search>\w+)/ do
    url = "http://ajax.googleapis.com/ajax/services/search/images?rsz=large&start=0&v=1.0&q=#{CGI.escape(search)}"
    http = EventMachine::HttpRequest.new(url).get
    http.errback { say "Couldn't get #{url}: #{http.response_status.inspect}" }
    http.callback {
      if http.response_header.status == 200
        results = Yajl::Parser.parse(http.response)
        if results['responseData']['results'].size > 0
          say results['responseData']['results'][0]['url']
        else
          say "No images matched #{search}"
        end
      else
        # logger.warn "Couldn't get #{url}"
        say "Couldn't get #{url}"
      end
    }
  end
  
  match /^geminfo (?<gemname>.+)/ do
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

  match /^Y U NO(?<action>.+)$/ do
    if action
      link = yuno.generate "Y U NO", action
      say link
    end
  end

  match /^last (?<someone>.+)'s tweet/ do
    begin
      response = Net::HTTP.get(URI.parse("http://api.twitter.com/1/users/show.json?screen_name=#{someone}"))
      json = JSON.parse(response)
      say "http://twitter.com/#!/#{someone}/status/#{json['status']['id_str']}"
    rescue e
      say "Error #{e}"
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
  
  match /dumbot ip/ do
    say "#{`wget -qO- icanhazip.com`}"
  end
  
  #unuseful noisy matchers
  
  # matches Jenkins notifier success message https://github.com/thickpaddy/jenkins_campfire_plugin
  match /(.)*SUCCESS(.)*/ do
    # say "http://ragefac.es/faces/7c5b930e2a57df597acf02f4bea0e252.png"
    play "yeah"
  end

  # matches Jenkins notifier failure message https://github.com/thickpaddy/jenkins_campfire_plugin
  match /(.)*FAILURE(.)*/ do
    # say "http://ragefac.es/faces/b6e647d23bf1c62c0cd8f7fe98a42823.png"
    play "drama"
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
    links = [
      "http://ragefac.es/faces/medium_b801183d49d9a7a5491df449d78bceb3.png",
      "http://s3.amazonaws.com/ragefaces/02094b42ed51e063b0b9a25e9b774850.png",
      "http://s3.amazonaws.com/ragefaces/4f767454e72cef87d679c12823892356.png",
      "http://s3.amazonaws.com/ragefaces/615fdaf29bbe5c29e6ac88e94328097d.png"
    ]
    say links.shuffle.first
  end

  match /(.)*whew(.)*/ do
    say "http://s3.amazonaws.com/ragefaces/e1f11b7e02abf942f13564a72220ff34.png"
  end

  match /(.)*kids(.)*/ do
    say "http://s3.amazonaws.com/ragefaces/a0bb256993d98fb2d037a0eac5a6b59c.png"
    say "who said children?"
  end

  match /(.)*do next?(.)*/ do
    images = [
      "http://1.bp.blogspot.com/_D_Z-D2tzi14/TBpOnhVqyAI/AAAAAAAADFU/8tfM4E_Z4pU/s400/responsibility12(alternate).png",
      "http://2.bp.blogspot.com/_D_Z-D2tzi14/TBpOglLvLgI/AAAAAAAADFM/I7_IUXh6v1I/s400/responsibility10.png",
      "http://4.bp.blogspot.com/_D_Z-D2tzi14/TBpOY-GY8TI/AAAAAAAADFE/eboe6ItMldg/s400/responsibility11.png",
      "http://2.bp.blogspot.com/_D_Z-D2tzi14/TBpOOgiDnVI/AAAAAAAADE8/wLkmIIv-xiY/s400/responsibility13(alternate).png",
      "http://3.bp.blogspot.com/_D_Z-D2tzi14/TBpa3lAAFQI/AAAAAAAADFs/8IVZ-jzQsLU/s400/responsibility14.png",
      "http://3.bp.blogspot.com/_D_Z-D2tzi14/TBpoOlpMa_I/AAAAAAAADGU/CfZVMM9MqsU/s400/responsibility102.png",
      "http://4.bp.blogspot.com/_D_Z-D2tzi14/TBpoVLLDgCI/AAAAAAAADGc/iqux8px_V-s/s400/responsibility12(alternate)2.png",
      "http://2.bp.blogspot.com/_D_Z-D2tzi14/TBpqGvZ7jVI/AAAAAAAADGk/hDTNttRLLks/s400/responsibility8.png"
    ]
    say images.shuffle.first
  end

  match /ship it!/ do
    squirrels = [
      "http://img.skitch.com/20100714-d6q52xajfh4cimxr3888yb77ru.jpg",
      "https://img.skitch.com/20111026-r2wsngtu4jftwxmsytdke6arwd.png"
    ]
    say squirrels.shuffle.first
  end

  match /(.)*like a boss(.)*/ do
    images = [
      "http://s3.amazonaws.com/kym-assets/photos/images/original/000/114/151/14185212UtNF3Va6.gif?1302832919",
      "http://s3.amazonaws.com/kym-assets/photos/images/newsfeed/000/110/885/boss.jpg",
      "http://verydemotivational.files.wordpress.com/2011/06/demotivational-posters-like-a-boss.jpg",
      "http://assets.head-fi.org/b/b3/b3ba6b88_funny-facebook-fails-like-a-boss3.jpg",
      "http://img.anongallery.org/img/6/0/like-a-boss.jpg",
      ]
    say images.shuffle.first
  end

  match /humble/ do
    say "http://s3.amazonaws.com/ragefaces/b50a224ee8948d6fd1987d3172f01017.png"
  end

  match /Z?OMG/ do
    say "http://s3.amazonaws.com/ragefaces/b34804725fcfa64106b786f37c2f32fe.png"
  end

  match /friday|Friday/ do
    say "http://s3.amazonaws.com/ragefaces/3aabae7fcc91e1646ce10ac03a4cc93f.png"
    say "say whut, friiiiday?"
  end
end

# Connect and join some rooms
scamp.connect!(@config['room_names'])