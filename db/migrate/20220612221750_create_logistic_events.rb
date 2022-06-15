class CreateLogisticEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :logistic_events do |t|
      t.string :new_logistic
      t.string :old_logistic
      t.datetime :change_time
      t.timestamps
      t.belongs_to :item
    end
  end
end
