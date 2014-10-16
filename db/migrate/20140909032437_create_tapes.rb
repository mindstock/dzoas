class CreateTapes < ActiveRecord::Migration
  def change
    create_table :tapes do |t|
      t.string :from
      t.string :place
      t.string :texture
      t.string :thickness
      t.string :wide
      t.string :length
      t.integer :raw_weight
      t.integer :put_weight
      t.integer :out_weight
      t.integer :residue_weight
      t.string :tape_num
      t.integer :status
      t.timestamps
    end
  end
end
