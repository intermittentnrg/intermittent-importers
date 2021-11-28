require './spec/spec_helper'

RSpec.describe SvkMimer::Generation do
  describe 'SE4 2021-01-01' do
    subject do
      VCR.use_cassette("svk_mimer_se4") do
        SvkMimer::Generation.new area: :SN4, production: 'VI', from: '2021-01-01', to: '2021-01-02'
      end
    end
    it { expect(subject.points).to have_at_least(1).items }
  end
end
