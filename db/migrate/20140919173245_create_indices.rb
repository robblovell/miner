class CreateIndices < ActiveRecord::Migration
  def change
    create_table :indices do |t|
      t.integer :miner
      t.string :mode
      t.integer :make
      t.integer :year
      t.integer :model
      t.integer :engine
      t.integer :system
      t.integer :dtc
      t.boolean :complete, default: false

      t.timestamps
    end
  end
end
