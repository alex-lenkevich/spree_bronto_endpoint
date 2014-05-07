require_relative '../../model/hooks_helper'

HooksHelper.class_eval do

  def send_email (request)
    data = (get_request_data request)
    begin
      # preparing data
      email_data = required(data, :email)
      template = required(email_data, :template)

      #getting message id from Bronto by id from request
      bronto_api = get_bronto data
      message_id = bronto_api.get_message_id(template)
      if message_id.nil? # if message not found - return error
        return {:data => data, :code => 500, :message => "Can't find message template with name \"#{template}\". You have to create a message with this name for sending transactional emails with bronto"}
      end

      #get contact by email or create new with this email
      contact_id = bronto_api.get_contact_by_email(required(email_data, :to), true)

      #send email
      email_object = @converter.send_email(email_data, message_id, contact_id)
      result = bronto_api.add_deliveries email_object

      #return result of sending
      if result[:is_error]
        return {:data => data, :code => 500, :message => 'Bronto Error Code ' + result[:error_code] + ': ' + result[:error_string]}
      else
        return {:data => data, :code => 200, :message => 'Message sent success.'}
      end
    rescue Exception => e
      return {:data => data, :code => 500, :message => e.message}
    end
  end

  def add_to_list (request)
    data = (get_request_data request)
    begin
      #getting message id from Bronto by id from request
      bronto_api = get_bronto data

      #get contact by email or create new with this email
      list = data.parameters[:list_id]
      list = required(data, :list_id) if list.nil?
      # list_id = bronto_api.get_list_id list
      result = bronto_api.add_to_list(list, data.member.email)

      #return result of sending
      if result[:is_error] && result[:error_code] != '506'
        return {:data => data, :code => 500, :message => 'Bronto Error Code ' + result[:error_code] + ': ' + result[:error_string]}
      else
        return {:data => data, :code => 200, :message => 'Contact added to list successful.'}
      end
    rescue Exception => e
      return {:data => data, :code => 500, :message => e.message}
    end
  end

  def remove_from_list (request)
    data = (get_request_data request)
    begin
      #getting message id from Bronto by id from request
      bronto_api = get_bronto data

      #get contact by email or create new with this email
      list = data.parameters[:list_id]
      list = required(data, :list_id) if list.nil?
      result = bronto_api.remove_from_list(list, data.member.email)

      #return result of sending
      if result[:is_error] && result[:error_code] != '506'
        return {:data => data, :code => 500, :message => 'Bronto Error Code ' + result[:error_code] + ': ' + result[:error_string]}
      else
        return {:data => data, :code => 200, :message => 'Contact removed from list successful.'}
      end
    rescue Exception => e
      return {:data => data, :code => 500, :message => e.message}
    end
  end

  def remove_from_all_lists (request)
    data = (get_request_data request)
    begin
      #getting message id from Bronto by id from request
      bronto_api = get_bronto data

      #get contact by email or create new with this email
      lists = bronto_api.get_all_lists
      result = bronto_api.remove_from_list(lists, data.member.email)

      #return result of sending
      if !result.nil? && result[:is_error] && result[:error_code] != '506'
        return {:data => data, :code => 500, :message => 'Bronto Error Code ' + result[:error_code] + ': ' + result[:error_string]}
      else
        return {:data => data, :code => 200, :message => 'Contact removed from list successful.'}
      end
    rescue Exception => e
      puts e
      return {:data => data, :code => 500, :message => e.message}
    end
  end

end