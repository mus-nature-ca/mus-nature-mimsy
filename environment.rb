ENV['NLS_LANG'] = "AMERICAN_CANADA.AL32UTF8"

require 'bundler'
require 'ostruct'
require 'logger'
require 'active_record'
require 'active_record/connection_adapters/oracle_enhanced_adapter'
require 'composite_primary_keys'
require 'active_support/all'
require 'active_support/concern'
require 'rest_client'
require 'json'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/content_for'
require 'sinatra/config_file'
require 'yaml'
require 'biodiversity'
require 'thin'
require 'require_all'
require 'uri'
require 'ruby-progressbar'
require 'byebug'
require 'csv'
require 'date'
require 'zip'

require_all 'lib'
require_all 'helpers'
require_all 'routes'

register Sinatra::ConfigFile
config_file File.join(File.dirname(__FILE__), 'config.yml')

require_relative 'models/initialize'
register Sinatra::Mimsy::Model::Initialize