require_relative '../../model/converter'

Converter.class_eval do

  def order (data, contact_id)
    puts data.to_json, "\n"
    products = []
    data[:line_items].each {
        |item| products.push(
          {
              :id => item[:product_id],
              :sku => item[:product_sku],
              :name => item[:name],
              :quantity => item[:quantity],
              :price => item[:price]
          }
      )
    }
    {
        :id => data.id,
        :email => data.email,
        :contactId => contact_id,
        :products => products,
        :orderDate => data.placed_on
    }
  end

end