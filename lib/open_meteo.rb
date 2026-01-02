require 'faraday'
require 'fast_jsonparser'
require 'chronic'

class OpenMeteo
  include SemanticLogger::Loggable
  URL = 'https://archive-api.open-meteo.com/v1/archive'
  TIME_FORMAT = '%Y-%m-%dT%H:%M'

  def self.cli(args)
    unless args.length == 3
      $stderr.puts "#{$0} <location_id> <from> <to>"
      exit 1
    end
    location = Location.find args[0].to_i
    from = Chronic.parse args[1]
    to = Chronic.parse args[2]
    new.add_date_range(from, to, location).done!
  end

  def self.each
    # Get all locations that have temperature data
    Location.joins(:temperatures).distinct.pluck(:id).each do |location_id|
      location = Location.find(location_id)
      # Get the most recent temperature for this location
      last_temp = Temperature.where(location_id:).maximum(:time)

      if last_temp
        from = last_temp.in_time_zone(TZInfo::Timezone.get('UTC')).to_datetime
        to = [from + 1.year, DateTime.tomorrow.beginning_of_day].min

        SemanticLogger.tagged(location.name) do
          (from.to_date..to.to_date).each do |date|
            yield date
          end
        end
      end
    end
  end

  def initialize
    @r = []
    @datafiles = []
  end

  def add(date)
    add_date(date)
  end

  def add_date(date)
    add_date_range(date, date + 1.day)
  end

  def add_date_range(from, to, location, hourly = 'temperature_2m')
    res = Faraday.get(
      URL,
      {
        latitude: location.point.x,
        longitude: location.point.y,
        start_date: from.to_date,
        end_date: to.to_date,
        hourly: hourly
      }
    )

    json = FastJsonparser.parse(res.body)
    if json[:error]
      raise json[:reason]
    end

    add_json(json, location)
  end

  def add_json(json, location)
    json[:hourly][:time].each_with_index do |time, i|
      time = Time.strptime(time, TIME_FORMAT)
      value = json[:hourly][:temperature_2m][i]
      next if value.nil?

      @r << {time:, value:, location_id: location.id}
    end

    self
  end

  def done!
    return if @r.empty?

    logger.benchmark_info("upsert") do
      Temperature.upsert_all(@r)
    end
  end
end
