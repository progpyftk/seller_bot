class Item < ApplicationRecord
  self.primary_key = 'ml_item_id'
  belongs_to :seller

end
