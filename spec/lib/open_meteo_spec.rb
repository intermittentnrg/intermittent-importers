require 'spec_helper'

RSpec.describe OpenMeteo do
  subject { OpenMeteo }
  context 'stockholm' do
    let(:latitude) { '52.52' }
    let(:longitude) { '13.41' }
    let(:name) { 'Stockholm' }
    let(:start_date) { '2024-01-01' }
    let(:end_date) { '2024-01-02' }
    let(:hourly) { 'temperature_2m' }
    around(:example) { |ex| VCR.use_cassette 'open_meteo_stockholm', &ex }
    let(:location) { Location.create(point: [latitude, longitude], name:) }
    describe '#points' do
      subject do
        OpenMeteo.new(location, start_date, end_date, hourly)
      end
      it do
        expect(Temperature).to receive :upsert_all
        subject.process
      end
    end
  end
end
