class CreateProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :projects do |t|
      t.string :name, length: 25
      t.text :description
      t.text :configuration
      t.boolean :ready, default: false
      t.boolean :status, default: true
      t.references :user
      t.references :space
      t.integer :user_owner_id
      t.string :repo_name

      t.timestamps
    end

    add_index :projects, :name
    add_index :projects, :user_owner_id
  end
end
