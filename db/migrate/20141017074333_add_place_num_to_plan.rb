class AddPlaceNumToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :place_num, :integer
  end
end
