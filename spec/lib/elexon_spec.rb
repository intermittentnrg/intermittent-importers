require 'spec_helper'

RSpec.describe Elexon::Generation
RSpec.describe Elexon::Fuelinst
RSpec.describe Elexon::Load
RSpec.describe Elexon::Unit do
  subject { Elexon::Unit }
  describe :cli do
    context 'with date range and unit' do
      let(:unit_id) { 'HYWDW-1' }
      let(:args) { ['2023-01-01', '2023-01-02', unit_id] }
      around(:example) { |ex| VCR.use_cassette('elexon_unit_hywind', &ex) }
      it do
        expect(::GenerationUnit).to receive(:upsert_all)
        subject.cli(args)
      end
    end
  end
end
