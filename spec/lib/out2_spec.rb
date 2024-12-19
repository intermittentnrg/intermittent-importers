require './spec/spec_helper'

RSpec.describe Out2::Transmission do
  describe 'creates AreasAreas mapping when missing' do
    let(:from) { Time.parse '2024-01-01 00:00' }
    let(:to) { Time.parse '2024-01-01 02:00' }
    let(:from_area) { Area.where(source: 'entsoe', code: 'ES').first }
    let(:to_area) { Area.where(source: 'entsoe', code: 'FI').first }
    let(:from_area_id) { from_area.id }
    let(:to_area_id) { to_area.id }
    let(:source_id) { 'entsoe' }

    it "ćreates AreasArea mapping" do
      expect(AreasArea.where(from_area:, to_area:).count).to equal 0
      data = [
        {
          from_area_id:,
          to_area_id:,
          time: from,
          value: 1000
        }
      ]
      Out2::Transmission.run(data, from, to, source_id)
      expect(AreasArea.where(from_area:, to_area:).count).to equal 1
    end
  end
end
