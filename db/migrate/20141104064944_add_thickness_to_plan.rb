class AddThicknessToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :thickness, :string
  end
end
