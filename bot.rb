require 'scamp'
require 'yuno'
require 'net/http'
require 'json'
require 'cgi'
require_relative 'bot_config.rb'
require_relative 'lib/tasker.rb'

@config = BotConfig.new
scamp = Scamp.new(:api_key => @config['api_key'], :subdomain => @config['subdomain'], :verbose => false, :ignore_self => true)

def yuno
  @yuno ||= Yuno.new(:yuno)
end

scamp.behaviour do

  match /^(dumbot|dog)\??$/i do
    say "http://i3.kym-cdn.com/entries/icons/original/000/007/447/hello-yes-this-is-dog.png"
  end

  match /^(dumbot )?help/i do
    say "#{scamp.command_list.map(&:to_s).join("\n-")}"
  end

  match /^artme (?<search>.+)/ do
    url = "http://ajax.googleapis.com/ajax/services/search/images?rsz=large&start=0&v=1.0&q=#{CGI.escape(search)}"
    http = EventMachine::HttpRequest.new(url).get
    http.errback { say "Couldn't get #{url}: #{http.response_status.inspect}" }
    http.callback do
      if http.response_header.status == 200
        results = Yajl::Parser.parse(http.response)
        result_size = results['responseData']['results'].size
        if result_size > 0
          say results['responseData']['results'][(result_size * rand).to_i]['url'].gsub('%25', '%')
        else
          say "No images matched #{search}"
        end
      else
        # logger.warn "Couldn't get #{url}"
        say "Couldn't get #{url}"
      end
    end
  end

  # > geminfo rails
  # > geminfo rails more
  match /^geminfo (?<gemname>\w+) ?(?<more>\w+)?/ do
    versions_url = "http://rubygems.org/api/v1/versions/#{CGI.escape(gemname)}.json"
    versions_http = EventMachine::HttpRequest.new(versions_url).get
    versions_http.errback { say "Oh crap, some error. Try http://rubygems.org/search?query=#{CGI.escape(gemname)}" }

    versions_http.callback do
      if versions_http.response_header.status == 200
        result = Yajl::Parser.parse(versions_http.response)
        recent = result.to_a.first
        msg = "The most recent version is #{recent['number']}, released #{recent['built_at']}. Gem summary: #{recent['summary']}"
        msg << "\ngem '#{gemname}', '~> #{recent['number']}'"
        say msg
      else
        say "Oh crap, some error. Try http://rubygems.org/search?query=#{CGI.escape(gemname)}"
      end
    end

    if more && !more.empty?
      info_url = "http://rubygems.org/api/v1/gems/#{CGI.escape(gemname)}.json"
      info_http = EventMachine::HttpRequest.new(info_url).get
      info_http.errback {}

      info_http.callback do
        if info_http.response_header.status == 200
          result = Yajl::Parser.parse(info_http.response)
          msg = []
          msg << "downloads: #{result['downloads']}" if result['downloads']
          msg << "project:   #{result['project_uri']}" if result['project_uri']
          msg << "homepage:  #{result['homepage_uri']}" if result['homepage_uri']
          msg << "source:    #{result['source_code_uri']}" if result['source_code_uri']
          say msg.join("\n")
        else
          say "Oh crap, some error. Try http://rubygems.org/search?query=#{CGI.escape(gemname)}"
        end
      end
    end
  end

  # synchronous and locking!
  match /^Y U NO(?<action>.+)$/ do
    if action
      link = yuno.generate "Y U NO", action
      say link
    end
  end

  # TODO make the location easily configurable or pass it as a parameter
  match /^weather!?$/ do
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

  match /^(north korea|cccp|soviet russia)$/i do
    say "censorship stick!\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|"
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
    images = ["http://i2.kym-cdn.com/entries/icons/original/000/000/554/facepalm.jpg",
      "http://i3.kym-cdn.com/photos/images/newsfeed/000/212/717/1323056694381.jpg",
      "http://i0.kym-cdn.com/photos/images/newsfeed/000/180/820/1317484924001.jpg",
      "http://i1.kym-cdn.com/photos/images/newsfeed/000/164/581/obama_facepalm.jpg"]
    say images.sample
  end

  match /^[f]+[u]+$/ do
    links = [
      "http://ragefac.es/faces/medium_b801183d49d9a7a5491df449d78bceb3.png",
      "http://s3.amazonaws.com/ragefaces/02094b42ed51e063b0b9a25e9b774850.png",
      "http://s3.amazonaws.com/ragefaces/4f767454e72cef87d679c12823892356.png",
      "http://s3.amazonaws.com/ragefaces/615fdaf29bbe5c29e6ac88e94328097d.png"
    ]
    say links.sample
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
    say images.sample
  end

  match /ship it!/ do
    squirrels = [
      "http://img.skitch.com/20100714-d6q52xajfh4cimxr3888yb77ru.jpg",
      "https://img.skitch.com/20111026-r2wsngtu4jftwxmsytdke6arwd.png"
    ]
    say squirrels.sample
  end

  match /(.)*like a boss(.)*/ do
    images = [
      "http://s3.amazonaws.com/kym-assets/photos/images/original/000/114/151/14185212UtNF3Va6.gif?1302832919",
      "http://s3.amazonaws.com/kym-assets/photos/images/newsfeed/000/110/885/boss.jpg",
      "http://verydemotivational.files.wordpress.com/2011/06/demotivational-posters-like-a-boss.jpg",
      "http://assets.head-fi.org/b/b3/b3ba6b88_funny-facebook-fails-like-a-boss3.jpg",
      "http://img.anongallery.org/img/6/0/like-a-boss.jpg",
      ]
    say images.sample
  end

  match /humble/ do
    say "http://s3.amazonaws.com/ragefaces/b50a224ee8948d6fd1987d3172f01017.png"
  end

  match /Z?OMG/ do
    say "http://s3.amazonaws.com/ragefaces/b34804725fcfa64106b786f37c2f32fe.png"
  end

  match /friday(.)?$/i do
    images = ["http://i.imgur.com/1sZ9T.jpg", "http://s3.amazonaws.com/ragefaces/3aabae7fcc91e1646ce10ac03a4cc93f.png"]
    say images.sample
  end

  match /^add task (?<task>.+)$/ do
    Tasker.instance.push(task)
    say Tasker.instance.all_tasks
  end

  match /^(all )?tasks?$/ do
    say Tasker.instance.all_tasks
  end

  match /^my tasks?$/ do
    say Tasker.instance.my_tasks(user)
  end

  match /^(?<id>\d+) is mine$/ do
    Tasker.instance.claim(id, user)
    say Tasker.instance.all_tasks
  end

  match /^(?<id>\d+) is done$/ do
    say Tasker.instance.done(id, user)
  end

  match /^(?<id>\d+) is too hard$/ do
    say Tasker.instance.give_up(id)
  end

  match /^(?<username>.+) do (?<id>\d+)$/ do
    say Tasker.instance.assign(id, username)
  end

  match /^import tasks? (?<lines>.+)/m do
    Tasker.instance.import(lines)
    say Tasker.instance.all_tasks
  end

  match /^task help$/ do
    say Tasker.instance.help
  end

end

# Connect and join some rooms
scamp.connect!(@config['room_names'])