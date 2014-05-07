require_relative '../../model/converter'

Converter.class_eval do

  def customer (data, bronto)
    if data.fields.nil?
      fields = []
    else
      fields = data.fields.map{|key,value| {
          :fieldId => (bronto.get_field_id key.to_s),
          :content => value.to_s
      }}
    end
    puts data.to_json, "\n"
    {
        :email => data.email,
        :mobileNumber => data.phone,
        :fields => fields
    }
  end

end