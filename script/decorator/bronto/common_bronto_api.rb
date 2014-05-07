require_relative '../../model/bronto_api'

BrontoAPI.class_eval do

  def get_field_id(name)
    puts "get_field_id #{name}"
    body = @client.call(:read_fields, :soap_header => soup_header(@session), message: {
        :filter => {:name => {
            :operator => 'EqualTo',
            :value => name
        }},
    }).body
    puts body
    ret_val = body[:read_fields_response][:return]
    raise "Unknown customer field: #{name}" if ret_val.nil? || ret_val[:id].nil?
    ret_val[:id]
  end

end