require 'sinatra'
require_relative '../../script/model/hooks_helper'

class API < Sinatra::Base

  def initialize
    @helper = HooksHelper.new
    super
  end

  def send_responce(res)
    puts 'Responce code: ', res[:code], 'message: ', res[:message]
    content_type :json
    status res[:code]
    {
        :request_id => res[:data].request_id,
        :summary => res[:message]
    }.to_json
  end
end