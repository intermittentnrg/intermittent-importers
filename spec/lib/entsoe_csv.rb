require './spec/spec_helper'

RSpec.describe EntsoeCSV::GenerationCSV do
  describe 'zip' do
    subject(:e) do
      EntsoeCSV::GenerationCSV.new('2023_09_ActualGenerationOutputPerGenerationUnit_16.1.A.zip')
    end
    before do
      expect(File).to receive(:mtime) { nil }

      zip_file = double('zip_file')
      expect(Zip::File).to receive(:open) { zip_file }
      expect(zip_file).to receive(:first) { zip_file }
      expect(zip_file).to receive(:get_input_stream) { zip_file }
      expect(zip_file).to receive(:gets).and_return("\n", nil)

      expect(DataFile).to receive(:upsert)
    end
    it { e.process }
  end
end
