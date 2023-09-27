require 'spec_helper'

RSpec.describe ::Generation do
  subject { ::Generation }
  describe :aggregate_to_capture do
    context 'beginning of hour' do
      let(:from) { Time.new(2023,1,1,12,0) }
      let(:to) { Time.new(2023,1,1,12,5) }
      it do
        expect(subject.connection).to receive(:exec_query).with(/g\.time BETWEEN '2023-01-01 12:00:00 \+0000' AND '2023-01-01 13:00:00 \+0000'/)
        subject.aggregate_to_capture(from, to, '1::boolean')
      end
    end
    context 'middle of hour' do
      let(:from) { Time.new(2023,1,1,12,30) }
      let(:to) { Time.new(2023,1,1,12,35) }
      it do
        expect(subject.connection).to receive(:exec_query).with(/g\.time BETWEEN '2023-01-01 12:00:00 \+0000' AND '2023-01-01 13:00:00 \+0000'/)
        subject.aggregate_to_capture(from, to, '1::boolean')
      end
    end
    context 'end of hour' do
      let(:from) { Time.new(2023,1,1,12,55) }
      let(:to) { Time.new(2023,1,1,13,0) }
      it do
        expect(subject.connection).to receive(:exec_query).with(/g\.time BETWEEN '2023-01-01 12:00:00 \+0000' AND '2023-01-01 13:00:00 \+0000'/)
        subject.aggregate_to_capture(from, to, '1::boolean')
      end
    end
  end
end
