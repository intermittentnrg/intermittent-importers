#!/usr/bin/env ruby

require 'bundler/setup'
require 'dotenv/load'
require 'x'
require 'x/media_uploader'

client = X::Client.new(
  api_key: ENV["TWITTER_API_KEY"],
  api_key_secret: ENV["TWITTER_API_KEY_SECRET"],
  access_token: ENV['TWITTER_ACCESS_TOKEN'],
  access_token_secret: ENV['TWITTER_ACCESS_TOKEN_SECRET']
)

file_path = "render.mp4"
media_category = "tweet_video"

media = X::MediaUploader.chunked_upload(client:, file_path:, media_category:)
X::MediaUploader.await_processing(client:, media:)

text = <<-EOF
Europe electricity day ahead hourly spot price.
Today and tomorrow. UTC.
Range capped at €300/MWh.
(testing automated posting)
EOF
tweet_body = {text:, media: {media_ids: [media["media_id_string"]]}}

tweet = client.post("tweets", tweet_body.to_json)

puts tweet["data"]["id"]
