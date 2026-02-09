# frozen_string_literal: true

require './spec/spec_helper'

RSpec.describe AemoNemMms::Dispatch do
end

RSpec.describe AemoNemMms::RooftopPv do
  describe :cli do
    subject { AemoNemMms::RooftopPv.cli(args) }
    let(:body) do
      <<-CSV
D,ROOFTOP,ACTUAL,2,"2023/09/13 04:30:00",NSW1,0,1,MEASUREMENT,"2023/09/13 04:49:11"
      CSV
    end
    context 'with date range' do
      let(:args) { %w[2023-01-01 2023-02-01] }
      let(:mtime) { Zip::DOSTime.new(2025, 12, 10, 9, 6, 43) }
      let(:zip_body) { create_zip_file(body, 'PUBLIC_DVD_ROOFTOP_PV_ACTUAL_202301010000.zip', mtime) }

      it do
        stub_request(:get, 'https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2023/MMSDM_2023_01/MMSDM_Historical_Data_SQLLoader/DATA/PUBLIC_DVD_ROOFTOP_PV_ACTUAL_202301010000.zip')
          .to_return(body: zip_body.string, headers: { last_modified: 'Wed, 10 Dec 2025 09:06:43 GMT' })

        expect(Generation).to receive(:upsert_all)
        expect(DataFile).to receive(:upsert_all).with(
          array_including(
            hash_including(
              source: 'aemo',
              updated_at: Time.strptime('Wed, 10 Dec 2025 09:06:43 GMT', '%a, %d %b %Y %H:%M:%S GMT')
            )
          ),
          unique_by: %i[source path]
        )
        subject
      end
    end
  end
end

RSpec.describe AemoNemMms::DuDetail do
  describe :cli do
    subject { AemoNemMms::DuDetail }
    let(:body) do
      <<-CSV
\r
I,PARTICIPANT_REGISTRATION,DUDETAIL,3,EFFECTIVEDATE,DUID,VERSIONNO,CONNECTIONPOINTID,VOLTLEVEL,REGISTEREDCAPACITY,AGCCAPABILITY,DISPATCHTYPE,MAXCAPACITY,STARTTYPE,NORMALLYONFLAG,PHYSICALDETAILSFLAG,SPINNINGRESERVEFLAG,AUTHORISEDBY,AUTHORISEDDATE,LASTCHANGED,INTERMITTENTFLAG,SEMISCHEDULE_FLAG,MAXRATEOFCHANGEUP,MAXRATEOFCHANGEDOWN\r
D,PARTICIPANT_REGISTRATION,DUDETAIL,3,"2011/01/18 00:00:00",SNOWYP,1,NLTS3,330,600,N,LOAD,600,SLOW,N,,,DAVIDGA,"2011/01/17 09:41:18","2011/01/17 09:41:20",N,N,120,120
      CSV
    end
    context 'with file.zip' do
      xit
    end

    context 'with date range' do
      let(:args) { %w[2023-01-01 2023-02-01] }
      let(:mtime) { Zip::DOSTime.new(2025, 12, 10, 9, 6, 43) }
      let(:zip_body) { create_zip_file(body, 'PUBLIC_DVD_DUDETAIL_202301010000.zip', mtime) }

      it do
        stub_request(:get, 'https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2023/MMSDM_2023_01/MMSDM_Historical_Data_SQLLoader/DATA/PUBLIC_DVD_DUDETAIL_202301010000.zip')
          .to_return(body: zip_body.string, headers: { last_modified: 'Wed, 10 Dec 2025 09:06:43 GMT' })

        expect(GenerationUnitCapacity).to receive(:upsert_all)
        expect(DataFile).to receive(:upsert_all).with(
          array_including(
            hash_including(
              source: 'aemo',
              updated_at: Time.strptime('Wed, 10 Dec 2025 09:06:43 GMT', '%a, %d %b %Y %H:%M:%S GMT')
            )
          ),
          unique_by: %i[source path]
        )
        subject.cli(args)
      end
    end
  end
end

RSpec.describe AemoNemMms::Scada do
  describe :cli do
    subject { AemoNemMms::Scada }
    let(:body) do
      <<-CSV
D,DISPATCH,UNIT_SCADA,1,"2023/09/13 05:35:00",WDGPH1,0
      CSV
    end

    # doesn't support no arguments

    context 'with file.zip' do
      xit
    end

    context 'with date range' do
      let(:args) { %w[2023-01-01 2023-02-01] }
      let(:mtime) { Zip::DOSTime.new(2025, 12, 10, 9, 6, 43) }
      let(:zip_body) { create_zip_file(body, 'PUBLIC_DVD_DISPATCH_UNIT_SCADA_202301010000.zip', mtime) }

      it do
        stub_request(:get, 'https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/2023/MMSDM_2023_01/MMSDM_Historical_Data_SQLLoader/DATA/PUBLIC_DVD_DISPATCH_UNIT_SCADA_202301010000.zip')
          .to_return(body: zip_body.string, headers: { last_modified: 'Wed, 10 Dec 2025 09:06:43 GMT' })

        expect(GenerationUnit).to receive(:upsert_all)
        expect(DataFile).to receive(:upsert_all).with(
          array_including(
            hash_including(
              source: 'aemo',
              updated_at: Time.strptime('Wed, 10 Dec 2025 09:06:43 GMT', '%a, %d %b %Y %H:%M:%S GMT')
            )
          ),
          unique_by: %i[source path]
        )
        subject.cli(args)
      end
    end
  end
end

RSpec.describe AemoNemMms::Trading do
  describe :cli do
    it do
    end
    it 'iterates a single date' do
      instance = double('AemonNemMms::Trading')

      date = Date.new 2011, 1, 1
      expect(AemoNemMms::Trading).to receive(:new) { instance }
      expect(instance).to receive(:add_date).with(date) { instance }
      expect(instance).to receive(:done!)
      AemoNemMms::Trading.cli(%w[2011-01-01 2011-01-02])
    end
  end
end
