class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.string :final_sheet
      t.string :final_piece
      t.string :final_row
      t.string :finish_at
      t.string :real_finish_at
      t.integer :is_urgency
      t.integer :status
      t.string :remark
      t.belongs_to :tape
      t.belongs_to :department

      t.timestamps
    end
  end
end
