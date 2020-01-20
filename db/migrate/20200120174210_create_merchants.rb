class CreateMerchants < ActiveRecord::Migration[6.0]
  def change
    create_table :merchants do |t|
      t.string :rut
      t.string :business_name

      t.timestamps
    end
  end
end
