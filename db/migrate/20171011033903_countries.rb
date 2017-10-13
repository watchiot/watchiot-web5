class Countries < ActiveRecord::Migration[5.1]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :code
      t.string :prefix
    end
  end
end
