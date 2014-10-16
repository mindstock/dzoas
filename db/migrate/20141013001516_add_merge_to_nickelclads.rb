class AddMergeToNickelclads < ActiveRecord::Migration
  def change
    add_column :nickelclads, :merge, :string
  end
end
