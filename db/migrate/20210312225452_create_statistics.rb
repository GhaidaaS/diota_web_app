class CreateStatistics < ActiveRecord::Migration[6.1]
  def change
    create_table :statistics do |t|
      t.references :upload, index: true, foreign_key: true
      t.integer :total_records
      t.integer :total_attacks
      t.integer :total_ddos
      t.integer :total_dos
      t.integer :total_theft
      t.integer :total_reconnaissance
      t.timestamps
    end
  end
end
