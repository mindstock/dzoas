class CreateMerges < ActiveRecord::Migration
  def change
    create_table :merges do |t|
      t.string :merge
      t.string :thickness
      t.string :wide
      t.string :length
      t.string :allowance
      t.integer :is_declicacy
      t.integer :plan_id
      t.string :to
      t.string :final_sheet
      t.belongs_to :plan

      t.timestamps
    end
  end
end
