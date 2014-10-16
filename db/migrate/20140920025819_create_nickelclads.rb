class CreateNickelclads < ActiveRecord::Migration
  def change
    create_table :nickelclads do |t|
      t.string :thickness
      t.string :wide
      t.string :length
      t.string :to
      t.string :allowance
      t.integer :is_declicacy
      t.integer :status
      t.belongs_to :plan

      t.timestamps
    end
  end
end
