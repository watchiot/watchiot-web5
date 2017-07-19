class CreateEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :emails do |t|
      t.string :email, limit: 35
      t.boolean :checked, default: false
      t.boolean :primary, default: false
      t.references :user

      t.timestamps
    end

    add_index :emails, :email
  end
end
