require 'rails_helper'

RSpec.describe 'EiaBulk' do
  let(:sample_txt_path) { './spec/fixtures/eia_bulk_sample.txt' }

  describe 'Generation.cli' do
    it 'processes generation data from file' do
      EiaBulk::Generation.cli([sample_txt_path, 'CISO'])
    end
  end

  describe 'Demand.cli' do
    it 'processes demand data from file' do
      EiaBulk::Demand.cli([sample_txt_path, 'CISO'])
    end
  end

  describe 'Interchange.cli' do
    it 'processes interchange data from file' do
      EiaBulk::Interchange.cli([sample_txt_path, 'CISO'])
    end
  end
end
