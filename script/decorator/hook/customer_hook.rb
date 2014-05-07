require_relative '../../controller/api'

API.class_eval do

  post '/add_customer' do
    return send_responce @helper.add_update_customer request
  end

  post '/update_customer' do
    return send_responce @helper.add_update_customer request
  end

end