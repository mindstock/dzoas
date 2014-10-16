class CreateQuclityChecks < ActiveRecord::Migration
  def change
    create_table :quclity_checks do |t|
      t.integer :is_standard
      t.string :remark
      t.belongs_to :plan

      t.timestamps
    end
  end
end
