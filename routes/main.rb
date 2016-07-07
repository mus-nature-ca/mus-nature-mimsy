# encoding: utf-8

module Sinatra
  module Mimsy
    module Routing
      module Main

        def self.registered(app)

          app.get '/' do
            haml :home
          end

          app.get '/catalog/:id' do
            int = params[:id].is_i? ? params[:id].to_i : nil
            @result = Catalog.where("mkey = ? OR id_number = ?", int, params[:id]).first rescue not_found
            haml :basic_grid
          end

          models = ActiveRecord::Base.descendants
          models.each do |model|
            app.get "/#{model.name.underscore}/:id" do
              @result = model.find(params[:id])
              haml :basic_grid
            end
          end

          app.get '/person/:id' do
            @result = Person.find(params[:id])
            haml :basic_grid
          end

          app.get '/taxon/:id' do
            @result = Taxon.find(params[:id])
            haml :basic_grid
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