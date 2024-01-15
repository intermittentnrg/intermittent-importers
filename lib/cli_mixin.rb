module CliMixin
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
end
