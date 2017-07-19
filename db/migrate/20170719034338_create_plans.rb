class CreatePlans < ActiveRecord::Migration[5.1]
  def change
    create_table :plans do |t|
      t.string :name
      t.decimal :amount_per_month

      t.timestamps
    end

    add_index :plans, :name
  end
end
