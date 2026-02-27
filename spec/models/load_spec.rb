require 'rails_helper'

RSpec.describe Load do
  describe '.enable_compression_policy!' do
    it 'executes SQL to enable compression policy' do
      expect(Load.connection).to receive(:execute).with(/alter_job.*scheduled => true/)
      Load.enable_compression_policy!
    end
  end

  describe '.disable_compression_policy!' do
    it 'executes SQL to disable compression policy' do
      expect(Load.connection).to receive(:execute).with(/alter_job.*scheduled => false/)
      Load.disable_compression_policy!
    end
  end

  describe '#inspect' do
    let(:area) { Area.find_by!(code: 'AT', source: 'entsoe') }

    it 'formats large values in GW' do
      load = Load.create!(area: area, time: Time.now, value: 1_500_000)
      expect(load.inspect).to match(/1\.5 GW/)
    end

    it 'formats medium values in MW' do
      load = Load.create!(area: area, time: Time.now, value: 1500)
      expect(load.inspect).to match(/1\.5 MW/)
    end

    it 'formats small values in kW' do
      load = Load.create!(area: area, time: Time.now, value: 500)
      expect(load.inspect).to match(/500 kW/)
    end

    it 'includes area_id, time, and formatted value' do
      load = Load.create!(area: area, time: Time.now, value: 1001)
      inspect_string = load.inspect

      expect(inspect_string).to match(/area_id: \d+/)
      expect(inspect_string).to match(/time: \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}/)
      expect(inspect_string).to match(/value: 1\.001 MW/)
    end
  end
end
