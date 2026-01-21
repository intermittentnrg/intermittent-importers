require './spec/spec_helper'

RSpec.describe EntsoeFms::Generation do
  describe :refresh do
    let(:file_list_response) do
      {
        'contentItemList' => [
          {
            'name' => 'test_file.zip',
            'lastUpdatedTimestamp' => '2023-01-01T12:00:00Z'
          }
        ]
      }.to_json
    end

    let(:file_content_response) { 'fake zip content' }
    let(:expected_time) { Time.parse('2023-01-01T12:00:00Z') }

    before do
      # Stub the token authentication
      allow(EntsoeFms::Base).to receive(:token).and_return('fake_token')

      # Stub the folder listing API call
      stub_request(:post, 'https://fms.tp.entsoe.eu/listFolder')
        .with(
          body: hash_including(
            path: EntsoeFms::Generation::DIR,
            pageInfo: { pageIndex: 0, pageSize: 5000 }
          )
        )
        .to_return(body: file_list_response, status: 200)

      # Stub the file download API call
      stub_request(:post, 'https://fms.tp.entsoe.eu/downloadFileContent')
        .with(
          body: hash_including(
            folder: EntsoeFms::Generation::DIR,
            filename: 'test_file.zip'
          )
        )
        .to_return(body: file_content_response, status: 200)

      # Stub DataFile.where to return a relation that doesn't exist (so file is processed)
      allow(DataFile).to receive(:where).and_return(double(exists?: false))
    end

    it 'processes files with correct parameters' do
      # Stub the target processor to avoid actual processing
      target_instance = double('EntsoeCsv::Generation')
      expect(EntsoeCsv::Generation).to receive(:new).and_return(target_instance)
      expect(target_instance).to receive(:add_buffer).with(
        kind_of(String),
        'test_file.zip',
        expected_time,
        true
      ).and_return(target_instance)
      expect(target_instance).to receive(:done!)

      # Call the class method
      EntsoeFms::Generation.refresh
    end
  end
end
