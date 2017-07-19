class CreateDescrips < ActiveRecord::Migration[5.1]
  def change
    create_table :descrips do |t|
      t.string :email

      t.timestamps
    end
  end
end
