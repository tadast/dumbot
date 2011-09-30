require 'scamp'
require 'yuno'

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
end

# Connect and join some rooms
scamp.connect!(["your room name"])