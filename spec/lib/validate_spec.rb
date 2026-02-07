# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe Validate do
  before(:each) do
    @area = Area.find_or_create_by!(source: 'caiso', code: 'TEST', internal_id: 'TEST', region: 'usa', type: 'zone',
                                    enabled: true)
    @gen_rules = {
      'TEST' => { 'solar' => { min: 0, max: 1000 } }
    }.with_indifferent_access
    @load_rules = {
      'TEST' => { min: 1000, max: 10_000 }
    }.with_indifferent_access
  end

  describe '.validate_generation' do
    it 'filters out values outside the specified range' do
      points = [
        { country: 'TEST', production_type: 'solar', value: 500, time: Time.now },
        { country: 'TEST', production_type: 'solar', value: 1000, time: Time.now },
        { country: 'TEST', production_type: 'solar', value: -100, time: Time.now }
      ]

      result = described_class.validate_generation(points, @gen_rules)
      expect(result).to have(1).item
      expect(result.first[:value]).to eq(500)
    end
  end

  describe '.validate_load' do
    it 'filters out load values outside the specified range' do
      points = [
        { country: 'TEST', value: 5000, time: Time.now },
        { country: 'TEST', value: 500, time: Time.now },
        { country: 'TEST', value: 10_000, time: Time.now }
      ]

      result = described_class.validate_load(points, @load_rules)
      expect(result).to have(1).item
      expect(result.first[:value]).to eq(5000)
    end
  end
end
