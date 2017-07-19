class CreateVerifyClients < ActiveRecord::Migration[5.1]
  def change
    create_table :verify_clients do |t|
      t.string :token
      t.string :data
      t.string :concept
      t.references :user

      t.timestamps
    end

    add_index :verify_clients, :token
    add_index :verify_clients, :concept
  end
end
