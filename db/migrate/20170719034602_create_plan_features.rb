class CreatePlanFeatures < ActiveRecord::Migration[5.1]
  def change
    create_table :plan_features do |t|
      t.references :plan
      t.references :feature
      t.string :value, limit: 20
    end
  end
end
