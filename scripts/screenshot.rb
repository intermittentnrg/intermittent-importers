#!/usr/bin/env ruby
require 'bundler/setup'
require "selenium-webdriver"

client = Selenium::WebDriver::Remote::Http::Default.new
client.read_timeout = 180 # seconds
driver = Selenium::WebDriver.for :remote, url: "http://localhost:4444/wd/hub", capabilities: :firefox, http_client: client

begin
  driver.manage.window.resize_to(3840, 2160) # <- resizes the window

  driver.navigate.to "https://intermittent.energy/d/3sj6qwA7z/load-solar-wind-nuclear?orgId=1&from=now-6y&to=now&kiosk=tv"

  wait = Selenium::WebDriver::Wait.new(:timeout => 120) # seconds
  wait.until do
    loading_size = driver.find_elements(:class, 'panel-loading').size
    content_size = driver.find_elements(:class, 'panel-content').size
    puts "loading_size=#{loading_size}"
    puts "content_size=#{content_size}"

    loading_size == 0 && content_size > 0
  end

  width  = driver.execute_script("return Math.max(document.body.scrollWidth,document.body.offsetWidth,document.documentElement.clientWidth,document.documentElement.scrollWidth,document.documentElement.offsetWidth);")
  height = driver.execute_script("return Math.max(document.body.scrollHeight,document.body.offsetHeight,document.documentElement.clientHeight,document.documentElement.scrollHeight,document.documentElement.offsetHeight);")

  driver.manage.window.resize_to(width, height) # <- resizes the window
  picture = driver.screenshot_as(:png)

  File.open('picture2.png', 'w+') do |fh|
    fh.write picture
  end
ensure
  driver.quit
end
