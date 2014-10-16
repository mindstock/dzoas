class AddRealFinalSheetToNickelclad < ActiveRecord::Migration
  def change
    add_column :nickelclads, :real_final_sheet, :string
  end
end
