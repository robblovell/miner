class CreateCapstones < ActiveRecord::Migration
  def change
    create_table :capstones do |t|
      t.integer :index
      t.integer :number

      t.timestamps
    end
    seed = Capstone.create(:index => 0, :number => 2)
    seed.save


  end
end
