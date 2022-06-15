class CreatePriceEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :price_events do |t|
      t.float :new_price
      t.float :old_price
      t.datetime :change_time
      t.belongs_to :item
      t.timestamps
    end
  end
end
