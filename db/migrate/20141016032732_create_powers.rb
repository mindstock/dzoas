class CreatePowers < ActiveRecord::Migration
  def change
    create_table :powers do |t|
      t.references :parent
      t.string :name
      t.string :url
      t.string :remark

      t.timestamps
    end
    create_table :roles_powers, id: false do |t|
      t.belongs_to :role
      t.belongs_to :power
    end
  end
end
