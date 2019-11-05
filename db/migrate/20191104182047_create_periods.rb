class CreatePeriods < ActiveRecord::Migration[5.2]
  def change
    create_table :periods do |t|
      t.references :user, foreign_key: true
      t.datetime :started_at
      t.datetime :ended_at
      t.references :period_deletion, foreign_key: true

      t.timestamps
    end
  end
end
