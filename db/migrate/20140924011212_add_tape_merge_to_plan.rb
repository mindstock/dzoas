class AddTapeMergeToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :tape_merge, :string
  end
end
