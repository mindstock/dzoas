class AddIsAppendToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :is_append, :integer
  end
end
