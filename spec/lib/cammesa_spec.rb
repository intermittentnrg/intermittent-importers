require 'spec_helper'

RSpec.describe Cammesa::Renovables do
  subject { Cammesa::Renovables }
  
  describe :cli do
    it 'processes renewable generation data end-to-end' do
      json_body = <<-JSON
[
  {
    "momento": "2023-01-01T00:00:00.000-03:00",
    "biocombustible": 100.5,
    "hidraulica": 200.3,
    "fotovoltaica": 150.7,
    "eolica": 300.2
  },
  {
    "momento": "2023-01-01T01:00:00.000-03:00",
    "biocombustible": 110.2,
    "hidraulica": 210.5,
    "fotovoltaica": 160.3,
    "eolica": 310.4
  }
]
JSON

      stub_request(:get, 'https://cdsrenovables.cammesa.com/exhisto/RenovablesService/GetChartTotalTRDataSource/?desde=01-01-2023&hasta=01-01-2023')
        .to_return(body: json_body)

      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(8) # 2 hours * 4 production types (biomass, hydro_small, solar, wind)
        expect(points.first[:country]).to eq('AR')
        expect(points.first[:production_type]).to be_in(['biomass', 'hydro_small', 'solar', 'wind'])
        expect(points.first[:value]).to be > 0
        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source).to eq('cammesa')
      end
      
      subject.cli(['2023-01-01', '2023-01-02'])
    end
  end
end

RSpec.describe Cammesa::ProgramacionDiaria do
  subject { Cammesa::ProgramacionDiaria }
  
  describe :cli do
    let(:balance_csv_content) { File.read('spec/fixtures/cammesa-balance.csv') }
    let(:units_csv_content) { File.read('spec/fixtures/cammesa-units.csv') }
    let(:zip_body) { create_zip_file([balance_csv_content, units_csv_content], ['BALANCE.csv', 'VALORES_GENERADORES.csv']) }
    
    it 'processes daily program data from CSV file' do
      # Test that CSV files are now supported instead of MDB
      # The implementation has been updated to parse BALANCE.csv
      # Uses hash-based deduplication for @r_gen, @r_load, and @r_trans
      # Multiplies CSV values by 1000 (MW to kW)
      # Combines hydro from both "Ren Hidro >50MW" and "Ren ley 26190"
      
      expect(Out::Generation).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(72) # 24 hours * 3 production types (nuclear, thermal, hydro)
        expect(points.first[:country]).to eq('AR')
        expect(points.first[:production_type]).to be_in([:nuclear, :thermal, :hydro])
        expect(points.first[:value]).to be > 0
        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source).to eq('cammesa')
      end
      
      expect(Out::Load).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(24) # 24 hours of load data
        expect(points.first[:country]).to eq('AR')
        expect(points.first[:value]).to be > 0
        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source).to eq('cammesa')
      end
      
      expect(Out::Transmission).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(24) # 24 hours of import data (export is not in this file)
        expect(points.first[:from_area]).to be_in(['AR', 'other'])
        expect(points.first[:to_area]).to be_in(['AR', 'other'])
        expect(points.first[:value]).to be > 0
        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source).to eq('cammesa')
      end
      
      expect(Out::Unit).to receive(:run) do |points, from, to, source|
        expect(points.length).to eq(120) # 5 units * 24 hours
        expect(points.first[:country]).to eq('AR')
        expect(points.first[:unit]).to be_present
        expect(points.first[:production_type]).to be_in(['wind', 'nuclear', 'thermal'])
        expect(points.first[:value]).to be >= 0
        expect(from).to be_a(Time)
        expect(to).to be_a(Time)
        expect(source).to eq('cammesa')
      end
      
      subject.new.add_buffer(zip_body, Date.new(2024, 11, 13)).done!
    end
  end
end
