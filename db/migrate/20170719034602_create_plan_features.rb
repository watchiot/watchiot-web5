class CreatePlanFeatures < ActiveRecord::Migration[5.1]
  def change
    create_table :plan_features do |t|
      t.string :value

      t.timestamps
    end
  end
end
