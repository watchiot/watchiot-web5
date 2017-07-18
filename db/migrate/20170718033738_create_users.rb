class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username, limit: 25, unique: true
      t.string :first_name, limit: 25
      t.string :last_name, limit: 35
      t.text :address
      t.string :country_code, limit: 3
      t.string :phone, limit: 15
      t.boolean :status, default: true
      t.boolean :receive_notif_last_new, default: true
      t.string :passwd
      t.string :passwd_salt
      t.string :auth_token
      t.string :provider
      t.string :uid

      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :status
  end
end
