#!/usr/bin/env ruby
# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'


require 'oauth'
require 'json'
require 'typhoeus'
require 'oauth/request_proxy/typhoeus_request'

require 'base64'

# The code below sets the consumer key and secret from your environment variables
# To set environment variables on Mac OS X, run the export command below from the terminal:
# export CONSUMER_KEY='YOUR-KEY', CONSUMER_SECRET='YOUR-SECRET'
consumer_key = ENV["TWITTER_API_KEY"]
consumer_secret = ENV["TWITTER_API_KEY_SECRET"]


create_tweet_url = "https://api.twitter.com/2/tweets"

# Be sure to add replace the text of the with the text you wish to Tweet.
# You can also add parameters to post polls, quote Tweets, Tweet with reply settings, and Tweet to Super Followers in addition to other features.

consumer = OAuth::Consumer.new(consumer_key, consumer_secret,
                                        :site => 'https://api.twitter.com',
                                        :authorize_path => '/oauth/authenticate',
                                        :debug_output => false)

def get_request_token(consumer)

        request_token = consumer.get_request_token()

  return request_token
end

def get_user_authorization(request_token)
        puts "Follow this URL to have a user authorize your app: #{request_token.authorize_url()}"
        puts "Enter PIN: "
        pin = gets.strip

  return pin
end

def obtain_access_token(consumer, request_token, pin)
        token = request_token.token
        token_secret = request_token.secret
        hash = { :oauth_token => token, :oauth_token_secret => token_secret }
        request_token  = OAuth::RequestToken.from_hash(consumer, hash)

        # Get access token
        access_token = request_token.get_access_token({:oauth_verifier => pin})

        return access_token
end


def create_tweet(url, media_id, oauth_params)
  @json_payload = {
    "text": "Demand, Solar, Wind for past 14 days\n\n🌍🔗https://intermittent.energy/d/3sj6qwA7z/demand-solar-wind-nuclear?from=now-14d&to=now&orgId=1",
    "media": {"media_ids": [media_id]}
  }
  options = {
    :method => :post,
    headers: {
      "User-Agent": "v2CreateTweetRuby",
      "content-type": "application/json"
    },
    body: JSON.dump(@json_payload)
  }
  request = Typhoeus::Request.new(url, options)
  oauth_helper = OAuth::Client::Helper.new(request, oauth_params.merge(:request_uri => url))
  request.options[:headers].merge!({"Authorization" => oauth_helper.header}) # Signs the request
  response = request.run

  return response
end

def upload_media(oauth_params)
  @media_payload = {
    #"media_data": Base64.encode64(File.read('picture2.png')),
    "media_category": "tweet_image"
  }

  options = {
    :method => :post,
    headers: {
      "User-Agent": "v2CreateTweetRuby",
      #"content-type": "application/json"
      #"Content-Type": "multipart/form-data"
    },
    body: {
      data: JSON.dump(@media_payload),
      media: File.open('picture2.png','r')
    }
  }
  url = 'https://upload.twitter.com/1.1/media/upload.json'
  request = Typhoeus::Request.new(url, options)
  oauth_helper = OAuth::Client::Helper.new(request, oauth_params.merge(:request_uri => url))
  request.options[:headers].merge!({"Authorization" => oauth_helper.header}) # Signs the request
  #binding.pry
  response = request.run

  return response
end

# PIN-based OAuth flow - Step 1
#request_token = get_request_token(consumer)
# PIN-based OAuth flow - Step 2
#pin = get_user_authorization(request_token)
# PIN-based OAuth flow - Step 3
#access_token = obtain_access_token(consumer, request_token, pin)
access_token = ENV['TWITTER_ACCESS_TOKEN']



# Exchange your oauth_token and oauth_token_secret for an AccessToken instance.
consumer = OAuth::Consumer.new(ENV['TWITTER_API_KEY'], ENV['TWITTER_API_KEY_SECRET'], { :site => "https://api.twitter.com", :scheme => :header })

# now create the access token object from passed values
token_hash = { :oauth_token => ENV['TWITTER_ACCESS_TOKEN'], :oauth_token_secret => ENV['TWITTER_ACCESS_TOKEN_SECRET'] }
access_token = OAuth::AccessToken.from_hash(consumer, token_hash )

#return access_token

# Exchange our oauth_token and oauth_token secret for the AccessToken instance.
#access_token = prepare_access_token(, )

# use the access token as an agent to get the home timeline
#response = access_token.request(:get, "https://api.twitter.com/1.1/statuses/home_timeline.json")



oauth_params = {:consumer => consumer, :token => access_token}


#require 'pry' ; binding.pry
response = upload_media(oauth_params)
response_body = JSON.parse(response.body)
media_id = response_body["media_id_string"]

response = create_tweet(create_tweet_url, media_id, oauth_params)
response_body = JSON.parse(response.body)
tweet_id = response_body["data"]["id"]

#puts response.code, JSON.pretty_generate(JSON.parse(response.body))
