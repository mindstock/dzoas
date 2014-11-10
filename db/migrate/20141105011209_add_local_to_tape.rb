class AddLocalToTape < ActiveRecord::Migration
  def change
    add_column :tapes, :local, :string
  end
end
