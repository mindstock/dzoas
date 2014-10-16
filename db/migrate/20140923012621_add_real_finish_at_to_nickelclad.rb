class AddRealFinishAtToNickelclad < ActiveRecord::Migration
  def change
    add_column :nickelclads, :real_finish_at, :string
  end
end
