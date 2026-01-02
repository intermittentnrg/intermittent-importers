require 'spec_helper'

RSpec.describe OpenMeteo do
  subject { OpenMeteo }
  context 'stockholm' do
    let(:latitude) { '52.52' }
    let(:longitude) { '13.41' }
    let(:name) { 'Stockholm' }
    let(:from) { Chronic.parse('2024-01-01') }
    let(:to) { Chronic.parse('2024-01-02') }
    let(:hourly) { 'temperature_2m' }
    around(:example) { |ex| VCR.use_cassette 'open_meteo_stockholm', &ex }
    let(:location) { Location.create(point: [latitude, longitude], name:) }
    describe '#done!' do
      subject do
        OpenMeteo.new
      end
      it do
        expect(Temperature).to receive :upsert_all
        subject.add_date_range(from, to, location, hourly).done!
      end
    end
  end
end
