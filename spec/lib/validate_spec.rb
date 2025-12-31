require './spec/spec_helper'

RSpec.describe Validate do
  before(:each) do
    # Create test area with a source that exists in enum but doesn't have specific rules in validate.yaml
    @area = Area.find_or_create_by!(source: 'caiso', code: 'TEST', internal_id: 'TEST', region: 'usa', type: 'zone', enabled: true)

    # Stub the RULES constant directly
    stub_const('Validate::RULES',
      {
        'caiso' => {
          'TEST' => {
            'solar' => { min: 0, max: 1000 }
          }
        }
      }.with_indifferent_access
    )
  end

  describe '.validate_generation' do
    it 'filters out values outside the specified range' do
      points = [
        { country: 'TEST', production_type: 'solar', value: 500, time: Time.now },
        { country: 'TEST', production_type: 'solar', value: 1000, time: Time.now },
        { country: 'TEST', production_type: 'solar', value: -100, time: Time.now }
      ]

      result = described_class.validate_generation(points, 'caiso')
      expect(result).to have(1).item
      expect(result.first[:value]).to eq(500)
    end
  end

  describe '.validate_load' do
    before(:each) do
      # Add load rules to the stubbed RULES
      stub_const('Validate::RULES',
        {
          'caiso' => {
            'TEST' => {
              'solar' => { min: 0, max: 1000 },
              'load' => { min: 1000, max: 10000 }
            }
          }
        }.with_indifferent_access
      )
    end

    it 'filters out load values outside the specified range' do
      points = [
        { country: 'TEST', value: 5000, time: Time.now },
        { country: 'TEST', value: 500, time: Time.now },   # Should be filtered out (min: 1000)
        { country: 'TEST', value: 10000, time: Time.now }  # Should be filtered out (max: 10000, range is exclusive)
      ]

      result = described_class.validate_load(points, 'caiso')
      expect(result).to have(1).item
      expect(result.first[:value]).to eq(5000)
    end
  end

  describe '.validate_data_cli' do
    it 'handles --delete flag' do
      args = ['--delete', 'test_filter']
      expect(described_class).to receive(:validate_data).with(true, ['test_filter'])
      described_class.validate_data_cli(args)
    end

    it 'passes filters without --delete flag' do
      args = ['test_filter']
      expect(described_class).to receive(:validate_data).with(false, ['test_filter'])
      described_class.validate_data_cli(args)
    end
  end
end
