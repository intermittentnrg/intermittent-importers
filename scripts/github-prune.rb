#!/usr/bin/env ruby
require 'bundler/setup'
require 'active_support'
require 'active_support/core_ext'
require 'octokit'

REPO = 'intermittentnrg/intermittent-importers'
WORKFLOW = 'refresh.yml'
GITHUB_TOKEN = ENV['GITHUB_TOKEN'] || raise('Set GITHUB_TOKEN env var')

client = Octokit::Client.new(access_token: GITHUB_TOKEN)
client.auto_paginate = true
cutoff = 3.weeks.ago


begin
  puts "Deleting workflow runs older than 3 weeks..."
  count = 0
  client.paginate("repos/#{REPO}/actions/workflows/#{WORKFLOW}/runs", created: "<#{cutoff.strftime('%Y-%m-%d')}") do |data, last_response|
    last_response.data.workflow_runs.each do |workflow|
      puts "Deleting workflow run #{workflow.id}"
      client.delete_workflow_run(REPO, workflow.id)
      count += 1
    end
  end
  puts "Deleted #{count} workflow runs"

  puts "Deleting deployments older than 3 weeks..."
  count = 0
  client.paginate("repos/#{REPO}/deployments") do |data, last_response|
    last_response.data.each do |deployment|
      next if deployment.created_at > cutoff
      puts "Deleting deployment #{deployment.id}"
      client.delete_deployment(REPO, deployment.id)
      count += 1
    end
  end
  puts "Deleted #{count} deployments"
rescue Octokit::TooManyRequests
  puts "Rate limit hit, exiting for next run."
  exit 1
end
