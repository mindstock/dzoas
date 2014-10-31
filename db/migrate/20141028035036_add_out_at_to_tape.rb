class AddOutAtToTape < ActiveRecord::Migration
  def change
    add_column :tapes, :out_at, :string
  end
end
