class CreateTeams < ActiveRecord::Migration[5.1]
  def change
    create_table :teams do |t|
      t.references :user
      t.integer :user_team_id # Identify a member of this team

      t.timestamps
    end

    add_index :teams, :user_team_id
  end
end
