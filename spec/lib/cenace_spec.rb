require 'spec_helper'

RSpec.describe Cenace do
  let(:cenace) do
    instance = described_class.allocate
    instance.instance_variable_set(:@r, [])
    instance
  end

  describe '#validate_zip' do
    let(:zip_file) { Zip::File.open_buffer(zip_body) }
    let(:zip_body) { create_zip_file("", csv_filename) }

    describe 'valid CSV file' do
      let(:expected_date) { Date.new(2021, 9, 1) }
      let(:csv_filename) { "Generacion Liquidada_L0 SEN septiembre 2021 v2021 10 14_05 00 01.csv" }
      it 'passes validation for valid CSV files' do
        expect { cenace.send(:validate_zip, zip_file, expected_date) }.not_to raise_error
      end
    end

    describe '2025-12 ZIP contains 2025-11 CSV' do
      let(:csv_filename) { "Generacion Liquidada_L0 SEN noviembre 2025 v2025 12 14_05 00 01.csv" }
      let(:expected_date) { Date.new(2025, 12, 1) }
      it 'fails validation for mismatched month' do
        expect { cenace.send(:validate_zip, zip_file, expected_date) }.to raise_error(/Month mismatch/)
      end
    end
  end

  describe '#best_entry' do
    it 'selects the lexicographically largest filename' do
      entries = [
        'Generacion Liquidada_L0 SEN septiembre 2021 v2021 10 14_05 00 01.csv',
        'Generacion Liquidada_L1 SEN septiembre 2021 v2021 11 25_05 05 01.csv',
        'Generacion Liquidada_L2 SEN septiembre 2021 v2022 01 20_05 10 01.csv',
        'Generacion Liquidada_L3 SEN septiembre 2021 v2022 05 05_05 15 01.csv'
      ]

      zip_body = Zip::OutputStream.write_buffer(StringIO.new) do |zio|
        entries.each do |filename|
          zio.put_next_entry(filename)
          zio.write("Fake CSV content for #{filename}")
        end
      end

      zip_file = Zip::File.open_buffer(zip_body.string)
      best = cenace.send(:best_entry, zip_file)

      expect(best.name).to eq('Generacion Liquidada_L3 SEN septiembre 2021 v2022 05 05_05 15 01.csv')
    end
  end
end
