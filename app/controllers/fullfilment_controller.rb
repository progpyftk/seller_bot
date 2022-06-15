require_relative '../services/db_populate/update_items_table_service.rb'

class FullfilmentController < ApplicationController
  def index
    # toda vez que alguem visitar essa pagina será feita uma nova busca na API
    DbPopulate::UpdateItemsTableService.call
    @items = Item.where(logistic_type: 'fulfillment').where(available_quantity: 0)
  end
end
