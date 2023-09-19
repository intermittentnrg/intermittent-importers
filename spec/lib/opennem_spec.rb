require 'spec_helper'

RSpec.describe Opennem::Price do
  subject { Opennem::Price }
  describe '#points_price' do
    around(:example) { |ex| VCR.use_cassette 'opennem_price', &ex }
    let(:date) { Date.new(2023,1,1) }
    subject(:prices) { Opennem::Price.new(date:, country: 'WEM-WEM').points_price }
    it do
      expect(prices.first).to include(value: 7429)
    end
    it do
      expect(prices.first).to include(country: 'WEM-WEM')
    end
  end
end
