class CreateApiKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :api_keys do |t|
      t.string :api_key

      t.timestamps
    end

    add_index :api_keys, :api_key, unique: true
  end
end
