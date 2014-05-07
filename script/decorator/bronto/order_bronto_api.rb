require_relative '../../model/bronto_api'

BrontoAPI.class_eval do

  def add_update_order (data)
    puts 'add_update_order (', data.to_json, ")\n"
    response = @client.call(:add_or_update_orders, :soap_header => soup_header(@session), message: {:orders => data})
    get_results response.body[:add_or_update_orders_response]
  end

end