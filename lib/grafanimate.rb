require 'active_support'
require 'active_support/core_ext'
require "selenium-webdriver"

module Grafanimate
  class Base
    #CROP = false
    SELENIUM_URL = ENV['SELENIUM_URL']

    TIME_FORMAT = '%Y-%m-%d %H:%M'
    TIMEOUT = 60
    attr_reader :driver, :wait
    def initialize(url, from, to)
      @from, @to = from, to
      logger.info("Starting screenshots for #{from} to #{to}")
      client = Selenium::WebDriver::Remote::Http::Default.new
      client.read_timeout = 120 # seconds
      @driver = Selenium::WebDriver.for :remote, url: SELENIUM_URL, capabilities: :firefox, http_client: client
      @wait = Selenium::WebDriver::Wait.new(timeout: TIMEOUT) # seconds

      driver.manage.window.resize_to(1200, 1200+85) # <- resizes the window
      driver.action.move_to_location(0,0)

      @driver.navigate.to(url)

      @wait.until { driver.find_element(:css, 'button[data-testid="data-testid TimePicker Open Button"]') }
    end

    def wait_for_panels
      @wait.until { @driver.execute_script("panels = Object.values(window.grafanaRuntime.getPanelData());return panels.length && panels.every(function(o) {return o?.state=='Done'})") }
    end
    def wait_for_scene_state
      @wait.until { @driver.execute_script("return __grafanaSceneContext.state.$data._state.data.state == 'Done'") }
    end
    def wait_multiple
      body = @driver.find_element(:tag_name, 'body')
      @wait.until do
        tests = []
        tests << !body.text.include?('Loading')
        #tests << (@driver.execute_script("panels = Object.values(window.grafanaRuntime.getPanelData());return panels.length && panels.every(function(o) {return o?.state=='Done'})") rescue false)<
        tests << @driver.execute_script("return __grafanaSceneContext.state.$data._state.data.state == 'Done'")
        tests << @driver.execute_script("return __grafanaSceneContext.state.$data._state.data.series.length > 0")
        tests << @driver.execute_script("return document.querySelector('[aria-label=\"Refresh\"]')")
        tests << @driver.execute_script("return !document.querySelector('[aria-label=\"Cancel\"]')")
        break if tests.all?
        if tests.any?
          logger.warn "Inconsistent tests: #{tests.inspect}"
        end

        false
      end
    end

    def screenshot(t)
      path = "render/picture-#{t.strftime(TIME_FORMAT)}.png"
      logger.benchmark_info(path) do
        picture = @driver.screenshot_as(:png)
        File.binwrite(path, picture)
      end
    end

    def self.render
      #video_framerate = 1.5
      #video_fps = 30
      video_framerate = 5
      video_fps = 5
      source = 'render/*.png'
      target = 'render.mp4'
      vf = []
      #vf << "framerate=fps=30:interp_start=0:interp_end=255:scene=100"
      vf << self::CROP if self::CROP
      vf += ["pad=ceil(iw/2)*2:ceil(ih/2)*2", "fps=#{video_fps}", "format=yuv420p"]
      c = ['ffmpeg']
      c += ['-framerate', video_framerate.to_s]
      c += %w(-pattern_type glob)
      c += ['-i', source]
      c += %w(-c:v libx264)
      c += %w(-preset veryslow)
      c += %w(-profile high422)
      c += %w(-movflags +faststart)
      c += ['-vf', vf.join(', ')]
      c << target
      c << '-y'
      #require 'pry' ; binding.pry
      system(*c)
    end

    def quit
      @driver.quit
    end

    def scenesapi
      body = @driver.find_element(:tag_name, 'body')
      wait_multiple

      t = @from
      while t <= @to
        @driver.execute_script <<-JS
          __grafanaSceneContext.state.$timeRange.setState({ from: '#{t.strftime(TIME_FORMAT)}', to: '#{(t+1.hour).strftime(TIME_FORMAT)}' });
          __grafanaSceneContext.state.$timeRange.onRefresh();
        JS
        sleep 0.1
        wait_multiple
        screenshot(t)

        t += 1.hour
      end
    end
  end

  class PriceMap < Base
    include SemanticLogger::Loggable

    URL = "http://grafana.monitoring/d/fa529e06-ff34-415d-adf1-dde1a6f28350/prices-plotly-map?orgId=1&var-region=europe&var-area=All&var-scale_max=300&var-min_interval=5m&var-frame_duration=150&kiosk"
    CROP = 'crop=1074:953:104:175'
    def initialize
      tz = TZInfo::Timezone.get('Europe/Berlin')
      from = tz.local_to_utc(1.day.from_now.beginning_of_day)
      to = tz.local_to_utc(1.day.from_now.end_of_day.beginning_of_hour)
      super(URL, from, to)
    end
  end

  class TransmissionMap < Base
    include SemanticLogger::Loggable

    URL = "http://grafana.monitoring/d/ae4xmqh628a9sf/transmission-plotly-map?orgId=1&var-region=europe&var-area=$__all&var-min_interval=1h"
    CROP = 'crop=1074:953:104:226'
    def initialize
      #super(URL, 7.days.ago.beginning_of_day, Time.now.beginning_of_day - 1.hour)
      super(URL, 7.days.ago.beginning_of_day, Time.now.beginning_of_day - 1.hour)
    end
  end

  class NuclearMap < Base
    URL = "http://grafana.monitoring/d/adk4o41xfjncwb/generation-of-peak-plotly-map?from=now-30d&to=now&orgId=1&var-region=argentina&var-region=brazil&var-region=canada&var-region=europe&var-region=south_africa&var-region=taiwan&var-region=usa&var-area=All&var-production_type=14&var-min_interval=1h&var-colorscale=Electric"
    CROP = 'crop=1074:953:104:52'
    def initialize
     super(URL, 1.day.ago.beginning_of_day, Date.tomorrow - 1.hour)
    end
  end
end
