# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :first_name
      t.string :last_name
      t.string :nickname
      t.string :birthday
      t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false, :default => ""
      t.json :tokens
      t.timestamps null: false
    end

    add_index :users, [:uid, :provider],     unique: true
    add_index :users, :email,                unique: true
  end
end
