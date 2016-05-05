# encoding: utf-8

module Sinatra
  module Mimsy
    module Model
      module Initialize

        def self.registered(app)
          ActiveRecord::Base.establish_connection(
            :adapter => app.settings.adapter,
            :database =>  app.settings.database,
            :host => app.settings.host,
            :username => app.settings.username,
            :password => app.settings.password
          )
          require_all 'models'
          ActiveRecord::Base.class_eval do
            include ModelUtility
          end
        end

        ActiveSupport.on_load(:active_record) do
          ActiveRecord::ConnectionAdapters::OracleEnhancedAdapter.class_eval do
            # true and false will be stored as 'Y' and 'N'
            self.emulate_booleans_from_strings = true
          end
        end

        ActiveSupport::Inflector.inflections do |inflect|
          inflect.irregular 'accessory', 'accessories'
        end

        ActiveSupport::Inflector.inflections do |inflect|
          inflect.irregular 'dispatch', 'dispatches'
        end

        ActiveSupport::Inflector.inflections do |inflect|
          inflect.irregular 'entry', 'entries'
        end

        ActiveSupport::Inflector.inflections do |inflect|
          inflect.irregular 'loss', 'losses'
        end

        ActiveSupport::Inflector.inflections do |inflect|
          inflect.irregular 'medium', 'media'
        end

        ActiveSupport::Inflector.inflections do |inflect|
          inflect.irregular 'person', 'people'
        end

        ActiveSupport::Inflector.inflections do |inflect|
          inflect.irregular 'taxon', 'taxa'
        end

      end
    end
  end
end