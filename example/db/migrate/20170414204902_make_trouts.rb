class MakeTrouts < ActiveRecord::Migration[5.0]
  def change
    create_table :trouts do |t|
      t.string :name
      t.integer :weight
      t.string :taste
    end
  end
end
