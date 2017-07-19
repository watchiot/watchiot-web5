class CreateFaqs < ActiveRecord::Migration[5.1]
  def change
    create_table :faqs do |t|
      t.string :lang, default: 'en'
      t.string :question
      t.text :answer
    end
  end
end
