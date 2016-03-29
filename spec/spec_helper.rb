require 'rack/test'
require_relative '../application.rb'

module RSpecMixin
  include Rack::Test::Methods
  def app() MIMSY end
end

RSpec.configure { |c| c.include RSpecMixin }