class ChangeAttackTypeToInteger < ActiveRecord::Migration[6.1]
  def change
    change_column :attacks, :attack_type, 'integer USING CAST(attack_type AS integer)'
  end
end
