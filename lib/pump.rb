class Pump
  @@logger = SemanticLogger[Pump]

  def initialize(source, out_series, influxdb)
    @source = source
    @out_series = out_series
    @influxdb = influxdb
  end

  def run_loop
    pass = false
    loop do
      pass = run_all
      break unless pass
      $stderr.puts "===== LOOP ====="
    end
  end

  def run
    pass = false
    #require 'pry' ; binding.pry
    #@source::COUNTRIES.keys.each do |country|
    @influxdb.query("SELECT time,country,LAST(value) FROM #{@out_series} GROUP BY country").each do |row|
      country = row['tags']['country']
      @@logger.tagged(country: country) do
        #row = @@logger.measure_info("sincedb query") { @influxdb.query("SELECT time,LAST(value) FROM #{@out_series} WHERE country = %{1}", params: [country]) }.first
        from = DateTime.parse row['values'][0]['time'] rescue @source::DEFAULT_START + 7.years
        to = [from + 1.year, DateTime.now.beginning_of_hour].min
        if from > 4.hours.ago
          @@logger.info "has data in last 4 hours. skipping"
          next
        end
        @@logger.measure_info "Load #{from} to #{to}" do
          begin
            e = @source.new(country: country, from: from, to: to)
            data = e.points.map do |p|
              {
                series:    @out_series,
                values:    { value: p[:value] },
                tags:      p[:tags],
                timestamp: p[:timestamp].to_i
              }
            end
            @influxdb.write_points(data)
            @@logger.info "#{data.length} points"
            pass if e.last_time > from
          rescue ENTSOE::EmptyError
            #require 'pry' ;binding.pry
            raise if to < 1.day.ago

            # skip missing historical data
            @@logger.warn "skipped missing data until #{to}"
          end
        end
      end
    end

    pass
  end
end
