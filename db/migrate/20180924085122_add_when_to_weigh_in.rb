class AddWhenToWeighIn < ActiveRecord::Migration[5.2]
  def change
    add_column :weigh_ins, :when, :datetime, null: :false
  end
end
