class AddRealFinalSheetToPlan < ActiveRecord::Migration
  def change
    add_column :plans, :real_final_sheet, :string
  end
end
