# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

# warning version_requirements is deprecated
if Gem::VERSION >= "1.3.6"
  module Rails
    class GemDependency
      def requirement
        r = super
        (r == Gem::Requirement.default) ? nil : r
      end
    end
  end
end

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  # config.gem "bj"
  # config.gem "hpricot", :version => '0.6', :source => "http://code.whytheluckystiff.net"
  # config.gem "sqlite3-ruby", :lib => "sqlite3"
  # config.gem "aws-s3", :lib => "aws/s3"

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  # commentout default timezone 
  # config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de
  # set default locale
  config.i18n.default_locale = 'ja'

  # set migration filename
  config.active_record.timestamped_migrations = false

  # set colorize logging
  config.active_record.colorize_logging = false

  # set will_paginate
  config.gem 'mislav-will_paginate', :lib => 'will_paginate', :version => '~> 2.3'

  # set constant values
  # REGEXP_ZENKAKU = /^[^ -~?-ﾟ]*$/       # zenkaku
  # REGEXP_HANKAKU = /^[ -~?-ﾟ]*$/        # hankaku
  # REGEXP_EMAIL   = /^[w.-]+@(?:[w-]+.)+[w-]+$/   # mail
  # REGEXP_ZIP     = /^d{3}-?d{4}$/     # zip
  # REGEXP_TEL     = /^d+-?d+-?d+$/    # tel
  # REGEXP_PASSWORD= /^(?=.{8,})(?=.*[a-zA-Z]+)(?=.*[d]+)[0-9A-Za-z]+$/  # password

  IMAGE_SERVER = 'http://mobile3.portalcms.me/'

  PAGINATE_PER_PAGE = 20

  DISPLAY_TYPE_SIMPLE = 'simple'

  APP_COMPANY = 'しおじりごみサーチβ'
  APP_TITLE   = 'しおじりごみサーチ'
end
