require 'rest-client'
require 'json'
require 'pp'

# ML Api
module ApiMercadoLivre
  # authentication service class
  class ChangeAvailableQuantity < ApplicationService
    def initialize(item, new_quantity)
      puts "****** initialize ChangeAvailableQuantity *******"
      
      @item = item
      @new_quantity = new_quantity
      pp @item
    end

    def call
      change_quantity
    end

    def change_quantity
      puts @item.seller.access_token
      puts @item.ml_item_id
      headers = { 'Authorization' => "Bearer #{@item.seller.access_token}",
                  'content-type' => 'application/json',
                  'accept' => 'application/json' }
      url = "https://api.mercadolibre.com/items/#{@item.ml_item_id}"
      puts url
      payload = {
        'available_quantity' => @new_quantity,
      }.to_json
      puts headers
      puts '***** response ******'
      puts RestClient.put(url, payload, headers)
    end
  end
end
