class CreateBags < ActiveRecord::Migration
  def change
    create_table :bags do |t|
      t.string :sheet
      t.integer :is_nickelclad_top
      t.belongs_to :nickelclad
      t.timestamps
    end
  end
end
