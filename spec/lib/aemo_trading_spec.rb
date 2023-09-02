require './spec/spec_helper'

RSpec.describe Aemo::Trading do
  describe :parse_time do
    subject :e do
      time = "202308301800"
      url = "https://nemweb.com.au/Reports/Current/TradingIS_Reports/PUBLIC_TRADINGIS_#{time}_0000000395916754.zip"
      VCR.use_cassette("aemo_trading_#{time}") do
        Aemo::Trading.new(url)
      end
    end
    it { expect(subject.points_price.first[:time].utc).to eq Time.new(2023,8,30,8) }

    context 'NSW1' do
      subject :nsw do
        e.points.select { |row| row[:country] == 'NSW1' }.first
      end
      #it { require 'pry' ; binding.pry }
      it { expect(nsw[:value]).to eq 299.99 }
    end
  end
end
