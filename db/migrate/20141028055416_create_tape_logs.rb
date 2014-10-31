class CreateTapeLogs < ActiveRecord::Migration
  def change
    create_table :tape_logs do |t|
      t.integer :exec_type
      t.integer :num
      t.string :finish_at
      t.belongs_to :tape
      t.timestamps
    end
  end
end
