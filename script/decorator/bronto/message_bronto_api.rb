require_relative '../../model/bronto_api'

BrontoAPI.class_eval do

  def get_message_id (title)
    puts  'get_message(' + title + ')'
    body = @client.call(:read_messages, :soap_header => soup_header(@session), :message => {
        :filter => {:name => [{:operator => 'EqualTo', :value => title}]},
        :includeContent => false,
        :pageNumber => 1
    }).body
    puts body
    ret_val = body[:read_messages_response][:return]
    ret_val ? ret_val[:id] : nil
  end

  def add_deliveries (data)
    puts 'add_deliveries(' + data.to_json + "\n"
    response = @client.call(:add_deliveries, :soap_header => soup_header(@session), :message=> {:deliveries => data})
    get_results response.body[:add_deliveries_response]
  end

end