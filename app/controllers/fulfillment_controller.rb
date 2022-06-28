require_relative '../services/db_populate/update_items_table_service'

class FulfillmentController < ApplicationController
  def index
    #DbPopulate::UpdateItemsTableService.call
    @items = Item.where(logistic_type: 'fulfillment').where(available_quantity: 0)
    # item = Item.find_by(ml_item_id: "MLB2684961570")
    # pp item
    # ApiMercadoLivre::ChangeAvailableQuantity.call(item, 99)
  end

  def to_increase_stock
    items_without_stock = Item.where.not(logistic_type: 'fulfillment').where(available_quantity: 0)
    @items_need_increase_stock = []
    items_without_stock.each do |item|
      result = LogisticEvent.where(item_id: item.ml_item_id)
                            .where(old_logistic: 'fulfillment')
                            .where(change_time: (Time.now.midnight - 40.day)..(Time.now.midnight + 2.day))
                            .order('change_time').last
      unless result.nil?
        @items_need_increase_stock.push(item)
      end
    end
    @items_need_increase_stock.each {|each| puts each[:ml_item_id]}
  end

  

end
