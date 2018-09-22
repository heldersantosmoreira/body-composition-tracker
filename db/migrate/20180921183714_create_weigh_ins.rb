class CreateWeighIns < ActiveRecord::Migration[5.2]
  def change
    create_table :weigh_ins do |t|
      t.float :weight
      t.float :fat
      t.float :muscle
      t.integer :visceral_fat
      t.integer :metabolic_age
      t.float :water

      t.timestamps
    end
  end
end
