class CreateListens < ActiveRecord::Migration
  def change
    create_table :listens do |t|
      t.integer :plan_type
      t.string :first_status
      t.string :last_status

      t.timestamps
    end
  end
end
