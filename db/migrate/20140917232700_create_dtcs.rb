class CreateDtcs < ActiveRecord::Migration
  def change
    create_table :dtcs do |t|
      t.string :code
      t.string :description
      t.string :meaning
      t.string :system
      t.string :source

      t.timestamps
    end
  end
end
