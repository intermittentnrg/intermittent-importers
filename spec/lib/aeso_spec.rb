require 'spec_helper'

RSpec.describe Aeso::Generation do
  subject { Aeso::Generation }
  let :csv do
    File.read 'spec/fixtures/aeso-csdreport.csv'
  end

  describe :cli do
    it do
      expect(Generation).to receive(:upsert_all)
      #puts csv.inspect
      subject.new(csv).process
    end
  end

  describe '#points_generation' do
    it "has correct generation" do
      expect(Out2::Generation).to receive(:run).with(array_including(hash_including(production_type: 'hydro', value: 118000)), anything, anything, 'aeso')
      subject.new(csv).process
    end
  end
end
