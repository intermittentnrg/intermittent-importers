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

RSpec.describe Eskom::DataRequest do
  subject { Eskom::DataRequest.new }

  describe '#initialize' do
    it 'creates a Faraday connection' do
      expect(subject.instance_variable_get(:@conn)).to be_a(Faraday::Connection)
    end
  end

  describe '#submit_request' do
    let(:form_html) { File.read('spec/fixtures/eskom-datarequest.html') }
    let(:options) do
      {
        first_name: 'John',
        last_name: 'Doe',
        email: 'john@example.com',
        institution: 'Test Institute',
        purpose: 'Test purposes',
        start_date: '2023-01-01',
        end_date: '2023-01-31'
      }
    end

    before do
      allow(Faraday).to receive(:get).and_return(double(success?: true, body: form_html))
    end

    it 'submits form data with all required checkboxes' do
      stub_request(:post, %r{/cf-api/})
        .to_return(status: 200, body: '{"success":true}')

      response = subject.submit_request(options)

      expect(response.status).to eq(200)

      assert_requested(:post, %r{/cf-api/}) do |req|
        body = URI.decode_www_form(req.body).to_h

        checkboxes_on = body.select { |k, v| v == 'on' }

        expect(checkboxes_on.size).to be >= 16, "Expected at least 16 checkboxes to be submitted, got #{checkboxes_on.size}"

        expect(body['fld_8510825']).to eq('John')
        expect(body['fld_9768035']).to eq('Doe')
        expect(body['fld_2337893']).to eq('john@example.com')
        expect(body['fld_7053797']).to eq('john@example.com')
        expect(body['fld_2546748']).to eq('Test Institute')
      end
    end
  end

  describe '.cli' do
    it 'submits default request with no arguments' do
      allow(Date).to receive(:today).and_return(Date.new(2023, 6, 15))
      mock_request = double('request', submit_request: double('response', status: 200, body: '{"success":true}'))
      allow(Eskom::DataRequest).to receive(:new).and_return(mock_request)

      expect(mock_request).to receive(:submit_request).with(
        hash_including(
          start_date: '2023-05-01',
          end_date: '2023-05-31'
        )
      )

      described_class.cli([])
    end
  end
end
