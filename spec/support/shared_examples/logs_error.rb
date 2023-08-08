RSpec.shared_examples "logs error" do |parameter|
  it "logs error" do
    logger = double("logger")
    allow(Validate).to receive(:logger) { logger }
    expect(logger).to receive(:warn).with("skipped invalid #{parameter}", anything).at_least(:once)
    e.send "points_#{parameter}"
  end
end
