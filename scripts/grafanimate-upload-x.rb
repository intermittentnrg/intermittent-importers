#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
require 'x'
require 'x/media_uploader'

social_thread = SocialThread.find_or_create_by(id: 1)

### AUTH
client = X::Client.new(
  api_key: ENV["TWITTER_API_KEY"],
  api_key_secret: ENV["TWITTER_API_KEY_SECRET"],
  access_token: ENV['TWITTER_ACCESS_TOKEN'],
  access_token_secret: ENV['TWITTER_ACCESS_TOKEN_SECRET']
)


### UPLOAD

file_path = "render.mp4"
media_category = "tweet_video"

media = X::MediaUploader.chunked_upload(client:, file_path:, media_category:)
X::MediaUploader.await_processing(client:, media:)


### POST

text = <<-EOF
Day ahead spot prices tomorrow #{Date.tomorrow.strftime('%a %b %-d')} UTC
Range capped at €300/MWh.
EOF
tweet_body = {text:, media: {media_ids: [media["media_id_string"]]}}
tweet_body["reply"] = social_thread.reply if social_thread.reply?

tweet = client.post("tweets", tweet_body.to_json)
tweet_id = tweet["data"]["id"]
puts tweet_id

if social_thread.reply?
  client.post("users/#{ENV['TWITTER_USER_ID']}/retweets", {tweet_id:}.to_json)
end

social_thread.reply = {in_reply_to_tweet_id: tweet_id}
social_thread.save!
