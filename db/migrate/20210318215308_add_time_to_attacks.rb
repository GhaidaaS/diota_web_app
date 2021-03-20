class AddTimeToAttacks < ActiveRecord::Migration[6.1]
  def change
    add_column :attacks, :started_at, :timestamp
    add_column :attacks, :ended_at, :timestamp
  end
end
