class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :title
      t.string :content
      t.string :complete_at
      t.string :remark
      t.integer :type
      t.integer :status

      t.timestamps
    end
  end
end
