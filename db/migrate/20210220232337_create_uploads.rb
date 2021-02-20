class CreateUploads < ActiveRecord::Migration[6.1]
  def change
    create_table :uploads do |t|
      t.integer :status
      t.references :user, index: true, foreign_key: true
      t.datetime :finished_at
      t.timestamps
    end
  end
end
