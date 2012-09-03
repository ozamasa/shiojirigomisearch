module ActiveSupport
  module CoreExtensions
    module Array
      module Conversions

        def to_csv(instance, options = {})
          csv = ApplicationCsv.new
          csv.write(self, instance, options)
        end

      end
    end
  end
end
