# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :name
      t.string :lastname
      t.string :phone
      t.string :document_type
      t.string :document_number

      t.references :merchant

      t.timestamps
    end
  end
end
