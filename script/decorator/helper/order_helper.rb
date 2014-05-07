require_relative '../../model/hooks_helper'

HooksHelper.class_eval do

  def add_update_order (request)
    data = (get_request_data request)
    begin
      # prepare data
      order_data = required(data, :order)
      bronto_api = get_bronto data
      contact_id = bronto_api.get_contact_by_email order_data.email, true
      result = bronto_api.add_update_order @converter.order order_data, contact_id
      if result[:is_error]
        return {:data => data, :code => 500, :message => 'Bronto Error Code ' + result[:error_code] + ': ' + result[:error_string]}
      else
        return {:data => data, :code => 200, :message => "Order number #{order_data.id} was #{result[:is_new] ? 'added' : 'updated'}."}
      end
    rescue Exception => e
      puts e.backtrace
      return {:data => data, :code => 500, :message => e.message}
    end
  end

end