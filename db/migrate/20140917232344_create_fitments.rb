class CreateFitments < ActiveRecord::Migration
  def change
    create_table :fitments do |t|
      t.string :make
      t.string :year
      t.string :model
      t.string :engine

      t.timestamps
    end
  end
end
