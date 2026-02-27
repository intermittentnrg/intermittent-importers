# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Validate do
  let(:area) { Area.find_by!(code: 'CAISO', source: 'caiso') }
  let(:gen_rules) do
    { 'CAISO' => { 'solar' => { min: 0, max: 1000 } } }.with_indifferent_access
  end
  let(:load_rules) do
    { 'CAISO' => { min: 1000, max: 10_000 } }.with_indifferent_access
  end

  describe '.validate_generation' do
    it 'filters out values outside the specified range' do
      points = [
        { country: 'CAISO', production_type: 'solar', value: 500, time: Time.now },
        { country: 'CAISO', production_type: 'solar', value: 1000, time: Time.now },
        { country: 'CAISO', production_type: 'solar', value: -100, time: Time.now }
      ]

      result = described_class.validate_generation(points, gen_rules)
      expect(result).to have(1).item
      expect(result.first[:value]).to eq(500)
    end
  end

  describe '.validate_load' do
    it 'filters out load values outside the specified range' do
      points = [
        { country: 'CAISO', value: 5000, time: Time.now },
        { country: 'CAISO', value: 500, time: Time.now },
        { country: 'CAISO', value: 10_000, time: Time.now }
      ]

      result = described_class.validate_load(points, load_rules)
      expect(result).to have(1).item
      expect(result.first[:value]).to eq(5000)
    end
  end
end
