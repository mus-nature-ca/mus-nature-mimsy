ENV['NLS_LANG'] = "AMERICAN_CANADA.AL32UTF8"

require 'bundler'
require 'ostruct'
require 'logger'
require 'active_record'
require 'active_record/connection_adapters/oracle_enhanced_adapter'
require 'active_support/all'
require 'rest_client'
require 'json'
require 'sanitize'
require 'htmlentities'
require 'tilt/haml'
require 'tilt/sass'
require 'sinatra'
require 'sinatra/base'
require 'sinatra/content_for'
require 'sinatra/config_file'
require 'yaml'
require 'biodiversity'
require 'chronic'
require 'thin'
require 'biodiversity'
require 'require_all'
require 'nokogiri'
require 'uri'
require 'net/http'
require 'progressbar'
require 'byebug'
require 'csv'
require 'geo_point'

require_all 'lib'
require_all 'helpers'
require_all 'routes'
require_all 'models'

register Sinatra::ConfigFile
config_file File.join(File.dirname(__FILE__), 'config.yml')

register Sinatra::Mimsy::Model::Initialize