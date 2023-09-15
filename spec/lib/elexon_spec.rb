require 'spec_helper'

RSpec.describe Elexon::Generation do
  subject { Elexon::Generation }
  describe :cli
end

RSpec.describe Elexon::Fuelinst do
  subject { Elexon::Fuelinst }
  describe :cli
end

RSpec.describe Elexon::Load do
  subject { Elexon::Load }
  describe :cli
end

RSpec.describe Elexon::Unit do
  subject { Elexon::Unit }
  let(:unit_id) { 'HYWDW-1' }
  describe :cli do
    context 'with date range and unit' do
      let(:args) { ['2023-01-01', '2023-01-02', unit_id] }
      around(:example) { |ex| VCR.use_cassette('elexon_unit_hywind', &ex) }
      it do
        expect(::GenerationUnit).to receive(:upsert_all)
        subject.cli(args)
      end
    end
  end

  let(:current_time) { Time.new(2016, 12, 5, 12) }
  describe :refresh_to do
    around(:example) { |ex| Timecop.freeze(current_time, &ex) }
    it do
      expect(subject.refresh_to).to eq Time.new(2016,11,28,12)
    end
  end

  describe :parsers_each do
    around(:example) { |ex| Timecop.freeze(current_time, &ex) }
    before do
      unit = Unit.find_by!(internal_id: unit_id)
      GenerationUnit.create(unit:, time:, value: 100)
    end

    # The SAA performs the II run 5 Working Days after the actual date
    # so the most recent data shown on this page will be for a date almost a week ago.
    # For example on 05 December 2016 users will be able to access data up to 27 November 2016.
    context "does nothing if data is fresh" do
      let(:time) { Time.new(2026,11,27) }
      it do
        expect(Elexon::Unit).not_to receive(:new)
        expect { |b|
          subject.parsers_each(&b)
        }.not_to yield_with_args
      end
    end

    context "skips last 4 business days" do
      let!(:parser) { double('Elexon::Unit') }
      let(:time) { Time.new(2016,11,27) }
      it do
        parser = double('Elexon::Unit')
        expect(Elexon::Unit).to receive(:new).with(Time.new(2016,11,27), unit_id) { parser }
        expect(Elexon::Unit).to receive(:new).with(Time.new(2016,11,28), unit_id) { parser }
        expect { |b|
          subject.parsers_each(&b)
        }.to yield_successive_args(parser, parser)
      end
    end
  end

  # TODO The units for generation data before the 10th July 2015 were expressed in MWh instead of MW. As a result, generation data published after 9th July was increased by a factor of 2 to account for the unit change from MWh to MW.
end
