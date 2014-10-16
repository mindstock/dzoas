class AddMergeToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :merge, :string
  end
end
