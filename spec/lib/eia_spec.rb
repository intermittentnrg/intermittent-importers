require 'rails_helper'
require 'timecop'

RSpec.describe Eia::Generation do
  subject { Eia::Generation }

  describe :cli do
    around(:example) { |ex| VCR.use_cassette('eia_generation_BANC_2019-07-25_2019-07-26', &ex) }
    it "calls Out::Generation.run with expected data" do
      expect(Out::Generation).to receive(:run) do |data, from, to, source_id|
        expect(data.length).to eq(98)  # Specific length for 2-day BANC data
        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source_id).to eq('eia')
        # Validate no excessively high gas values
        gas_values = data.select { |d| d[:production_type] == 'fossil_gas' }.map { |d| d[:value] }
        expect(gas_values).not_to include(a_value > 400000000)
      end
      subject.cli(['2019-07-25', '2019-07-26', 'BANC'])
    end
  end


end

RSpec.describe Eia::Load do
  subject { Eia::Load }

  describe :cli do
    around(:example) { |ex| VCR.use_cassette('eia_load_parsers_each', &ex) }
    it "calls Out::Load.run with expected data" do
      expect(Out::Load).to receive(:run) do |data, from, to, source_id|
        expect(data.length).to eq(1673)  # Specific length for 2-day load data
        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source_id).to eq('eia')
      end
      subject.cli(['2023-01-01', '2023-01-02'])
    end
  end
end

RSpec.describe Eia::Interchange do
  subject { Eia::Interchange }

  describe :cli do
    around(:example) { |ex| VCR.use_cassette('eia_interchange', &ex) }
    it "calls Out::Transmission.run with expected data" do
      expect(Out::Transmission).to receive(:run) do |data, from, to, source_id|
        expect(data.length).to be > 0
        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source_id).to eq('eia')
      end
      subject.cli(['2024-01-01', '2024-01-02', 'CISO'])
    end
  end
end
