require 'spec_helper'
require 'timecop'

RSpec.describe Eskom::Demand do
  subject { Eskom::Demand }
  around(:example) { |ex| Timecop.freeze(Time.new(2023,10,1), &ex) }
  let(:body) do
    <<-CSV
DateTimeKey,Residual Forecast,RSA Contracted Forecast,Residual Demand,RSA Contracted Demand\r
2023-10-21 00:00:00,,,20571.907999999999,21781.587\r
CSV
  end
  describe :cli do
    context 'with no arguments' do
      it do
        stub_request(:get, 'https://www.eskom.co.za/dataportal/wp-content/uploads/2023/10/System_hourly_actual_and_forecasted_demand.csv').
          to_return(body:, headers: {'Last-Modified' => 'Mon, 08 Feb 2023 13:36:56 GMT'})
        expect(::Load).to receive(:upsert_all)
        expect(DataFile).to receive(:upsert_all).with(
          array_including(
            hash_including(
              path: 'System_hourly_actual_and_forecasted_demand.csv',
              source: 'eskom',
              updated_at: Time.strptime('Mon, 08 Feb 2023 13:36:56 GMT', Eskom::Base::HTTP_DATE_FORMAT)
            )
          ),
          unique_by: [:source, :path]
        )
        subject.cli([])
      end
    end

    context 'with 404 response' do
      it 'raises EmptyError' do
        stub_request(:get, 'https://www.eskom.co.za/dataportal/wp-content/uploads/2023/10/System_hourly_actual_and_forecasted_demand.csv').
          to_return(status: 404)
        expect { subject.cli([]) }.to raise_error(EmptyError)
      end
    end

    context 'with .csv argument' do
      xit do
        subject.cli(['file.csv'])
      end
    end
  end
end

RSpec.describe Eskom::Generation do
  subject { Eskom::Generation }
  around(:example) { |ex| Timecop.freeze(Time.new(2023,10,1), &ex) }
  let(:body) do
    <<-CSV
Date_Time_Hour_Beginning,Thermal_Gen_Excl_Pumping_and_SCO,Eskom_OCGT_SCO_Pumping,Eskom_Gas_SCO_Pumping,Hydro_Water_SCO_Pumping,Pumped_Water_SCO_Pumping,Thermal_Generation,Nuclear_Generation,International_Imports,Eskom_OCGT_Generation,Eskom_Gas_Generation,Dispatchable_IPP_OCGT,Hydro_Water_Generation,Pumped_Water_Generation,IOS_Excl_ILS_and_MLR,ILS_Usage,Manual_Load_Reduction_MLR,Wind,PV,CSP,Other_RE\r
2023-10-18 00:00:00,18016.901000000002,-3.4260000000000002,-2.1019999999999999,-0.002,-2541.1599999999999,20563.591,888.08299999999997,1080.845,0,0,0,3.0000000000000001E-3,0,0,0,1005.601,677.06500000000005,0,38.942999999999998,32.813000000000002\r
CSV
  end
  describe :cli do
    context 'with no arguments' do
      it do
        stub_request(:get, 'https://www.eskom.co.za/dataportal/wp-content/uploads/2023/10/Station_Build_Up.csv').
          to_return(body:, headers: {'Last-Modified' => 'Mon, 08 Feb 2023 13:36:56 GMT'})
        expect(::Generation).to receive(:upsert_all)
        expect(DataFile).to receive(:upsert_all).with(
          array_including(
            hash_including(
              path: 'Station_Build_Up.csv',
              source: 'eskom',
              updated_at: Time.strptime('Mon, 08 Feb 2023 13:36:56 GMT', Eskom::Base::HTTP_DATE_FORMAT)
            )
          ),
          unique_by: [:source, :path]
        )
        subject.cli([])
      end
    end

    context 'with 404 response' do
      it 'raises EmptyError' do
        stub_request(:get, 'https://www.eskom.co.za/dataportal/wp-content/uploads/2023/10/Station_Build_Up.csv').
          to_return(status: 404)
        expect { subject.cli([]) }.to raise_error(EmptyError)
      end
    end

    context 'with .csv argument' do
      xit do
        subject.cli(['file.csv'])
      end
    end
  end
end
