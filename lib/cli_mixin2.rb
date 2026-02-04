module CliMixin2
  module Loop
    def self.included(base)
      base.extend ClassMethods
    end
    module ClassMethods
      def cli(args)
        if args.present?
          args.each do |file|
            self.new.add_file(file).done!
          end
        else
          target = self.new
          self.each do |url|
            target.add_url(url)
          end
          target.done!
        end
      end
    end
  end

  module Yearly
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def cli(args)
        if args.length == 1
          from = Chronic.parse(args[0])
          if from
            self.new(from.to_date).process
          else
            self.new(File.open(args[0], 'r')).process
          end
        elsif args.length == 2
          from = Chronic.parse(args[0]).to_date
          to = Chronic.parse(args[1]).to_date
          (from...to).select { |d| d.month==1 && d.day==1 }.each do |year|
            self.new(year).process
          end
        else
          self.new(Date.today).process
        end
      end
    end
  end

  module SnapshotWithDownload
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def cli(args)
        save_zip = args.include?('--download') || args.include?('-d')
        args.reject! { |a| a == '--download' || a == '-d' }

        if args.length != 0
          $stderr.puts "#{$0}"
          $stderr.puts "Use -d or --download to save ZIP files"
          exit 1
        end
        new.add(save_zip).done!
      end
    end
  end

  module DailyWithDownload
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def cli(args)
        save_zip = args.include?('--download') || args.include?('-d')
        args.reject! { |a| a == '--download' || a == '-d' }

        if File.exist?(args.first)
          args.each do |arg|
            new.add_file(arg).done!
          end
        else
          case args.length
          when 1
            date = Chronic.parse(args[0]).to_date
            new.add_date(date, save_zip).done!
          when 2
            from = Chronic.parse(args.shift).to_date
            to = Chronic.parse(args.shift).to_date
            (from...to).each do |date|
              new.add_date(date, save_zip).done!
            end
          end
        end
      end
    end
  end

  module MonthlyWithDownload
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def cli(args)
        save_zip = args.include?('--download') || args.include?('-d')
        args.reject! { |a| a == '--download' || a == '-d' }

        if args.any? && File.exist?(args.first)
          args.each do |file|
            new.add_file(file).done!
          end
        elsif args.length == 1
          date = Chronic.parse(args.shift).to_date
          new.add_date(date, save_zip).done!
        elsif args.length == 2
          from = Chronic.parse(args.shift).to_date
          to = Chronic.parse(args.shift).to_date
          (from..to).each do |date|
            next unless date.day == 1  # Only first day of month
            new.add_date(date, save_zip).done!
          end
        else
          $stderr.puts "#{$0} [file1.zip file2.zip ...] | [date] | [from to]"
          $stderr.puts "Use -d or --download to save ZIP files"
          exit 1
        end
      end
    end
  end
end
