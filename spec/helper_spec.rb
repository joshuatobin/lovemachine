ENV['RACK_ENV'] = 'test'
ENV['DATABASE_URL'] = 'postgres:///lovemachine-test'
require 'minitest/autorun'
require 'minitest/spec'
require 'minitest/mock'
require 'rack/test'

$LOAD_PATH << File.expand_path('../lib', __FILE__)

module LoveLachine
  def valid_key?
    true
  end
end
