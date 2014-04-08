require 'lifx'
require 'twitter'
require 'yaml'

creds = YAML.load_file("credentials.yml")
twitter = Twitter::Streaming::Client.new do |config|
  config.consumer_key        = creds["twitter"]["consumer_key"]
  config.consumer_secret     = creds["twitter"]["consumer_secret"]
  config.access_token        = creds["twitter"]["access_token"]
  config.access_token_secret = creds["twitter"]["access_token_secret"]
end

lifx = LIFX::Client.lan
lifx.discover!
sleep 2 # Wait for tag data to come back
light = lifx.lights.first

if !light
  puts "No LIFX lights found."
  exit 1
end

puts "Using light(s): #{light}"

def update_light(light, color)
  if color[0] == ?#
    hex = color[1..-1]
  else
    hex = color
  end

  case hex.length
  when 6
    rgb = hex.scan(/../).map(&:hex)
  when 3
    rgb = hex.scan(/./).map do |char|
      (char * 2).hex
    end
  end

  c = LIFX::Color.rgb(*rgb)

  light.turn_on!
  light.set_color(c, duration: 0.2)
  puts "#{Time.now}: Got #{color} set light to #{c}"
end

def find_hex(tweet)
  if tweet =~ /(#[0-9a-f]{3}|#[0-9a-f]{6})\b/i
    $1
  end
end

update_light(light, "#fff")

twitter.user do |object|
  p object
  case object
  when Twitter::Tweet
    if object.reply?
      if hex = find_hex(object.full_text)
        update_light(light, hex)
      end
    end
  end
end
