#!/usr/bin/env ruby
require './environment'

class MIMSY < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :haml, :format => :html5
  set :public_folder, 'public'

  register Sinatra::ConfigFile
  config_file File.join(root, 'config.yml')

  helpers Sinatra::ContentFor
  helpers Sinatra::Mimsy::Helpers

  register Sinatra::Mimsy::Routing::Main
  register Sinatra::Mimsy::Model::Initialize

  run! if app_file == $0
end