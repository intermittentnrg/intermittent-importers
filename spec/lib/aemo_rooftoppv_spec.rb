require './spec/spec_helper'

RSpec.describe Aemo::RooftopPv do
  it "ignores sattelite records" do
    VCR.use_cassette("aemo_rooftoppv_sattelite") do
      expect(Generation).not_to receive(:upsert_all)
      Aemo::RooftopPv.new("https://nemweb.com.au/Reports/Current/ROOFTOP_PV/ACTUAL/PUBLIC_ROOFTOP_PV_ACTUAL_SATELLITE_20230902183000_0000000396168830.zip").process
    end
  end
  it do
    VCR.use_cassette("aemo_rooftoppv_e2e") do
      expect(FileList).to receive(:create)
      Aemo::RooftopPv.new("https://nemweb.com.au/Reports/Current/ROOFTOP_PV/ACTUAL/PUBLIC_ROOFTOP_PV_ACTUAL_MEASUREMENT_20230902183000_0000000396168829.zip").process
    end
  end
end
RSpec.describe Aemo::RooftopPvArchive do
end
RSpec.describe Aemo::RooftopPvMMS do
end
