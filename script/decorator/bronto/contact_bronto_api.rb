require_relative '../../model/bronto_api'

BrontoAPI.class_eval do

  def add_update_contact (data)
    puts "add_update_contact (#{data.to_json})"
    response = @client.call(:add_or_update_contacts, :soap_header => soup_header(@session), message: {:contacts => data})
    get_results response.body[:add_or_update_contacts_response]
  end

  def get_contact_by_email (email, create)
    puts 'get_contact_by_email'
    body = @client.call(:read_contacts, :soap_header => soup_header(@session), message: {
        :filter => [:email => {:operator => 'EqualTo', :value => email}],
        :includeLists => false,
        :fields => 'id',
        :pageNumber => 1,
        :includeSMSKeywords => false,
        :includeGeoIPData => false,
        :includeTechnologyData => false,
        :includeRFMData => false
    }).body
    puts body
    ret_val = body[:read_contacts_response][:return]
    if ret_val
      return ret_val[:id]
    elsif create
      return add_update_contact({:email => email})
    end
  end

  def add_to_list(list_name, contact_email)
    puts "add_to_list #{list_name}, #{contact_email}"
    body = @client.call(:add_to_list, :soap_header => soup_header(@session), message: {
        :list => {:name => list_name},
        :contacts => {:email => contact_email}
    }).body
    puts body
    body[:add_to_list_response][:return][:results]
  end

  def remove_from_list(list, contact_email)
    puts "remove_from_list #{list}, #{contact_email}"
    list.each {|list_name|
      body = @client.call(:remove_from_list, :soap_header => soup_header(@session), message: {
          :list => {:name => list_name},
          :contacts => {:email => contact_email}
      }).body
      puts body
      result = body[:remove_from_list_response][:return][:results]
      return result if result[:is_error]
    }
    nil
  end

  def get_list_id(list_name)
    puts "get_list_id #{list_name}"
    body = @client.call(:read_lists, :soap_header => soup_header(@session), message: {
        :filter => {:name => {
            :operator => 'EqualTo',
            :value => list_name
        }},
    }).body
    puts body
    ret_val = body[:read_lists_response][:return]
    return ret_val[:id] if ret_val
  end

  def get_all_lists
    puts 'get_all_lists'
    body = @client.call(:read_lists, :soap_header => soup_header(@session), message: {
        :filter => {},
    }).body
    puts body
    ret_val = body[:read_lists_response][:return]
    return ret_val.map{|val| val[:name]}
  end

end