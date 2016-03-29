# encoding: utf-8

module Sinatra
  module Mimsy
    module Routing
      module Main

        def self.registered(app)

          app.get '/' do
            haml :home
          end

          app.get '/main.css' do
            content_type 'text/css', charset: 'utf-8'
            scss :main
          end

          app.not_found do
            status 404
            haml :oops
          end

        end

      end
    end
  end
end