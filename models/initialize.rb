# encoding: utf-8
require_relative '../concerns/model_utility'
require_relative '../concerns/oracle_utility'

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
          ActiveRecord::Base.send :include, ModelUtility
          require_all 'models'
        end

        ActiveSupport.on_load :active_record do
          include OracleUtility
        end

        ActiveSupport::Inflector.inflections do |inflect|
          inflect.irregular 'accessory', 'accessories'
          inflect.irregular 'dispatch', 'dispatches'
          inflect.irregular 'entry', 'entries'
          inflect.irregular 'loss', 'losses'
          inflect.irregular 'medium', 'media'
          inflect.irregular 'person', 'people'
          inflect.irregular 'taxon', 'taxa'
        end

      end
    end
  end
end
