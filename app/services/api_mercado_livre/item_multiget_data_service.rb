require 'rest-client'
require 'json'
require 'pp'

# ML Api
module ApiMercadoLivre
  # Multiget com múltiplos números de itens selecionando apenas os campos de interesse.
  # https://developers.mercadolivre.com.br/pt_br/itens-e-buscas
  # Utiliza a função Multiget para melhorar a interação com os recursos de itens e users e poder
  # acessar assim um máximo de 20 resultados com uma única chamada.
  class ItemMultigetDataService < ApplicationService
    attr_accessor :item

    def initialize(all_items_ids_array, seller)
      @all_items_ids_array = all_items_ids_array
      @seller = seller
    end

    def call
      multiget_items
    end

    def multiget_items
      resp = []
      urls_list.each do |url|
        resp.concat(JSON.parse(RestClient.get(url, auth_header)))
      end
      resp # a list of hashes
    end

    def urls_list
      url_list = []
      @all_items_ids_array.each_slice(20) do |batch|
        url = 'https://api.mercadolibre.com/items?ids='
        batch.each do |item_id|
          url.concat("#{item_id},")
        end
        url_list.push(url[0..-2])
      end
      url_list
    end

    def auth_header
      ApiMercadoLivre::AuthenticationService.call(@seller)
      { 'Authorization' => "Bearer #{@seller.access_token}" }
    end
  end
end

#items_ids = Item.where(seller_id: Seller.first.ml_seller_id).pluck(:ml_item_id)
#ApiMercadoLivre::ItemMultigetSpecificDataService.call(items_ids, Seller.first)
