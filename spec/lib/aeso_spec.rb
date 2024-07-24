require 'spec_helper'

RSpec.describe Aeso::Generation do
  subject { Aeso::Generation }
  let :csv do
    <<-EOF
Current Supply Demand Report\r
\r
\r
"Last Update : May 10, 2024 16:19"\r
\r
"Alberta Total Net Generation","10597"\r
\r
"HYDRO","894","118","182"\r
\r
"British Columbia","642"\r
EOF
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
