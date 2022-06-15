require 'rest-client'
require 'json'
require 'pp'

# ML Api
module DbPopulate
  # faz o update da base de dado de acordo com a API do ML
  class UpdateItemsTableService < ApplicationService
    def call
      all_sellers
    end

    def all_sellers
      Seller.all.each do |seller|
        items_ids = ApiMercadoLivre::AllSellerItemsService.call(seller)
        all_items_raw = ApiMercadoLivre::ItemMultigetDataService.call(items_ids, seller)
        all_items_raw.each do |parsed_item|
          populate_db(parsed_item, seller)
        end
      end
    end

    def populate_db(parsed_item, seller)
      attributes = item_attributes(parsed_item)
      begin
        item = Item.find(attributes[:ml_item_id])
        item.update(attributes)
        updates_hash = item.previous_changes
        DbPopulate::UpdateEventTrackService.call(item, updates_hash) unless item.previous_changes.empty?
      rescue ActiveRecord::RecordNotFound
        seller.items.create(attributes)
        nil
      end
    end

    def item_attributes(parsed_item)
      {
        ml_item_id: parsed_item['body']['id'],
        title: parsed_item['body']['title'],
        price: parsed_item['body']['price'],
        base_price: parsed_item['body']['base_price'],
        available_quantity: parsed_item['body']['available_quantity'],
        sold_quantity: parsed_item['body']['sold_quantity'],
        logistic_type: parsed_item['body']['shipping']['logistic_type']
      }
    end
  end
end
