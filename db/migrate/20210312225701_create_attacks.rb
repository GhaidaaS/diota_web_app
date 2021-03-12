class CreateAttacks < ActiveRecord::Migration[6.1]
  def change
    create_table :attacks do |t|
      t.references :upload, index: true, foreign_key: true
      t.string :source_ip
      t.string :source_port
      t.string :destination_ip
      t.string :destination_port
      t.string :duration
      t.string :sequence_id
      t.string :attack_type
      t.timestamps
    end
  end
end
