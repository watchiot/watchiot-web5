class CreateCharts < ActiveRecord::Migration[5.1]
  def change
    create_table :charts do |t|
      t.references :project
      t.references :space
      t.references :user

      t.timestamps
    end
  end
end
