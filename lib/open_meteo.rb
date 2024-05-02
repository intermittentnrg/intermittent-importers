require 'faraday'
require 'fast_jsonparser'
require 'chronic'

class OpenMeteo
  include SemanticLogger::Loggable
  URL = 'https://archive-api.open-meteo.com/v1/archive'
  TIME_FORMAT = '%Y-%m-%dT%H:%M'

  def self.cli(args)
    unless args.length == 3
      $stderr.puts "#{$0} <location_id> <start_date> <end_date>"
      exit 1
    end
    location = Location.find args[0].to_i
    start_date = Chronic.parse args[1]
    end_date = Chronic.parse args[2]
    OpenMeteo.new(location, start_date, end_date).process
  end

  def initialize(location, start_date, end_date, hourly = 'temperature_2m')
    @location, @start_date, @end_date, @hourly = location, start_date, end_date, hourly
  end

  def fetch
    res = Faraday.get(
      URL,
      {
        latitude: @location.point.x,
        longitude: @location.point.y,
        start_date: @start_date.to_date,
        end_date: @end_date.to_date,
        hourly: @hourly
      }
    )
    @res = FastJsonparser.parse(res.body)
    #require 'pry' ; binding.pry
    if @res[:error]
      raise @res[:reason]
    end

    res
  end

  def points
    fetch
    r = []
    @res[:hourly][:time].each_with_index do |time, i|
      time = Time.strptime(time, TIME_FORMAT)
      value = @res[:hourly][:temperature_2m][i]
      next if value.nil?
      r << {time:, value:, location_id: @location.id}
    end
    #require 'pry' ; binding.pry

    r
  end

  def process
    logger.benchmark_info("upsert") do
      Temperature.upsert_all(points)
    end
  end
end

