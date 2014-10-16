class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :name
      t.string :phone
      t.string :address
      t.string :remark
      t.belongs_to :department
      t.timestamps
    end
  end
end
