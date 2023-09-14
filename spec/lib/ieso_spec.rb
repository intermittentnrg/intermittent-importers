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
