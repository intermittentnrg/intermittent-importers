require 'csv'
require 'tzinfo'

tz = TZInfo::Timezone.get('Europe/Madrid')

CSV.foreach(ARGV[0], col_sep: ';') do |row|
  #require 'pry' ; binding.pry
  time = DateTime.strptime(row.shift, '%Y-%m-%d %H:%M')
  time = tz.local_to_utc(time)
  value = row.shift.gsub(',','.')
  puts "#{time};#{value}"
end
