class AddUnsubscribeTokenToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :unsubscribe_token, :string
    add_column :users, :receive_notif, :boolean, defaul: true
  end
end
