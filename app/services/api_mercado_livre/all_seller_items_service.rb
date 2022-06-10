require 'rest-client'
require 'json'
require 'pp'

# ML Api
module ApiMercadoLivre
  # authentication service class
  class AllSellerItemsService < ApplicationService
    attr_accessor :seller

    def initialize(seller)
      @seller = seller
      @items = []
    end

    def call
      all_items
    end

    def all_items
      url = "https://api.mercadolibre.com/users/#{@seller.ml_seller_id}/items/search?search_type=scan&limit=100"
      resp = JSON.parse(RestClient.get(url, auth_header))
      # puts resp['results'].length
      @items.concat(resp['results'])
      url = "https://api.mercadolibre.com/users/140329822/items/search?search_type=scan&scroll_id=#{resp['scroll_id']}&limit=100"
      until resp['results'].empty?
        resp = JSON.parse(RestClient.get(url, auth_header))
        # puts resp['results'].length
        @items.concat(resp['results'])
      end
      @items
    end

    def auth_header
      ApiMercadoLivre::AuthenticationService.call(@seller)
      { 'Authorization' => "Bearer #{@seller.access_token}" }
    end
  end
end
