require_relative '../../model/hooks_helper'

HooksHelper.class_eval do

  def add_update_customer (request)
    data = (get_request_data request)
    begin

      customer_data = required(data, :customer)
      bronto_api = get_bronto data

      customer = @converter.customer(customer_data, bronto_api)
      result = bronto_api.add_update_contact customer

      if !result[:is_error]
        return {:data => data, :code => 200, :message => "Contact #{result[:is_new] ? 'added' : 'updated'}."}
      elsif result[:error_code] != '319'
        return {:data => data, :code => 500, :message => 'Bronto Error Code ' + result[:error_code] + ': ' + result[:error_string]}
      end


      # Remove phone if it's invalid
      customer.delete(:mobileNumber)
      result = bronto_api.add_update_contact customer

      if result[:is_error]
        return {:data => data, :code => 500, :message => 'Bronto Error Code ' + result[:error_code] + ': ' + result[:error_string]}
      else
        return {:data => data, :code => 200, :message => "Contact #{result[:is_new] ? 'added' : 'updated'}."}
      end

    rescue Exception => e
      puts e.backtrace
      return {:data => data, :code => 500, :message => e.message}
    end
  end

end