class CreateDtcsFitments < ActiveRecord::Migration
  def change
    create_table :dtcs_fitments, :id => false do |t|
      t.integer :dtc_id
      t.integer :fitment_id
    end
  end
end
