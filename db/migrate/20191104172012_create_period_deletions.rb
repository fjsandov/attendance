class CreatePeriodDeletions < ActiveRecord::Migration[5.2]
  def change
    create_table :period_deletions do |t|
      t.references :user, foreign_key: true
      t.text :reason

      t.timestamps
    end
  end
end
