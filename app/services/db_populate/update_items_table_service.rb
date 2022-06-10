require 'rest-client'
require 'json'
require 'pp'

# ML Api
module DbPopulate
  # authentication service class
  class UpdateItemsTableService < ApplicationService
    def call
      puts 'entrei aqui'
      all_sellers
    end

    def all_sellers
      Seller.all.each do |seller|
        items_ids = ApiMercadoLivre::AllSellerItemsService.call(seller)
        all_items_raw = ApiMercadoLivre::ItemMultigetDataService.call(items_ids, seller)
        all_items_raw.each do |item|
          puts 'estou aquiiii'
          populate_db(item, seller)
          puts 'estou aqui'
        end
      end
    end

    def populate_db(item, seller)
      seller.items.create(
        ml_item_id: item['body']['id'],
        title: item['body']['title'],
        price: item['body']['price'],
        base_price: item['body']['base_price'],
        available_quantity: item['body']['available_quantity'],
        sold_quantity: item['body']['sold_quantity'],
        logistic_type: item['body']['shipping']['logistic_type']
      )
    end
  end
end

