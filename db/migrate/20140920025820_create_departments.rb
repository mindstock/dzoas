class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name
      t.string :remark
      t.integer :parent_id

      t.timestamps
    end
  end
end
