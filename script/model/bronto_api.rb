require 'savon'

class BrontoAPI

  def initialize (token)
    @client = Savon.client(ssl_verify_mode: :none,
                           wsdl: 'https://api.bronto.com/v4?wsdl',
                           log_level: :debug,
                           log: true,
                           namespace_identifier: :v4,
                           env_namespace: :soapenv)

    @session = @client.call(:login, message: {:api_token => token}).body[:login_response][:return]

  end


  def soup_header(session_id)
    { :'v4:sessionHeader' => {:session_id => session_id }}
  end

  def get_results(body)
    body[:return][:results]
  end

end