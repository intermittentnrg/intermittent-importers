#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
require 'minisky'

social_thread = SocialThread.find_or_create_by(id: 2)
puts social_thread.inspect


### AUTH
sky = Class.new do
  include Minisky::Requests
  def host
    'truffle.us-east.host.bsky.network'
  end
  def config
    {
      'id' => ENV['BLUESKY_USERNAME'],
      'pass' => ENV['BLUESKY_PASSWORD']
    }
  end
  def save_config
  end
end.new

sky_video = Minisky.new('video.bsky.app', nil)
resp = sky.get_request(
  'com.atproto.server.getServiceAuth',
  {
    aud: "did:web:#{sky.host}",
    lxm: 'com.atproto.repo.uploadBlob',
    exp: Time.now.to_i + 1800
  }
)


### UPLOAD
video_path = "render.mp4"
begin
  job = sky_video.post_request(
    'app.bsky.video.uploadVideo',
    IO.binread(video_path),
    params: { did: sky.user.did, name: 'render.mp4' },
    headers: {
      'Content-Type': 'video/mp4',
      'Content-Length': File.size(video_path).to_s
    },
    auth: resp['token']
  )
rescue Minisky::ClientErrorResponse => e
  job = e.data
end

status = nil
begin
  sleep 2
  status = sky_video.get_request('app.bsky.video.getJobStatus', { jobId: job['jobId'] })
end until status['jobStatus']['blob']


### POST
text = <<-EOF
Day ahead spot prices tomorrow #{Date.tomorrow.strftime('%a %b %-d')} UTC
EOF

# facets = [{
#             index: {
#               byteStart: 0,
#               byteEnd: link.length
#             },
#             features: [
#               {
#                 '$type': "app.bsky.richtext.facet#link",
#                 uri: link
#               }
#             ]
#           }]

width = 1074
height = 954
body = {
  repo: sky.user.did,
  collection: 'app.bsky.feed.post',
  record: {
    text:,
    createdAt: Time.now.iso8601,
    langs: ["en"],
    embed: {
      '$type': 'app.bsky.embed.video',
      video: status['jobStatus']['blob'],
      aspectRatio: { width:, height: }
    }
  }
}

if social_thread.reply?
  body[:record][:reply] = social_thread.reply
end
#puts body.to_json
resp = sky.post_request('com.atproto.repo.createRecord', body)

if social_thread.reply?
  sky.post_request('com.atproto.repo.createRecord', {
    '$type': 'app.bsky.feed.repost',
    repo: sky.user.did,
    collection: 'app.bsky.feed.repost',
    record: {
      subject: { uri: resp['uri'], cid: resp['cid'] },
      createdAt: Time.now.iso8601,
    }
  })
end

social_thread.reply['root'] ||= resp.slice('uri', 'cid')
social_thread.reply['parent'] = resp.slice('uri', 'cid')
social_thread.save!
