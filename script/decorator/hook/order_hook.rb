require_relative '../../controller/api'

API.class_eval do

  post '/add_order' do
    return send_responce @helper.add_update_order request
  end

  post '/update_order' do
    return send_responce @helper.add_update_order request
  end

end