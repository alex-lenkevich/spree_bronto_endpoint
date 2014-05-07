require 'json'
require 'hashie'
require_relative 'bronto_api'
require_relative 'util'
require_relative 'converter'

class HooksHelper

  include Util

  def initialize
    @converter = Converter.new
  end

  def get_request_data (request)
    body = ''
    request.body.each{|string|
      body += string
    }
    data = JSON.parse(body)
    puts 'Request data ', data.to_s, "\n"
    Hashie::Mash.new data
  end

  def get_bronto(data)
    BrontoAPI.new get_bronto_auth_token data
  end

  def get_bronto_auth_token(data)
    raise 'addition parameters are required (api_token)' if data.parameters.nil? || data.parameters.api_token.nil?
    data.parameters.api_token
  end

  # def required(data, key)
  #
  # end

end