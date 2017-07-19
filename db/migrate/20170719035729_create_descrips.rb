class CreateDescrips < ActiveRecord::Migration[5.1]
  def change
    create_table :descrips do |t|
      t.string :title
      t.string :description
      t.string :icon
      t.string :lang, default: 'en'
    end
  end
end
