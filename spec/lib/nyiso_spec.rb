# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Nyiso::Generation do
  subject { Nyiso::Generation }

  describe :cli do
    describe 'daily csv', :vcr do
      around(:example) { |ex| VCR.use_cassette('nyiso_generation', &ex) }

      it 'fetches daily csv' do
        Timecop.travel('2026-02-27') do
          expect(Out::Generation).to receive(:run) do |points, from, to, source|
            expect(points.length).to be > 1183
            expect(from).to be_a(Time)
            expect(to).to be_a(Time)
            expect(source).to eq('nyiso')

            point = points.first
            expect(point).to have_key(:time)
            expect(point).to have_key(:country)
            expect(point).to have_key(:production_type)
            expect(point).to have_key(:value)

            expect(point[:country]).to eq('US-NY')
            expect(point[:value]).to be_a(Numeric)
            expect(point[:time]).to be_a(Time)
            expect(point[:production_type]).to be_a(String)
          end
          subject.cli([Date.today.to_s])
        end
      end
    end

    describe 'monthly zip', :vcr do
      around(:example) { |ex| VCR.use_cassette('nyiso_generation_monthly', &ex) }

      it 'fetches monthly zip for previous month' do
        Timecop.travel('2026-03-02') do
          expect(Out::Generation).to receive(:run) do |points, _from, _to, source|
            expect(points.length).to be > 0
            expect(source).to eq('nyiso')
          end
          subject.cli([Date.new(2026, 2, 1).to_s])
        end
      end
    end
  end
end
