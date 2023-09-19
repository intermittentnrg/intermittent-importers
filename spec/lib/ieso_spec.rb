require './spec/spec_helper'

RSpec.describe Ieso::Generation do
  subject { Ieso::Generation }
  context :cli do
    context 'with date range' do
      let(:args) { ['2023-09-01', '2023-09-02'] }
      before do
      end
      around(:example) do |ex|
        VCR.use_cassette("ieso_generation", &ex)
      end
      it do
        expect(::Generation).to receive(:upsert_all)
        subject.cli(args)
      end
    end
  end
end

RSpec.describe Ieso::Price do
  subject { Ieso::Price }
  around(:example) { |ex| VCR.use_cassette('ieso_price', &ex) }
  let(:date) { Date.new(2023,9,1) }
  context '#points_price' do
    it do
      prices = subject.new(date).points_price
      expect(prices.first).to include(value: 2203)
    end
  end
end

RSpec.describe Ieso::PriceYear do
  subject { Ieso::PriceYear }
  around(:example) { |ex| VCR.use_cassette('ieso_price_year', &ex) }
  let(:date) { Date.new(2023,1,1) }
  context '#points_price' do
    it do
      prices = subject.new(date).points_price
      expect(prices.first).to include(value: 1442)
    end
  end
end
