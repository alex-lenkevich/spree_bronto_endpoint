require_relative '../../controller/api'

API.class_eval do

  post '/send_email' do
    return send_responce @helper.send_email request
  end

  post '/add_to_list' do
    return send_responce @helper.add_to_list request
  end

  post '/remove_from_list' do
    return send_responce @helper.remove_from_list request
  end

  post '/remove_from_all_lists' do
    return send_responce @helper.remove_from_all_lists request
  end

end
