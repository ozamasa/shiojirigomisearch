  module ActiveRecord
  module Validations
    module ClassMethods
      def validates_zenkaku_of(*attr_names)
        configuration = { :on => :save }
        configuration.update(attr_names.extract_options!)

        reg = Regexp.new("^[^ -~｡-ﾟ]*$")
        validates_each(attr_names, configuration) do |record, attr_name, value|
          unless value.blank?
            unless value =~ reg
              record.errors.add(attr_name, :not_a_zenkaku, :default => configuration[:message], :value => value)
            end
          end
        end
      end

      def validates_hankaku_of(*attr_names)
        configuration = { :on => :save }
        configuration.update(attr_names.extract_options!)

        reg = Regexp.new("^[ -~｡-ﾟ]*$")
        validates_each(attr_names, configuration) do |record, attr_name, value|
          unless value.blank?
            unless value =~ reg
              record.errors.add(attr_name, :not_a_hankaku, :default => configuration[:message], :value => value)
            end
          end
        end
      end

      def validates_email_format_of(*attr_names)
        configuration = { :on => :save }
        configuration.update(attr_names.extract_options!)

        reg = Regexp.new("^[a-zA-Z0-9_\.\-]+\@[A-Za-z0-9_\.\-]+\\.[a-z]+$")
        validates_each(attr_names, configuration) do |record, attr_name, value|
          unless value.blank?
            unless value =~ reg
              record.errors.add(attr_name, :not_a_email, :default => configuration[:message], :value => value)
            end
          end
        end
      end

      def validates_tel_format_of(*attr_names)
        configuration = { :on => :save }
        configuration.update(attr_names.extract_options!)

        reg = Regexp.new("[0-9]+-[0-9]+-[0-9]*$")
        validates_each(attr_names, configuration) do |record, attr_name, value|
          unless value.blank?
            unless value =~ reg
              record.errors.add(attr_name, :not_a_tel, :default => configuration[:message], :value => value)
            end
          end
        end
      end

      def validates_date_format_of(*attr_names)
        configuration = { :on => :save }
        configuration.update(attr_names.extract_options!)

        validates_each(attr_names, configuration) do |record, attr_name, value|

          unless value.blank?
            e = false
            begin
              Date.parse(value.to_s)
            rescue => e1
              logger.info(e1)
              e = true
            end

            unless configuration[:format].blank?
              begin
                # for example
                if configuration[:format] == "ymd"
                  a = ParseDate::parsedate(value.to_s)
                  e = false
                  d = Date::exist?(a[0], a[1], a[2])
                  e = true if (d == false or d.blank?)
                elsif configuration[:format] == "ym"
                  e = false
#                  Date.strptime(value,)
                end
              rescue => e2
                logger.info(e2)
                e = true
              end
            end
            record.errors.add(attr_name, :not_a_date, :default => configuration[:message], :value => value) if e
          end
        end
      end

  end
end
end
