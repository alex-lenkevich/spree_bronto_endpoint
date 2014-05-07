module Util
  def required(data, key)
    value = data[key]
    raise "#{key} are required" if value.nil?
    value
  end
end