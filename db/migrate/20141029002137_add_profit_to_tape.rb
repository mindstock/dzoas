class AddProfitToTape < ActiveRecord::Migration
  def change
    add_column :tapes, :profit, :string
  end
end
