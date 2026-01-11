require 'rails_helper'
require 'chronic'

RSpec.describe CliMixin2 do
  describe '.Loop' do
    let(:test_class) do
      Class.new do
        include CliMixin2::Loop

        @processed_files = []
        @processed_urls = []

        class << self
          attr_accessor :processed_files, :processed_urls
        end

        def initialize
          @files = []
          @urls = []
        end

        def add_file(file)
          @files << file
          self
        end

        def add_url(url)
          @urls << url
          self
        end

        def done!
          self.class.processed_files ||= []
          self.class.processed_files += @files
          self.class.processed_urls ||= []
          self.class.processed_urls += @urls
        end

        def self.reset
          self.processed_files = []
          self.processed_urls = []
        end

        def self.each
          # Mock the each method to yield some test URLs
          yield "http://example.com/url1"
          yield "http://example.com/url2"
        end
      end
    end

    before(:each) do
      test_class.reset
    end

    it 'processes files when arguments are provided' do
      # Create temporary files
      file1 = Tempfile.new(['test1', '.txt'])
      file2 = Tempfile.new(['test2', '.txt'])

      begin
        test_class.cli([file1.path, file2.path])

        # Check that files were processed
        expect(test_class.processed_files).to contain_exactly(file1.path, file2.path)
        expect(test_class.processed_urls).to be_empty
      ensure
        file1.close
        file2.close
        file1.unlink
        file2.unlink
      end
    end

    it 'calls each and processes URLs when no arguments provided' do
      test_class.cli([])

      # The each method should have been called and processed the mock URLs
      expect(test_class.processed_urls).to contain_exactly("http://example.com/url1", "http://example.com/url2")
      expect(test_class.processed_files).to be_empty
    end
  end

  describe '.Yearly' do
    let(:test_class) do
      Class.new do
        include CliMixin2::Yearly

        @processed_dates = []

        class << self
          attr_accessor :processed_dates
        end

        def initialize(date_or_file)
          @date = date_or_file
        end

        def process
          self.class.processed_dates ||= []
          self.class.processed_dates << @date
        end

        def self.reset_dates
          self.processed_dates = []
        end
      end
    end

    before(:each) do
      test_class.reset_dates
    end

    it 'processes current year when no arguments provided' do
      mock_today = Date.new(2023, 6, 15)
      allow(Date).to receive(:today).and_return(mock_today)

      test_class.cli([])

      # Should process Date.today
      expect(test_class.processed_dates.first).to eq(mock_today)
    end

    it 'processes specific date when one argument provided' do
      test_class.cli(['2023-01-01'])

      expect(test_class.processed_dates).to include(Date.new(2023, 1, 1))
    end

    it 'processes yearly dates when two arguments provided' do
      test_class.cli(['2020-01-01', '2024-01-01'])

      # Should process Jan 1st for each year in the range
      expect(test_class.processed_dates).to include(Date.new(2020, 1, 1))
      expect(test_class.processed_dates).to include(Date.new(2021, 1, 1))
      expect(test_class.processed_dates).to include(Date.new(2022, 1, 1))
      expect(test_class.processed_dates).to include(Date.new(2023, 1, 1))
    end

    it 'processes file content when argument is not a date' do
      file = Tempfile.new(['test', '.txt'])
      begin
        file.write("test content")
        file.rewind

        # Mock Chronic to return nil for non-date strings
        allow(Chronic).to receive(:parse).with(file.path).and_return(nil)

        # Create a test class that can handle file processing
        test_file_class = Class.new do
          include CliMixin2::Yearly

          @processed_count = 0

          class << self
            attr_accessor :processed_count
          end

          def initialize(date_or_file)
            @data = date_or_file
          end

          def process
            self.class.processed_count ||= 0
            self.class.processed_count += 1
          end
        end

        test_file_class.cli([file.path])

        # Should have processed the file
        expect(test_file_class.processed_count).to eq(1)
      ensure
        file.close
        file.unlink
      end
    end
  end
end
