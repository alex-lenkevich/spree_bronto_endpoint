require_relative '../../model/converter'

Converter.class_eval do

  def send_email (data, message_id, contact_id)
    puts data.to_json
    {
        :start => Time.new.strftime('%FT%T%:z'),
        :messageId => message_id,
        :type => 'transactional',
        :fromEmail => data.sender_email,
        :fromName => data.sender_name,
        :replyEmail => data.sender_email,
        :recipients => [{
                            :id => contact_id,
                            :type => 'contact'
                        }],
        :fields => data.variables.map{|key,value| {
            :name => key.to_s,
            :type => 'html',
            :content => value.to_s
        }
        }
    }
  end

end