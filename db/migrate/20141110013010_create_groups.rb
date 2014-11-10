class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :title
      t.string :remark
      t.references :manager

      t.timestamps
    end
  end
end
